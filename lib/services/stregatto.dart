

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:http/http.dart' as http;

class StregattoProvider extends LlmProvider with ChangeNotifier {
  final String apiEndpoint;
  final String apiKey;
  final List<ChatMessage> _history;
  
  StregattoProvider({
    required this.apiEndpoint,
    required this.apiKey,
    Iterable<ChatMessage>? history,
  }) : _history = history?.toList() ?? [];
  
  @override
  Stream<String> generateStream(
    String prompt, 
    {Iterable<Attachment> attachments = const []}
  ) async* {
    try {
      // Prepare request payload based on the provided curl example
      final payload = {
        'text': prompt,
      };

      print('Payload: $payload');
      
      // Make API call to your AI agent
      final response = await http.post(
        Uri.parse(apiEndpoint+'message'),
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
      
      // Return the response as a stream
      yield responseText;
    } catch (e) {
      yield "Error communicating with AI agent: $e";
    }
  }
  
  @override
  Stream<String> sendMessageStream(
    String prompt, 
    {Iterable<Attachment> attachments = const []}
  ) async* {
    final userMessage = ChatMessage.user(prompt, attachments);
    final llmMessage = ChatMessage.llm();
    
    _history.addAll([userMessage, llmMessage]);
    notifyListeners();
    
    try {
      final response = generateStream(
        prompt, 
        attachments: attachments,
      );
      
      await for (final chunk in response) {
        llmMessage.append(chunk);
        yield chunk;
      }
    } catch (e) {
      final errorMessage = "Error: $e";
      llmMessage.append(errorMessage);
      yield errorMessage;
    }
    
    notifyListeners();
  }
  
  @override
  Iterable<ChatMessage> get history => _history;



  
  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }
}
