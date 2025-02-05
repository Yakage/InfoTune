InfoTune

InfoTune is a Flutter-powered mobile application that integrates News, Dictionary, and Music functionalities using a Python (Flask) backend. It provides real-time news updates, word definitions, and music search capabilities in one seamless experience.

📌 Features

Latest News 📰 - Fetch and display the latest news articles from various categories.

Dictionary Lookup 📖 - Look up definitions, synonyms, and examples for any word.

Music Search 🎵 - Search for music tracks and view their details.

🛠 Tech Stack

Frontend (Flutter - Dart)

Cross-platform framework for building beautiful and fast UIs.

HTTP requests handled using the http package.

Backend (Python - Flask)

Lightweight web framework for creating RESTful APIs.

Flask-CORS for handling Cross-Origin Resource Sharing (CORS).

External APIs Used

NewsAPI - Fetches news articles.

DictionaryAPI - Provides word definitions.

Spotify API - Searches for music tracks.

🚀 Getting Started

1️⃣ Prerequisites

Install Flutter SDK: Download Here

Install Python 3.x: Download Here

Obtain API keys:

Get a free NewsAPI key: NewsAPI

Register your app on Spotify Developer to get SPOTIFY_CLIENT_ID and SPOTIFY_CLIENT_SECRET: Spotify Developer

2️⃣ Backend Setup

Clone the repository:

git clone https://github.com/yourusername/infotune.git
cd infotune/backend

Install dependencies:

pip install -r requirements.txt

Set up environment variables:
Create a .env file in the backend directory and add the following:

NEWS_API_KEY=your_news_api_key
SPOTIFY_CLIENT_ID=your_spotify_client_id
SPOTIFY_CLIENT_SECRET=your_spotify_client_secret

Run the Flask server:

python app.py

The backend will be available at http://127.0.0.1:5000

3️⃣ Frontend Setup

Navigate to the frontend directory:

cd ../frontend

Update the backend URL:
Open lib/services/api_service.dart and replace http://10.0.2.2:5000 with your backend URL (e.g., http://127.0.0.1:5000 for local development).

Run the Flutter app:

flutter pub get
flutter run

📁 Project Structure

infotune/
├── backend/
│   ├── app.py          # Flask application
│   ├── requirements.txt # Python dependencies
│   └── .env            # Environment variables
├── frontend/
│   ├── lib/
│   │   ├── main.dart       # Entry point
│   │   ├── screens/       # App screens (news, dictionary, music)
│   │   ├── services/      # API service classes
│   │   └── widgets/       # Reusable UI components
│   ├── pubspec.yaml     # Flutter dependencies
│   └── assets/         # Images, fonts, etc.

📡 API Endpoints

Endpoint

Method

Description

/news

GET

Fetches news articles (query params: country, category)

/dictionary

GET

Fetches word definitions (query param: word)

/music

GET

Searches for music tracks (query param: query)

🤝 Contributing

Contributions are welcome! To contribute:

Fork the repository.

Create a new branch:

git checkout -b feature/your-feature

Commit your changes:

git commit -m 'Add some feature'

Push to the branch:

git push origin feature/your-feature

Open a pull request.

📜 License

This project is open-source and available under the MIT License.

🙌 Acknowledgments

NewsAPI for providing news data.

DictionaryAPI for word definitions.

Spotify for music metadata.

📬 Contact

For questions or feedback, feel free to reach out:

Email: your.email@example.com

GitHub: yourusername

🚀 Enjoy using InfoTune! 🎉

