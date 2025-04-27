import 'package:flutter/material.dart';
import '../themes.dart';

class WellnessReflectionScreen extends StatefulWidget {
  const WellnessReflectionScreen({super.key});

  @override
  State<WellnessReflectionScreen> createState() =>
      _WellnessReflectionScreenState();
}

class _WellnessReflectionScreenState extends State<WellnessReflectionScreen> {
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Financial Wellness',
      'questions': [
        {'text': 'How confident do you feel about managing your finances?', 'type': 'scale'},
        {'text': 'Are you able to comfortably cover your essential expenses?', 'type': 'scale'},
        {'text': 'Do you feel financially prepared for unexpected events?', 'type': 'yesno'},
      ]
    },
    {
      'title': 'Creative Wellness',
      'questions': [
        {'text': 'How often do you engage in creative activities?', 'type': 'scale'},
        {'text': 'Do you feel free to express your creativity?', 'type': 'scale'},
        {'text': 'Is creativity important in your daily life?', 'type': 'yesno'},
      ]
    },
    {
      'title': 'Social Wellness',
      'questions': [
        {'text': 'Do you feel supported by those around you?', 'type': 'scale'},
        {'text': 'How connected do you feel to your community?', 'type': 'scale'},
        {'text': 'Are you satisfied with your current social life?', 'type': 'yesno'},
      ]
    },
    {
      'title': 'Environmental Wellness',
      'questions': [
        {'text': 'Do your surroundings make you feel safe and comfortable?', 'type': 'scale'},
        {'text': 'How connected do you feel to nature?', 'type': 'scale'},
        {'text': 'Does your environment support your wellbeing?', 'type': 'yesno'},
      ]
    },
    {
      'title': 'Spiritual Wellness',
      'questions': [
        {'text': 'Do you feel a sense of purpose in your life?', 'type': 'scale'},
        {'text': 'How often do you reflect on your personal values?', 'type': 'scale'},
        {'text': 'Do you feel connected to something bigger than yourself?', 'type': 'yesno'},
      ]
    },
    {
      'title': 'Physical Wellness',
      'questions': [
        {'text': 'Do you feel physically healthy and energized?', 'type': 'scale'},
        {'text': 'How often do you engage in physical activity?', 'type': 'scale'},
        {'text': 'Are you satisfied with your current physical health?', 'type': 'yesno'},
      ]
    },
    {
      'title': 'Emotional Wellness',
      'questions': [
        {'text': 'Are you able to manage your emotions effectively?', 'type': 'scale'},
        {'text': 'Do you feel in tune with your feelings?', 'type': 'scale'},
        {'text': 'Are you emotionally resilient when challenges arise?', 'type': 'yesno'},
      ]
    },
  ];

  int _currentCategoryIndex = 0;
  final Map<String, dynamic> _answers = {};
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextCategory() {
    if (_currentCategoryIndex < _categories.length - 1) {
      setState(() {
        _currentCategoryIndex++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/chatbot');
    }
  }

  void _updateAnswer(String question, dynamic answer) {
    _answers[question] = answer;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final currentCategory = _categories[index];
            return _buildCategoryPage(currentCategory, context);
          },
        ),
      ),
    );
  }

  Widget _buildCategoryPage(
      Map<String, dynamic> currentCategory, BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.05),
            const Center(

              child: Text(
                'Wellness Reflection',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            const Text(
              "This quick reflection helps us understand your wellness today! "
              "You will get a personalized wellness chart to see your progress and celebrate your growth.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _categories.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index <= _currentCategoryIndex
                          ? AppColors.primaryYellow
                          : Colors.white24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            Text(
              currentCategory['title'],
              style: const TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(3, (index) {
              final question = currentCategory['questions'][index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${index + 1}. ${question['text']}',
                      style:
                          const TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    if (question['type'] == 'scale')
                      _buildScaleSelector(question['text'])
                    else if (question['type'] == 'yesno')
                      _buildYesNoSelector(question['text']),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: _goToNextCategory,
                icon: const Icon(Icons.arrow_forward,
                    color: AppColors.background),
                label: const Text(
                  'Next',
                  style: TextStyle(color: AppColors.background),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleSelector(String question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
          5,
          (index) => GestureDetector(
                onTap: () => setState(() {
                  _updateAnswer(question, index + 1);
                }),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _answers[question] == index + 1
                        ? AppColors.primaryBlue
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryBlue),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: _answers[question] == index + 1
                            ? Colors.black
                            : AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )),
    );
  }

  Widget _buildYesNoSelector(String question) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              _updateAnswer(question, 'Yes');
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _answers[question] == 'Yes'
                    ? AppColors.primaryBlue
                    : Colors.transparent,
                border: Border.all(color: AppColors.primaryBlue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: _answers[question] == 'Yes' ? Colors.black : AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              _updateAnswer(question, 'No');
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _answers[question] == 'No'
                    ? AppColors.primaryBlue
                    : Colors.transparent,
                border: Border.all(color: AppColors.primaryBlue),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'No',
                  style: TextStyle(
                    color: _answers[question] == 'No' ? Colors.black : AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
