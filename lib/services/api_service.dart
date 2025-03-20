import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:1865/";


  Future<http.Response> getQuestions(String prompt) async {
    final url = Uri.parse(baseUrl);
    
    
    final payload = {
      'text': prompt,
    };

    final headers = {
      'Content-Type': 'application/json',
    };
    try {

      final response = await http.post(
        Uri.parse(baseUrl +'message'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );
      
      if (response.statusCode != 200) {
        throw Exception('API call failed with status: ${response.statusCode}');
      }
      
      final responseData = jsonDecode(response.body);
      // Extract content from the response according to the schema
      final responseText = responseData['content'] as String;

      print('response: $responseText');

      return response;
      
    
    } catch (e) {
      throw Exception("Failed to make POST request: $e");
    }
  }
}