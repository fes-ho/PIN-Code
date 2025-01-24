import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/src/config.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/src/features/profile/application/profile_service.dart';

class ChatbotWidget extends StatelessWidget {
  const ChatbotWidget({super.key});

  void _openChatDialog(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => const ChatDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<String>(
                    future: GetIt.I<ProfileService>().getUsername(),
                    builder: (context, snapshot) {
                      final username = snapshot.data ?? 'there';
                      return Text(
                        'Hi $username, what do',
                        style: GoogleFonts.quicksand(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      );
                    },
                  ),
                  Text(
                    'you want to do today?',
                    style: GoogleFonts.quicksand(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                backgroundColor: Colors.lightGreen[100],
                radius: 25,
                child: Icon(
                  Icons.chat_bubble_rounded,
                  color: Colors.green[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => _openChatDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Need ideas? Chat with me.',
                    style: GoogleFonts.quicksand(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.green[700],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatDialog extends StatefulWidget {
  const ChatDialog({super.key});

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final AIChatService _aiService = AIChatService();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    try {
      final username = await GetIt.I<ProfileService>().getUsername();
      setState(() {
        _messages.add(
          ChatMessage(
            message: "Hello $username, How can I help you today?",
            isUser: false,
          ),
        );
      });
    } catch (e) {
      print('Error loading username: $e');
      _messages.add(
        const ChatMessage(
          message: "Hello there, How can I help you today?",
          isUser: false,
        ),
      );
    }
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    _messageController.clear();
    setState(() {
      _messages.add(ChatMessage(message: text, isUser: true));
    });

    try {
      // Show typing indicator
      setState(() {
        _messages.add(const ChatMessage(
          message: "Typing...",
          isUser: false,
        ));
      });

      // Get AI response
      final response = await _aiService.getAIResponse(text);

      // Remove typing indicator and add AI response
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
          message: response,
          isUser: false,
        ));
      });
    } catch (e) {
      print('Error handling message: $e');
      setState(() {
        _messages.removeLast();
        _messages.add(ChatMessage(
          message: "Sorry, I encountered an error: $e",
          isUser: false,
        ));
      });
    }

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004D40),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Fesho Chatbot',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _messages[index],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.quicksand(
                          color: Colors.grey[600],
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.teal[700]),
                  onPressed: () => _handleSubmitted(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                backgroundColor: Colors.teal[100],
                child: Icon(
                  Icons.face,
                  color: Colors.teal[700],
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFFE0F2F1) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message,
                style: GoogleFonts.quicksand(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AIChatService {
  String get apiKey => Config.togetherApiKey;
  
  Future<String> getAIResponse(String message) async {
    try {
      print('Using API Key: ${apiKey.substring(0, 5)}...'); 
      
      final response = await http.post(
        Uri.parse('https://api.together.xyz/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo-128K",
          'messages': [{'role': 'user', 'content': message}],
        }),
      );
      
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode != 200) {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
      
      final data = jsonDecode(response.body);
      if (data['choices'] == null || data['choices'].isEmpty) {
        throw Exception('Invalid API response format');
      }
      
      return data['choices'][0]['message']['content'];
    } catch (e) {
      print('Error in getAIResponse: $e');
      rethrow;
    }
  }
} 