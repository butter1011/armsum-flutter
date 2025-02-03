
import 'dart:convert';
import 'package:http/http.dart' as http;

class SummaryController {
  static const String apiUrl = 'https://article-extractor-and-summarizer.p.rapidapi.com/summarize';
  static const String apiKey = '430e37f3ecmshe2d7253b695e856p119bf4jsn54aa0cf62739';

  Future<String> getSummary(String articleUrl) async {
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
        return data['summary'] ?? 'No summary available';
      } else {
        throw Exception('Failed to fetch summary: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting summary: $e');
    }
  }
}
