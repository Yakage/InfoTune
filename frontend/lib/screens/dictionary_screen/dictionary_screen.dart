import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  DictionaryScreenState createState() => DictionaryScreenState();
}

class DictionaryScreenState extends State<DictionaryScreen> {
  String definition = '';
  final TextEditingController _controller = TextEditingController();

  Future<void> fetchDefinition(String word) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.133:5000/dictionary?word=$word'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        definition = data[0]['meanings'][0]['definitions'][0]['definition'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dictionary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter a word'),
            ),
            ElevatedButton(
              onPressed: () {
                fetchDefinition(_controller.text);
              },
              child: Text('Search'),
            ),
            SizedBox(height: 20),
            Text(definition),
          ],
        ),
      ),
    );
  }
}
