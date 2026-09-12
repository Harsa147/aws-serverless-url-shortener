const API_URL = "https://i52f5eqs46.execute-api.us-east-1.amazonaws.com/default/url-shortener";
const CREATE_URL = API_URL;

const form = document.getElementById("shortenForm");
const urlInput = document.getElementById("urlInput");
const shortenButton = document.getElementById("shortenButton");

const loading = document.getElementById("loading");
const result = document.getElementById("result");
const shortUrl = document.getElementById("shortUrl");
const copyButton = document.getElementById("copyButton");
const copyMessage = document.getElementById("copyMessage");
const errorMessage = document.getElementById("errorMessage");

form.addEventListener("submit", async (event) => {
    event.preventDefault();

    const originalUrl = urlInput.value.trim();

    if (!originalUrl) {
        showError("Please enter a URL.");
        return;
    }

    loading.classList.remove("hidden");
    result.classList.add("hidden");
    errorMessage.classList.add("hidden");
    shortenButton.disabled = true;

    try {
        const response = await fetch(CREATE_URL, {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            url: originalUrl
        })
    });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.error || "Failed to create short URL.");
        }

        const code = data.code;

        const generatedShortUrl = `${API_URL}/${code}`;

        shortUrl.href = generatedShortUrl;
        shortUrl.textContent = generatedShortUrl;

        result.classList.remove("hidden");

    } catch (error) {
        showError(error.message);
    } finally {
        loading.classList.add("hidden");
        shortenButton.disabled = false;
    }
});


copyButton.addEventListener("click", async () => {
    try {
        await navigator.clipboard.writeText(shortUrl.href);

        copyMessage.textContent = "Copied!";
        
        setTimeout(() => {
            copyMessage.textContent = "";
        }, 2000);

    } catch (error) {
        copyMessage.textContent = "Copy failed.";
    }
});


function showError(message) {
    errorMessage.textContent = message;
    errorMessage.classList.remove("hidden");
}