import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infotune/widgets/app_bar.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  MusicScreenState createState() => MusicScreenState();
}

class MusicScreenState extends State<MusicScreen> {
  List<dynamic> tracks = [];
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;

  Future<void> searchMusic(String query) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://infotune.onrender.com/music?query=$query'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          tracks = data;
        });
      } else {
        throw Exception('Failed to load music');
      }
    } catch (e) {
      print("Error fetching music: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Music"),
      body: Container(
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
                            hintText: 'Search for music...',
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
                            searchMusic(query);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Music List
              Expanded(
                child: tracks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _isLoading
                                  ? "Searching for music..."
                                  : "No tracks found. Try searching!",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_isLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: tracks.length,
                        itemBuilder: (context, index) {
                          final track = tracks[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  track['cover_image'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                track['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                track['artist'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onTap: () {
                                // Open Deezer track
                                // launchURL(track['deezer_url']);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void launchURL(String url) async {
  //   // Open the Deezer link in a browser
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     print("Could not open $url");
  //   }
  // }
}
