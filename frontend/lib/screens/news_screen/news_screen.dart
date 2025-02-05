import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final response =
        await http.get(Uri.parse('http://192.168.1.133:5000/news'));
    if (response.statusCode == 200) {
      setState(() {
        newsArticles = json.decode(response.body)['articles'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News')),
      body: ListView.builder(
        itemCount: newsArticles.length,
        itemBuilder: (context, index) {
          final article = newsArticles[index];
          return ListTile(
            title: Text(article['title']),
            subtitle: Text(article['description'] ?? ''),
          );
        },
      ),
    );
  }
}
