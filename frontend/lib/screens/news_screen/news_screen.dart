import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infotune/screens/news_screen/search_result_page.dart';
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

  Future<void> fetchNews() async {
    try {
      String url = 'https://infotune.onrender.com/news';
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
        String url = 'https://infotune.onrender.com/news?category=$category';

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

  void showNewsDialog(BuildContext context, Map<String, dynamic> article) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade800,
                  Colors.blue.shade600,
                  Colors.blue.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article['title'] ?? "No Title",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image
                  if (article['urlToImage'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        article['urlToImage'],
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    article['description'] ?? "No Description Available",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Published Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Published at: ${article['publishedAt'] ?? "Unknown Date"}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Close Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
                            onSubmitted: (query) {
                              if (query.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SearchResultsScreen(query: query),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            String query = _controller.text.trim();
                            if (query.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchResultsScreen(query: query),
                                ),
                              );
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
                      return GestureDetector(
                        onTap: () => showNewsDialog(context, article),
                        child: TrendingNewsCard(
                          title: article['title'] ?? "No Title",
                          description:
                              article['description'] ?? "No Description",
                          image: article['urlToImage'] ??
                              "https://via.placeholder.com/200",
                        ),
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
              return GestureDetector(
                onTap: () => showNewsDialog(context, article!),
                child: CategoryNewsCard(
                  category: category,
                  title: article?['title'] ?? "No Title",
                  description: article?['description'] ?? "No Description",
                  image: article?['urlToImage'] ??
                      "https://via.placeholder.com/200",
                  publishedAt: article?['publishedAt'] ?? "Unknown Date",
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
