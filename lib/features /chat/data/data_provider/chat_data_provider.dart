import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatDataProvider {
  Future<String> getData(message) async {
    try {
      String apiKey = dotenv.env['API_KEY'] ?? '';
      final header = {
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> requestBody = {
        'contents': [
          {
            'parts': [
              {
                'text': message,
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.8,
          'maxOutputTokens': 1000,
        }
      };

      String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

      var response = await http.post(
        Uri.parse(url),
        headers: header,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        return jsonResponse['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Internal Server !';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
