import 'package:flutter/material.dart';
import '../themes.dart';
import '../widgets/top_navbar.dart';
import '../widgets/drawer_menu.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  int? _selectedMoodIndex;

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        "text": text,
        "sender": "user",
      });
      _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });

    // Simulate bot reply
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({
          "text": _generateBotReply(text),
          "sender": "bot",
        });
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _generateBotReply(String userInput) {
    List<String> botReplies = [
      "I'm here for you!",
      "Tell me more about that.",
      "That's really interesting.",
      "How are you feeling right now?",
      "I'm listening!",
      "Thank you for sharing that.",
      "Let's work through this together.",
      "Remember to be kind to yourself."
    ];

    botReplies.shuffle();
    return botReplies.first;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();  // This gets rid of keyboard when tapping outside
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: const TopNavBar(),
        drawer: const DrawerMenu(),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeaderSection(),
                    const SizedBox(height: 16),
                    ..._messages.map((message) => _buildMessageBubble(message)).toList(),
                  ],
                ),
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeaderSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/ceec.JPG'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 32,
                endIndent: 32,
              ),
              const SizedBox(height: 8),
              const Text(
                'Placeholder words because Kade told me so!!!',
                style: TextStyle(color: AppColors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/resources');
                },
                child: const Text(
                  'Resources',
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 32,
                endIndent: 32,
              ),
              const SizedBox(height: 16),
              const Text(
                'How are you today?',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildMoodButton(0, '😢'),
                  _buildMoodButton(1, '🙁'),
                  _buildMoodButton(2, '😐'),
                  _buildMoodButton(3, '🙂'),
                  _buildMoodButton(4, '😊'),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final bool isUser = message['sender'] == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryBlue : AppColors.messageBlue,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message['text'],
          style: const TextStyle(color: AppColors.background),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    final bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Container(
      padding: EdgeInsets.fromLTRB(
        12.0,
        8.0,
        12.0,
        isKeyboardVisible ? MediaQuery.of(context).size.height * 0.01 : MediaQuery.of(context).size.height * 0.05,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: AppColors.white),
              cursorColor: AppColors.white,
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade900,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide:
                      const BorderSide(color: AppColors.primaryBlue, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide:
                      const BorderSide(color: AppColors.primaryBlue, width: 2),
                ),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: AppColors.background),
              onPressed: () {
                // Add voice input handling heree
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodButton(int index, String emoji) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedMoodIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _selectedMoodIndex == index 
                ? AppColors.primaryBlue.withOpacity(0.3)
                : Colors.transparent,
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
