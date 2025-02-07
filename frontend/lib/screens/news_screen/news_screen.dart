import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infotune/widgets/news_widgets/news_catalogs_widget.dart';
import 'package:infotune/widgets/news_widgets/news_trending_widget.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  NewsScreenState createState() => NewsScreenState();
}

class NewsScreenState extends State<NewsScreen> {
  List<dynamic> newsArticles = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.133:5000/news'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('articles')) {
          setState(() {
            newsArticles = data['articles'];
          });
        }
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print("Error fetching news: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for news...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
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
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: newsArticles.length,
                itemBuilder: (context, index) {
                  final article = newsArticles[index];
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
            _buildCategorySection('Fashion'),
            _buildCategorySection('Sports'),
            _buildCategorySection('Games'),
            _buildCategorySection('Celebrity'),
          ],
        ),
      ),
    );
  }

  // Helper method to build a category section
  Widget _buildCategorySection(String category) {
    List filteredArticles = newsArticles.where((article) {
      String? articleTitle = article['title']?.toString().toLowerCase();
      return articleTitle != null &&
          articleTitle.contains(category.toLowerCase());
    }).toList();

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
            ),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filteredArticles.length,
            itemBuilder: (context, index) {
              final article = filteredArticles[index];
              return CategoryNewsCard(
                category: category,
                title: article['title'] ?? "No Title",
                description: article['description'] ?? "No Description",
                image:
                    article['urlToImage'] ?? "https://via.placeholder.com/200",
                publishedAt: article['publishedAt'] ?? "Unknown Date",
              );
            },
          ),
        ),
      ],
    );
  }
}
