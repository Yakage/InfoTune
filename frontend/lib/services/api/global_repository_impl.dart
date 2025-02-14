import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:infotune/services/repositories/global_repository.dart';

class GlobalRepositoryImpl extends GlobalRepository {
  final String baseUrl = "https://infotune.onrender.com";

  @override
  Future<String> fetchDefinition(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/dictionary?word=$word'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return data[0]['meanings'][0]['definitions'][0]['definition'] as String;
      } else {
        return "No definition found for '$word'.";
      }
    } catch (e) {
      return "Error fetching definition. Please try again.";
    }
  }
}
