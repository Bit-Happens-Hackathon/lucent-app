import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucent/widgets/bonsai.dart';
import '../themes.dart';
import '../widgets/top_navbar.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/wellness_card.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/visits_service.dart';
import '../services/wellness_service.dart'; // Import the wellness service
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  
  const ProfileScreen({super.key, this.userId = "vcordo11@msudenver.edu"}); // Default to our placeholder

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  final PageController _pageController = PageController();
  final VisitsService _visitsService = VisitsService();
  final WellnessService _wellnessService = WellnessService(); // Add wellness service
  final int currentYear = DateTime.now().year; // Current year (2025)
  
  // Map to store visits by month
  Map<int, List<DateTime>> _visitsByMonth = {};

  // Wellness data and loading state
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

  List<DateTime> _userVisits = [];

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

    // Initialize the map with empty lists for all months
    for (int i = 1; i <= 12; i++) {
      _visitsByMonth[i] = [];
    }

    _fetchUserVisits();
    _fetchWellnessData(); // Fetch wellness data
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
      if (kDebugMode) {
        print('Error fetching wellness data: $e');
      }
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

  Future<void> _fetchUserVisits() async {
    try {
      final visits = await _visitsService.getUserVisits("vcordo11@msudenver.edu");
      
      if (kDebugMode) {
        print('Raw fetched visits: $visits');
      }
      
      // Process visits and organize by month for the current year
      final Map<int, List<DateTime>> visitsByMonth = {};
      for (int i = 1; i <= 12; i++) {
        visitsByMonth[i] = [];
      }
      
      for (final visit in visits) {
        if (kDebugMode) {
          print('Processing visit: $visit (year: ${visit.year}, current year: $currentYear)');
        }
        
        // Only process visits from the current year
        if (visit.year == currentYear) {
          if (kDebugMode) {
            print('Adding visit to month ${visit.month}: $visit');
          }
          visitsByMonth[visit.month]?.add(visit);
        }
      }
      
      setState(() {
        _userVisits = visits;
        _visitsByMonth = visitsByMonth;
      });
      
      if (kDebugMode) {
        print('User visits by month: $_visitsByMonth');
        for (int i = 1; i <= 12; i++) {
          print('Month $i visits: ${_visitsByMonth[i]?.length ?? 0}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user visits: $e');
      }
    }
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
  
  // Generate JSON for a specific month
  String getMonthJson(int month) {
    final visits = _visitsByMonth[month] ?? [];
    if (kDebugMode) {
      print('Generating JSON for month $month with ${visits.length} visits');
    }
    return jsonEncode({"visits": visits.map((date) => date.toIso8601String()).toList()});
  }

  @override
  Widget build(BuildContext context) {
    final currentMonthJson = getMonthJson(DateTime.now().month);
    
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
                child: _isLoadingWellness
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryGreen,
                      ),
                    )
                  : ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: [
                      // Use the same keys as in _wellnessStats map for consistency
                      WellnessCard(category: 'Physical', percentage: _wellnessStats['Physical'] ?? 0),
                      WellnessCard(category: 'Emotional', percentage: _wellnessStats['Emotional'] ?? 0),
                      WellnessCard(category: 'Spiritual', percentage: _wellnessStats['Spiritual'] ?? 0),
                      WellnessCard(category: 'Financial', percentage: _wellnessStats['Financial'] ?? 0),
                      WellnessCard(category: 'Environmental', percentage: _wellnessStats['Environmental'] ?? 0),
                      WellnessCard(category: 'Social', percentage: _wellnessStats['Social'] ?? 0),
                      WellnessCard(category: 'Creative', percentage: _wellnessStats['Creative'] ?? 0),
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
                child: BonsaiTree.fromJson(currentMonthJson),
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
                            onTap: () => _showBonsaiModal(context, i, getMonthJson(i)),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width / 3,
                              child: BonsaiTree.fromJson(getMonthJson(i)),
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
