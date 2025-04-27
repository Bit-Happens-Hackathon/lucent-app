import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../themes.dart';
import '../widgets/top_navbar.dart';
import '../widgets/drawer_menu.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/wellness_service.dart'; // Import the wellness service

class ChatbotScreen extends StatefulWidget {
  final String? userId; // Add userId parameter
  
  const ChatbotScreen({super.key, this.userId = "vcordo11@msudenver.edu"}); // Default to our placeholder

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = [];
  // Wellness service and data
  final WellnessService _wellnessService = WellnessService();
  bool _isLoadingWellness = true;
  Map<String, int> _wellnessStats = {
    'Financial': 0,
    'Creative': 0,
    'Social': 0,
    'Environmental': 0,
    'Spiritual': 0,
    'Physical': 0,
    'Emotional': 0,
  };
  int? _selectedMoodIndex;

  // New: Speech-to-Text
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _fetchWellnessData();
  }

  // Method to fetch wellness data from the API
  Future<void> _fetchWellnessData() async {
    if (widget.userId == null) {
      setState(() {
        _isLoadingWellness = false;
      });
      return;
    }

    setState(() {
      _isLoadingWellness = true;
    });

    try {
      // Get the most recent wellness record for the user
      final List<WellnessRecord> records = await _wellnessService.getUserWellnessRecords(
        userId: widget.userId!,
        limit: 1, // Just get the most recent record
      );

      if (records.isNotEmpty) {
        final latestRecord = records.first;
        setState(() {
          _wellnessStats = {
            'Financial': latestRecord.financial,
            'Creative': latestRecord.creative,
            'Social': latestRecord.social,
            'Environmental': latestRecord.environmental,
            'Spiritual': latestRecord.spiritual,
            'Physical': latestRecord.physical,
            'Emotional': latestRecord.emotional,
          };
          _isLoadingWellness = false;
        });
      } else {
        // If no records, use placeholder data for demonstration
        setState(() {
          _wellnessStats = {
            'Financial': 75,
            'Creative': 85,
            'Social': 65,
            'Environmental': 70,
            'Spiritual': 60,
            'Physical': 80, 
            'Emotional': 78,
          };
          _isLoadingWellness = false;
        });
      }
    } catch (e) {
      print('Error fetching wellness data: $e');
      // Fallback to placeholder data on error
      setState(() {
        _wellnessStats = {
          'Financial': 75,
          'Creative': 85,
          'Social': 65,
          'Environmental': 70,
          'Spiritual': 60,
          'Physical': 80,
          'Emotional': 78,
        };
        _isLoadingWellness = false;
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({"text": text, "sender": "user"});
      _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);

    // Simulate bot reply
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add({"text": _generateBotReply(text), "sender": "bot"});
      });
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
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

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _textController.text = val.recognizedWords;
          }),
        );
      } else {
        print('The user has denied speech recognition permissions.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enable microphone permissions in settings.'),
          ),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                    ..._messages.map(_buildMessageBubble).toList(),
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
        const SizedBox(height: 10),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(16),
            child: _isLoadingWellness 
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                : RadarChart(
                    RadarChartData(
                      radarShape: RadarShape.circle,
                      dataSets: [
                        RadarDataSet(
                          dataEntries: _wellnessStats.values
                              .map((value) => RadarEntry(value: value.toDouble()))
                              .toList(),
                          borderColor: AppColors.primaryGreen,
                          fillColor: AppColors.primaryGreen.withOpacity(0.4),
                          entryRadius: 3,
                          borderWidth: 2,
                        ),
                      ],
                      radarBackgroundColor: Colors.transparent,
                      radarBorderData: const BorderSide(color: AppColors.white),
                      titlePositionPercentageOffset: 0.28,
                      titleTextStyle: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      tickCount: 4,
                      ticksTextStyle: const TextStyle(
                        color: Colors.transparent,
                        fontSize: 0,
                      ),
                      tickBorderData: BorderSide(
                        color: AppColors.white.withOpacity(0.7),
                        width: 1,
                      ),
                      gridBorderData: BorderSide(
                        color: AppColors.white.withOpacity(0.8),
                        width: 1.5,
                      ),
                      getTitle: (index, angle) {
                        final categories = _wellnessStats.keys.toList();
                        return RadarChartTitle(text: categories[index]);
                      },
                    ),
                  ),
          ),
        ),
        const Divider(
            color: AppColors.white, thickness: 1, indent: 32, endIndent: 32),
        const SizedBox(height: 8),
        const Text(
          'Placeholder words because Kade told me so!!!',
          style: TextStyle(color: AppColors.white, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/resources'),
          child: const Text(
            'Resources',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(
            color: AppColors.white, thickness: 1, indent: 32, endIndent: 32),
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
          children: List.generate(
              5,
              (index) => _buildMoodButton(
                  index, ['😢', '🙁', '😐', '🙂', '😊'][index])),
        ),
        const SizedBox(height: 16),
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
          color: isUser ? AppColors.primaryBlue : AppColors.primaryYellow,
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
        isKeyboardVisible
            ? MediaQuery.of(context).size.height * 0.01
            : MediaQuery.of(context).size.height * 0.05,
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
                fillColor: AppColors.background,
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
            decoration: BoxDecoration(
              color: _isListening
                  ? AppColors.primaryGreen
                  : AppColors.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.mic, color: AppColors.background),
              onPressed: _listen,
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
