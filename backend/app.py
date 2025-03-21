import random
from flask import Flask, jsonify, request
from flask_cors import CORS
import requests

app = Flask(__name__)
CORS(app)

# API Keys & URLs
NEWS_API_KEY = "5f4824de016746068c01edf77bb235c4"  
NEWS_API_URL = "https://newsapi.org/v2/top-headlines"
DICTIONARY_API_URL = "https://api.dictionaryapi.dev/api/v2/entries/en"
DEEZER_SEARCH_URL = "https://api.deezer.com/search"

# -------------------- NEWS API ENDPOINTS --------------------

# 1. Get Top Headlines
@app.route("/top-headlines", methods=["GET"])
def get_top_headlines():
    # Fetches the latest top headlines from the News API.
    country = request.args.get("country", "")
    category = request.args.get("category", "")
    
    params = {"apiKey": NEWS_API_KEY, "country": country, "category": category}
    response = requests.get(NEWS_API_URL, params=params)
    return jsonify(response.json())

# 2. Get News by Source
@app.route("/news-by-source", methods=["GET"])
def get_news_by_source():
    # Fetches news from a specific source.
    source = request.args.get("source", "bbc-news")
    
    params = {"apiKey": NEWS_API_KEY, "sources": source}
    response = requests.get(NEWS_API_URL, params=params)
    return jsonify(response.json())

# 3. Search for News by Keyword
@app.route("/news-search", methods=["GET"])
def search_news():
    # Fetches news articles that match a specific keyword.
    query = request.args.get("q")
    if not query:
        return jsonify({"error": "Query parameter is required"}), 400

    params = {"apiKey": NEWS_API_KEY, "q": query}
    response = requests.get(NEWS_API_URL, params=params)
    return jsonify(response.json())

# -------------------- DICTIONARY API ENDPOINTS --------------------

# 1. Get Word Definition
@app.route("/word-definition", methods=["GET"])
def get_word_definition():
    # Fetches the definition of a given word.
    word = request.args.get("word")
    if not word:
        return jsonify({"error": "Word parameter is required"}), 400

    response = requests.get(f"{DICTIONARY_API_URL}/{word}")
    return jsonify(response.json())

# 2. Get Synonyms for a Word
@app.route("/synonyms", methods=["GET"])
def get_synonyms():
    # Fetches synonyms of a given word.
    word = request.args.get("word")
    if not word:
        return jsonify({"error": "Word parameter is required"}), 400

    response = requests.get(f"{DICTIONARY_API_URL}/{word}")
    data = response.json()

    synonyms = []
    for meaning in data[0].get("meanings", []):
        for definition in meaning.get("definitions", []):
            if "synonyms" in definition:
                synonyms.extend(definition["synonyms"])

    return jsonify({"word": word, "synonyms": list(set(synonyms))})

# 3. Get Antonyms for a Word
@app.route("/antonyms", methods=["GET"])
def get_antonyms():
    # Fetches antonyms of a given word.
    word = request.args.get("word")
    if not word:
        return jsonify({"error": "Word parameter is required"}), 400

    response = requests.get(f"{DICTIONARY_API_URL}/{word}")
    data = response.json()

    antonyms = []
    for meaning in data[0].get("meanings", []):
        for definition in meaning.get("definitions", []):
            if "antonyms" in definition:
                antonyms.extend(definition["antonyms"])

    return jsonify({"word": word, "antonyms": list(set(antonyms))})

# -------------------- MUSIC API (DEEZER) ENDPOINTS --------------------

@app.route("/music/search", methods=["GET"])
def search_music():
    query = request.args.get("query", "a")  # Default query if none is provided
    response = requests.get(f"{DEEZER_SEARCH_URL}?q={query}")
    
    if response.status_code == 200:
        data = response.json().get("data", [])
        if data:
            results = [
                {
                    "title": track.get("title"),
                    "artist": track.get("artist", {}).get("name", "Unknown"),
                    "cover_image": track.get("album", {}).get("cover_medium"),
                    "deezer_url": track.get("preview"),
                }
                for track in data
            ]
            return jsonify(results)

    return jsonify({"error": "No music found"}), 404



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)