import 'package:flutter/material.dart';
import 'package:lucent/widgets/bonsai.dart';
import '../themes.dart';
import '../widgets/top_navbar.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/wellness_card.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final PageController _pageController = PageController();

  final Map<String, int> _wellnessStats = {
    'Financial': 75,
    'Creative': 85,
    'Social': 65,
    'Environmental': 70,
    'Spiritual': 60,
    'Physical': 80,
    'Emotional': 78,
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.2),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _showBonsaiModal(BuildContext context, int monthIndex, String jsonData) {
    final monthName = getMonthName(monthIndex);
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  monthName,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.7,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: BonsaiTree.fromJson(jsonData),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.background,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String getMonthName(int monthIndex) {
    const months = [
      'January', 'February', 'March', 'April', 
      'May', 'June', 'July', 'August', 
      'September', 'October', 'November', 'December'
    ];
    return months[monthIndex - 1];
  }

  @override
  Widget build(BuildContext context) {
      const mockJson = '{"visits": ['
      '"2025-05-01T10:00:00Z",'
      '"2025-05-02T12:00:00Z",'
      '"2025-05-03T12:00:00Z",'
      '"2025-05-04T12:00:00Z",'
      '"2025-05-05T09:00:00Z",'
      '"2025-05-06T09:00:00Z",'
      '"2025-05-07T09:00:00Z",'
      '"2025-05-08T09:00:00Z",'
      '"2025-05-09T09:00:00Z",'
      '"2025-05-10T14:00:00Z",'
      '"2025-05-11T14:00:00Z",'
      '"2025-05-12T14:00:00Z",'
      '"2025-05-13T14:00:00Z",'
      '"2025-05-14T14:00:00Z",'
      '"2025-05-15T14:00:00Z",'
      '"2025-05-16T14:00:00Z",'
      '"2025-05-17T14:00:00Z",'
      '"2025-05-18T14:00:00Z",'
      '"2025-05-19T14:00:00Z",'
      '"2025-05-20T14:00:00Z",'
      '"2025-05-21T16:00:00Z",'
      '"2025-05-22T08:00:00Z",'
      '"2025-05-23T08:00:00Z",'
      '"2025-05-24T08:00:00Z",'
      '"2025-05-25T08:00:00Z",'
      '"2025-05-26T08:00:00Z",'
      '"2025-05-27T20:00:00Z",'
      '"2025-05-28T20:00:00Z",'
      '"2025-05-29T20:00:00Z",'
      '"2025-05-30T20:00:00Z",'
      '"2025-05-31T20:00:00Z"'
    ']}';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const TopNavBar(),
      drawer: const DrawerMenu(),
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), 
        children: [
          // Page 1: Wellness Stats
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const Text(
                'Profile Screen',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.all(16),
                child: RadarChart(
                  RadarChartData(
                    radarShape: RadarShape.circle,
                    dataSets: [
                      RadarDataSet(
                        dataEntries: _wellnessStats.values.map((value) => RadarEntry(value: value.toDouble())).toList(),
                        borderColor: AppColors.primaryGreen,
                        fillColor: AppColors.primaryGreen.withOpacity(0.4),
                        entryRadius: 3,
                        borderWidth: 2,
                      ),
                    ],
                    radarBackgroundColor: Colors.transparent,
                    radarBorderData: const BorderSide(color: AppColors.white),
                    titlePositionPercentageOffset: 0.28,
                    titleTextStyle: const TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w500),
                    tickCount: 4,
                    ticksTextStyle: const TextStyle(color: Colors.transparent),
                    tickBorderData: BorderSide(color: AppColors.white.withOpacity(0.7), width: 1),
                    gridBorderData: BorderSide(color: AppColors.white.withOpacity(0.8), width: 1.5),
                    getTitle: (index, angle) {
                      final categories = _wellnessStats.keys.toList();
                      return RadarChartTitle(text: categories[index]);
                    },
                  ),
                ),
              ),
              const Divider(color: AppColors.white, thickness: 1, indent: 32, endIndent: 32),
              const SizedBox(height: 10),
              const Text('Wellness Stats', style: TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  children: const [
                    WellnessCard(category: 'Physical', percentage: 75),
                    WellnessCard(category: 'Emotional', percentage: 82),
                    WellnessCard(category: 'Spiritual', percentage: 64),
                    WellnessCard(category: 'Financial', percentage: 88),
                    WellnessCard(category: 'Environmental', percentage: 70),
                    WellnessCard(category: 'Social', percentage: 90),
                    WellnessCard(category: 'Creative', percentage: 80),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _animation,
                child: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                  onPressed: () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ],
          ),
          // Page 2: Bonsai Section
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Your Bonsai', style: TextStyle(color: AppColors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.8,
                child: BonsaiTree.fromJson(mockJson),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  getMonthName(DateTime.now().month),
                  style: const TextStyle(color: AppColors.white, fontSize: 48, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Your Bonsai is a reflection of your growth and progress. Keep nurturing it!',
                  style: TextStyle(color: AppColors.white, fontSize: 16, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              SlideTransition(
                position: _animation,
                child: IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 30),
                  onPressed: () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ],
          ),
          // Page 3: Garden Section
            Column(
            children: [
              const SizedBox(height: 16),
              const Text('Your Garden', style: TextStyle(color: AppColors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  children: [
                    for (int i = 1; i <= 12; i++)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => _showBonsaiModal(context, i, mockJson),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width / 3,
                              child: BonsaiTree.fromJson(mockJson),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            getMonthName(i),
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
