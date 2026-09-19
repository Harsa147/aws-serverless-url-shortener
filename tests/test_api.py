import json
import sys
import urllib.error
import urllib.request

API_URL = "https://i52f5eqs46.execute-api.us-east-1.amazonaws.com/default/url-shortener"


def post_url(url):
    data = json.dumps({"url": url}).encode("utf-8")

    request = urllib.request.Request(
        API_URL,
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST"
    )

    with urllib.request.urlopen(request, timeout=10) as response:
        return response.status, json.loads(response.read().decode("utf-8"))


def get_redirect(code):
    request = urllib.request.Request(
        f"{API_URL}/{code}",
        method="GET"
    )

    class NoRedirectHandler(urllib.request.HTTPRedirectHandler):
        def redirect_request(self, req, fp, code, msg, headers, newurl):
            return None

    opener = urllib.request.build_opener(NoRedirectHandler)

    try:
        opener.open(request, timeout=10)
    except urllib.error.HTTPError as error:
        return error.code, error.headers.get("Location")

    return None, None


def test_create_url():
    status, result = post_url("https://www.google.com")

    assert status == 200
    assert "code" in result
    assert result["original_url"] == "https://www.google.com"

    return result["code"]


def test_redirect(code):
    status, location = get_redirect(code)

    assert status == 301
    assert location == "https://www.google.com"


def test_invalid_url():
    try:
        post_url("google.com")
    except urllib.error.HTTPError as error:
        body = json.loads(error.read().decode("utf-8"))

        assert error.code == 400
        assert "Invalid URL" in body["error"]
        return

    raise AssertionError("Invalid URL was accepted")


def test_missing_url():
    data = json.dumps({}).encode("utf-8")

    request = urllib.request.Request(
        API_URL,
        data=data,
        headers={"Content-Type": "application/json"},
        method="POST"
    )

    try:
        urllib.request.urlopen(request, timeout=10)
    except urllib.error.HTTPError as error:
        body = json.loads(error.read().decode("utf-8"))

        assert error.code == 400
        assert body["error"] == "URL is required"
        return

    raise AssertionError("Missing URL was accepted")


if __name__ == "__main__":
    print("Testing URL creation...")
    code = test_create_url()
    print(f"PASS: Created short code {code}")

    print("Testing redirect...")
    test_redirect(code)
    print("PASS: Redirect works")

    print("Testing invalid URL...")
    test_invalid_url()
    print("PASS: Invalid URL rejected")

    print("Testing missing URL...")
    test_missing_url()
    print("PASS: Missing URL rejected")

    print("\nAll API tests passed!")