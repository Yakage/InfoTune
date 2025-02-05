import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  MusicScreenState createState() => MusicScreenState();
}

class MusicScreenState extends State<MusicScreen> {
  List<dynamic> tracks = [];
  final TextEditingController _controller = TextEditingController();

  Future<void> searchMusic(String query) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.133:5000/music?query=$query'));
    if (response.statusCode == 200) {
      setState(() {
        tracks = json.decode(response.body)['tracks']['items'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Music')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Search for music'),
            ),
            ElevatedButton(
              onPressed: () {
                searchMusic(_controller.text);
              },
              child: Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tracks.length,
                itemBuilder: (context, index) {
                  final track = tracks[index];
                  return ListTile(
                    title: Text(track['name']),
                    subtitle: Text(track['artists'][0]['name']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
