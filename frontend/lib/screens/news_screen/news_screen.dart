import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infotune/widgets/app_bar.dart';
import 'package:infotune/widgets/news_widgets/news_catalogs_widget.dart';
import 'package:infotune/widgets/news_widgets/news_trending_widget.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  List<dynamic> trendingArticles = [];
  Map<String, List<dynamic>> categoryArticles = {
    'Business': [],
    'Sports': [],
    'Technology': [],
    'Entertainment': [],
  };

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchNews(); // Fetch trending news
    fetchCategoryNews(); // Fetch all category news
  }

  Future<void> fetchNews({String? searchQuery}) async {
    try {
      String url = 'http://192.168.1.133:5000/news';
      if (searchQuery != null) {
        url += '?q=$searchQuery';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('articles')) {
          setState(() {
            trendingArticles = data['articles'];
          });
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print("Error fetching news: $e");
    }
  }

  Future<void> fetchCategoryNews() async {
    for (String category in categoryArticles.keys) {
      try {
        String url = 'http://192.168.1.133:5000/news?category=$category';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data.containsKey('articles')) {
            setState(() {
              categoryArticles[category] = data['articles'];
            });
          }
        } else {
          throw Exception('Failed to load $category news');
        }
      } catch (e) {
        print("Error fetching $category news: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "News"),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.shade800,
                Colors.blue.shade600,
                Colors.blue.shade400,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Search trending news...',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            String query = _controller.text.trim();
                            if (query.isNotEmpty) {
                              fetchNews(searchQuery: query);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Trending Section
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Trending',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingArticles.length,
                    itemBuilder: (context, index) {
                      final article = trendingArticles[index];
                      return TrendingNewsCard(
                        title: article['title'] ?? "No Title",
                        description: article['description'] ?? "No Description",
                        image: article['urlToImage'] ??
                            "https://via.placeholder.com/200",
                      );
                    },
                  ),
                ),
                // Categories Section
                for (String category in categoryArticles.keys)
                  _buildCategorySection(category),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            category,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categoryArticles[category]?.length ?? 0,
            itemBuilder: (context, index) {
              final article = categoryArticles[category]?[index];
              return CategoryNewsCard(
                category: category,
                title: article?['title'] ?? "No Title",
                description: article?['description'] ?? "No Description",
                image: article?['urlToImage'] ?? "https://via.placeholder.com/200?text=No+Image+Available",
                publishedAt: article?['publishedAt'] ?? "Unknown Date",
              );
            },
          ),
        ),
      ],
    );
  }
}
