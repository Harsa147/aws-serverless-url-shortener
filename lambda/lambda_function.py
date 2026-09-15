import json
import boto3
import uuid
from urllib.parse import urlparse

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("url-mappings")


def is_valid_url(url):
    try:
        parsed = urlparse(url)

        return (
            parsed.scheme in ("http", "https")
            and bool(parsed.netloc)
        )

    except Exception:
        return False


def lambda_handler(event, context):

    try:

        # Get HTTP method
        method = event.get("requestContext", {}).get("http", {}).get("method")


        # --------------------------------
        # GET /url-shortener/{code}
        # --------------------------------
        if method == "GET":

            code = event.get("pathParameters", {}).get("code")

            if not code:
                return {
                    "statusCode": 400,
                    "body": json.dumps({
                        "error": "Short code is required"
                    })
                }

            response = table.get_item(
                Key={
                    "code": code
                }
            )

            item = response.get("Item")

            if not item:
                return {
                    "statusCode": 404,
                    "body": json.dumps({
                        "error": "Short URL not found"
                    })
                }

            return {
                "statusCode": 301,
                "headers": {
                    "Location": item["original_url"]
                },
                "body": ""
            }


        # --------------------------------
        # POST /url-shortener
        # --------------------------------

        body = json.loads(event.get("body", "{}"))

        original_url = body.get("url")

        # Check if URL exists
        if not original_url:
            return {
                "statusCode": 400,
                "body": json.dumps({
                    "error": "URL is required"
                })
            }

        # Make sure URL is a string
        if not isinstance(original_url, str):
            return {
                "statusCode": 400,
                "body": json.dumps({
                    "error": "URL must be a string"
                })
            }

        # Remove accidental spaces
        original_url = original_url.strip()

        # Validate URL
        if not is_valid_url(original_url):
            return {
                "statusCode": 400,
                "body": json.dumps({
                    "error": "Invalid URL. Only HTTP and HTTPS URLs are allowed."
                })
            }

        # Generate short code
        short_code = str(uuid.uuid4())[:8]

        # Store in DynamoDB
        table.put_item(
            Item={
                "code": short_code,
                "original_url": original_url
            }
        )

        # Return response
        return {
            "statusCode": 200,
            "body": json.dumps({
                "code": short_code,
                "original_url": original_url
            })
        }


    except json.JSONDecodeError:

        return {
            "statusCode": 400,
            "body": json.dumps({
                "error": "Invalid JSON request"
            })
        }


    except Exception:

        # Do not expose internal error details
        return {
            "statusCode": 500,
            "body": json.dumps({
                "error": "Internal server error"
            })
        }