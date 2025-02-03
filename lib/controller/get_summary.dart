import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class SummaryController {
  
  final String apiKey = dotenv.get('apiKey');
  final String apiUrl = dotenv.get('apiUrl');

  Future<Map<String, dynamic>> getSummary(String articleUrl) async {
    print("This is apiKey>>>>>>>>>>>>>>>>>>>>> $apiKey");
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?url=${Uri.encodeComponent(articleUrl)}&length=3'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'article-extractor-and-summarizer.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {'success': true, 'data': data['summary']};
      } else {
        return {
          'success': false,
        };
      }
    } catch (e) {
      return {'success': false, 'data': e.toString()};
    }
  }
}
