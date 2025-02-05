from flask import Flask, jsonify, request
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

# News API
NEWS_API_KEY = "5f4824de016746068c01edf77bb235c4"  # Get from https://newsapi.org/
NEWS_API_URL = "https://newsapi.org/v2/top-headlines"

# Dictionary API
DICTIONARY_API_URL = "https://api.dictionaryapi.dev/api/v2/entries/en"

# Spotify API (for music)
SPOTIFY_CLIENT_ID = "your_spotify_client_id"
SPOTIFY_CLIENT_SECRET = "your_spotify_client_secret"
SPOTIFY_TOKEN_URL = "https://accounts.spotify.com/api/token"
SPOTIFY_SEARCH_URL = "https://api.spotify.com/v1/search"

# Get Spotify access token
def get_spotify_token():
    auth_response = requests.post(
        SPOTIFY_TOKEN_URL,
        data={"grant_type": "client_credentials"},
        auth=(SPOTIFY_CLIENT_ID, SPOTIFY_CLIENT_SECRET),
    )
    return auth_response.json().get("access_token")

# News Endpoint
@app.route("/news", methods=["GET"])
def get_news():
    params = {
        "apiKey": NEWS_API_KEY,
        "country": request.args.get("country", "us"),
        "category": request.args.get("category", "general"),
    }
    response = requests.get(NEWS_API_URL, params=params)
    return jsonify(response.json())

# Dictionary Endpoint
@app.route("/dictionary", methods=["GET"])
def get_definition():
    word = request.args.get("word")
    if not word:
        return jsonify({"error": "Word parameter is required"}), 400

    response = requests.get(f"{DICTIONARY_API_URL}/{word}")
    return jsonify(response.json())

# Music Endpoint
@app.route("/music", methods=["GET"])
def search_music():
    query = request.args.get("query")
    if not query:
        return jsonify({"error": "Query parameter is required"}), 400

    token = get_spotify_token()
    headers = {"Authorization": f"Bearer {token}"}
    params = {"q": query, "type": "track", "limit": 10}
    response = requests.get(SPOTIFY_SEARCH_URL, headers=headers, params=params)
    return jsonify(response.json())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)