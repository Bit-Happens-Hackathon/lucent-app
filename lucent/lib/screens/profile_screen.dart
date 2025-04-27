import 'package:flutter/material.dart';
import 'package:lucent/widgets/bonsai.dart';
import '../themes.dart';
import '../widgets/top_navbar.dart';
import '../widgets/drawer_menu.dart';
import '../widgets/wellness_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

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
    super.dispose();
  }

  void _showBonsaiModal(BuildContext context, int monthIndex, String jsonData) {
    final monthName = getMonthName(monthIndex);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                Container(
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
    final months = [
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            const Center(
              child: Text(
                'Profile Screen',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/ceec.JPG'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10), 
            const Divider(
              color: AppColors.white,
              thickness: 1,
              indent: 32,
              endIndent: 32,
            ),
            const SizedBox(height: 10),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Wellness Stats',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
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
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 30,
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Your Bonsai',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Container(
              height: MediaQuery.of(context).size.width,
              child: BonsaiTree.fromJson(
                mockJson,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                DateTime.now().month == 1 ? 'January' : 
                DateTime.now().month == 2 ? 'February' : 
                DateTime.now().month == 3 ? 'March' : 
                DateTime.now().month == 4 ? 'April' : 
                DateTime.now().month == 5 ? 'May' : 
                DateTime.now().month == 6 ? 'June' : 
                DateTime.now().month == 7 ? 'July' : 
                DateTime.now().month == 8 ? 'August' : 
                DateTime.now().month == 9 ? 'September' : 
                DateTime.now().month == 10 ? 'October' : 
                DateTime.now().month == 11 ? 'November' : 'December',
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Your Bonsai is a reflection of your growth and progress. Keep nurturing it!',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Text(
              'Your Garden',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          child: Container(
                            height: MediaQuery.of(context).size.width / 3,
                            child: BonsaiTree.fromJson(mockJson),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          getMonthName(i),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
