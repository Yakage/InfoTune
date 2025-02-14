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

# Deezer API (Free & No Auth Required)
DEEZER_SEARCH_URL = "https://api.deezer.com/search"

# News Endpoint
@app.route("/news", methods=["GET"])
def get_news():
    category = request.args.get("category", "general")
    query = request.args.get("q")

    params = {
        "apiKey": NEWS_API_KEY,
        "country": "us",
        "category": category,
    }

    if query:
        params["q"] = query

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

# Music Endpoint using Deezer API
@app.route("/music", methods=["GET"])
def search_music():
    query = request.args.get("query")
    if not query:
        return jsonify({"error": "Query parameter is required"}), 400

    response = requests.get(f"{DEEZER_SEARCH_URL}?q={query}")
    if response.status_code != 200:
        return jsonify({"error": "Failed to fetch music data"}), 500

    data = response.json()
    
    # Extracting relevant data
    music_results = []
    for track in data.get("data", []):
        music_results.append({
            "title": track["title"],
            "artist": track["artist"]["name"],
            "album": track["album"]["title"],
            "preview_url": track["preview"],  # 30-second preview link
            "deezer_url": track["link"],  # Full track on Deezer
            "cover_image": track["album"]["cover_medium"],
        })

    return jsonify(music_results)

if __name__ == "__main__":
    app.run()
