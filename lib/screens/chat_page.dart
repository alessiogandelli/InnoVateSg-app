import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:innovate/services/stregatto.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LlmChatView(
      provider: StregattoProvider(apiEndpoint: 'http://localhost:1865/', apiKey: '')
    );
  }
}
