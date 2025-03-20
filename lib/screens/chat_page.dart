import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:innovate/services/stregatto.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: const Text(
              "I'm your Innovation Coach! I can help you brainstorm ideas, refine concepts, and navigate innovation challenges. What are you working on today?",
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Expanded(
            child: LlmChatView(
              provider: StregattoProvider(apiEndpoint: 'http://localhost:1865/', apiKey: ''),
              style: LlmChatViewStyle(
                backgroundColor: Colors.grey[50],
                progressIndicatorColor: Colors.blue[700],
                userMessageStyle: UserMessageStyle(
                  
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(16),
                ),
                
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
