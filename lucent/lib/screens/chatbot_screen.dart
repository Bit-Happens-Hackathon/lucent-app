import 'package:flutter/material.dart';
import '../themes.dart';
import '../widgets/top_navbar.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _messages = []; // simple text-based messages for now

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(text);
      _textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const TopNavBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Text('Menu', style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: Text('Profile'),
            ),
            ListTile(
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Add some top padding
          Center(
            child: Container(
              width: 150, // Increased size
              height: 150, // Increased size
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/ceec.JPG'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: AppColors.messagePurple,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      _messages[index],
                      style: const TextStyle(color: AppColors.background),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0,
          MediaQuery.of(context).size.height * 0.05), // 10% bottom padding
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type your message...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade900,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(color: AppColors.primaryGreen),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide: const BorderSide(color: AppColors.primaryGreen),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.0),
                  borderSide:
                      const BorderSide(color: AppColors.primaryGreen, width: 2),
                ),
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: AppColors.background),
              onPressed: () {
                // Add voice input handling later
              },
            ),
          ),
        ],
      ),
    );
  }
}
