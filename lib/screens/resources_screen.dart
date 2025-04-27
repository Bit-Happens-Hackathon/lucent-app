import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class AppColors {
  static const Color background = Color(0xFF242325);
  static const Color white = Color(0xFFF0F4EF);
  static const Color primaryBlue = Color(0xFF9dd4f1);  
  static const Color messageBlue = Color(0xFF9dcaf1);
}

void main() {  runApp(const ResourcesScreen());
}


class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryBlue,
      ),
      home: const ResourcesPage(),
    );
  }
}

class ResourcesPage extends StatelessWidget {
  const ResourcesPage({super.key});


Widget counselorCard(BuildContext context, String name, String bio, String imagePath, String email) {
  return GestureDetector(
    onTap: () {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(name),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bio),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text:email)
                  );
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.email, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          email,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    },
    child: Container(
      width: 140,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath), 
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Icon(Icons.email, size: 16, color: Colors.black54),
        ],
      ),
    ), 
  );
}

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> realms = [
      {
        'title': 'Environmental',
        'icon': Icons.landscape,
        'color': Colors.brown,
        'links': [
          {'title': 'MSU Denver - One World One Water', 'url': 'https://www.msudenver.edu/one-world-one-water/'},
          {'title': 'MSU Denver - Campus Sustainability Trail', 'url': 'https://www.msudenver.edu/one-world-one-water/action/campus-sustainability-trail/'},
          {'title': 'DU Sustainability About', 'url': 'https://www.du.edu/sustainability/about'},
          {'title': 'DU Living and Learning Communities', 'url': 'https://academicaffairs.du.edu/livinglearning/sustainability'},
          {'title': 'CU Denver Emergency Management & Campus Safety', 'url':'https://www.ucdenver.edu/emergencymanagement/campus-safety'},
          {'title': 'CU Denver Climate Change Studies', 'url': 'https://clas.ucdenver.edu/academic-programs/climate-change-studies'},
        ],
      },
      {
        'title': 'Emotional',
        'icon': Icons.sentiment_satisfied,
        'color': Colors.orange,
        'links': [
          {'title': 'MSU Denver Counseling Center', 'url': 'https://www.msudenver.edu/counseling-center/'},
          {'title': 'MSU Denver Online Mental Health Resources', 'url': 'https://www.msudenver.edu/counseling-center/resources/online-mental-health-resources/'},
          {'title': 'CU Denver Counseling Center', 'url': 'https://www.ucdenver.edu/counseling-center'},
          {'title': 'CU Denver Health & Wellness Resources', 'url': 'https://www.ucdenver.edu/life/living-on-around-campus/health-well-being'},
          {'title': 'DU Mental Health Resources', 'url': 'https://studentaffairs.du.edu/health-counseling-center/promoting-health-wellbeing/mental-health-resources'},
          {'title': 'DU Mental Health & Mindfulness', 'url': 'https://www.du.edu/community-values/content/mental-health-community-approach'},
        ],
      },
      {                                         
        'title': 'Spiritual',
        'icon': Icons.self_improvement,
        'color': Colors.purple,
        'links': [
          {'title': 'MSU Denver Gathering Spaces', 'url': 'https://www.msudenver.edu/multicultural-center/student-gathering-spaces-and-resource-room/'},
          {'title': 'MSU Denver Career & Personal Development', 'url': 'https://www.msudenver.edu/gender-institute-teaching-advocacy/gender-women-and-sexualities-studies-majors-and-minors/career-personal-development-cpd-courses/'},
          {'title': 'CU Denver Health & Well-Being', 'url': 'https://www.ucdenver.edu/life/living-on-around-campus/health-well-being'},
          {'title': 'CU Denver Student Services Resources', 'url': 'https://catalog.ucdenver.edu/cu-denver/about-cu-denver/student-services-student-resources/'},
          {'title': 'DU Spiritual Life', 'url': 'https://studentaffairs.du.edu/spiritual-life'},
          {'title': 'DU Hope Board', 'url': 'https://studentaffairs.du.edu/spiritual-life/hope-board'},
        ],
      },
      {
        'title': 'Social',
        'icon': Icons.people,
        'color': Colors.blue,
        'links': [
          {'title': 'MSU Denver Student Engagement', 'url': 'https://www.msudenver.edu/student-engagement-and-well-being/'},
          {'title': 'MSU Denver Well-Being Resources', 'url': 'https://www.msudenver.edu/student-engagement-and-well-being/student-well-being-resources/'},
          {'title': 'CU Denver Student Life', 'url': 'https://www.ucdenver.edu/student-life'},
          {'title': 'CU Denver Health & Well-Being', 'url': 'https://www.ucdenver.edu/life/living-on-around-campus/health-well-being'},
          {'title': 'DU Student Well-Being', 'url': 'https://studentaffairs.du.edu/du-help/well-being'},
          {'title': 'DUhelp Student Affairs', 'url': 'https://studentaffairs.du.edu/du-help'},
        ],
      },
      {
        'title': 'Physical',
        'icon': Icons.fitness_center,
        'color': Colors.red,
        'links': [
          {'title': 'MSU Denver Campus Recreation', 'url': 'https://www.msudenver.edu/recreation/fitness/'},
          {'title': 'MSU Denver Exercise & Sport Sciences', 'url': 'https://www.msudenver.edu/exercise-sport-sciences/'},
          {'title': 'CU Denver Wellness & Recreation Services', 'url': 'https://www.ucdenver.edu/wellness'},
          {'title': 'CU Denver Fitness Programs', 'url': 'https://www.ucdenver.edu/wellness/programs/fitness'},
          {'title': 'DU Health & Counseling Center', 'url': 'https://studentaffairs.du.edu/health-counseling-center'},
          {'title': 'DU Coors Fitness Center', 'url': 'https://ritchiecenter.du.edu/sports/coors-fitness-center'},
        ],
      },
      {
        'title': 'Creative',
        'icon': Icons.palette,
        'color': Colors.amber,
        'links': [
          {'title': 'MSU Denver Career & Personal Development', 'url': 'https://www.msudenver.edu/gender-institute-teaching-advocacy/gender-women-and-sexualities-studies-majors-and-minors/career-personal-development-cpd-courses/'},
          {'title': 'MSU Denver Student Engagement', 'url': 'https://www.msudenver.edu/student-engagement-and-well-being/'},
          {'title': 'CU Denver Undergraduate Research', 'url': 'https://www.ucdenver.edu/lynxconnect/undergraduate-research'},
          {'title': 'CU Denver Health & Well-Being', 'url': 'https://www.ucdenver.edu/life/living-on-around-campus/health-well-being'},
          {'title': 'DU Wellness Courses', 'url': 'https://bulletin.du.edu/undergraduate/coursedescriptions/well/'},
          {'title': 'DU Health Promotion', 'url': 'https://studentaffairs.du.edu/du-help/well-being/health-promotion'},
        ],
      },
      {
        'title': 'Financial',
        'icon': Icons.attach_money,
        'color': Colors.green,
        'links': [
          {'title': 'MSU Denver Financial Wellness Survey', 'url': 'https://www.msudenver.edu/student-affairs/student-financial-wellness-survey/'},
          {'title': 'MSU Denver Financial Aid', 'url': 'https://www.msudenver.edu/financial-aid/'},
          {'title': 'CU Denver Financial Wellness', 'url': 'https://www.ucdenver.edu/wellness/services/basic-needs/financial-wellness'},
          {'title': 'CU Denver Student Finances', 'url': 'https://www.ucdenver.edu/student-finances'},
          {'title': 'DU Health Promotion', 'url': 'https://studentaffairs.du.edu/du-help/well-being/health-promotion'},
          {'title': 'DU Financial Wellness', 'url': 'https://www.du.edu/admission-aid/financial-aid-scholarships/financial-wellness'},
        ],
      },
      {
        'title': 'Counselors',
        'icon': Icons.person,
        'color': Colors.grey,
        'links': [], 
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView.builder(
        itemCount: realms.length,
        itemBuilder: (context, index) {
          final realm = realms[index];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Row
                Row(
                  children: [
                    Text(
                      realm['title'],
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      backgroundColor: realm['color'],
                      radius: 18,
                      child: Icon(
                        realm['icon'],
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 3,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Section Content
                if (realm['title'] == 'Counselors') ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        counselorCard(context, 'MSU \n Dr. Boldt', 'Dr. Randal Boldt is the Director and a Licensed Psychologist in the state of Colorado with 30 years of experience in both community mental health and college counseling. He has also taught for 10 years as an adjunct professor of a psychology doctoral program.' , 'assets/MSU.JPG' , "raboldt@msudenver.edu"),
                        counselorCard(context, 'CU \n Dr. Heermann', 'Dr. Heermann is a licensed Clinical Psychologist and has nearly 1.5 decades of experience at two University counseling centers. He recently comes from a leadership role at the University of Colorado (CU), Boulder, Counseling and Psychiatric Services (CAPS).' , 'assets/cu.JPG', "Matthew.Heermann@ucdenver.edu"),
                        counselorCard(context, 'DU \n Dr. LaFarr', 'Dr. Michael LaFarr is an expert in health care disparity & access, health and wellness, college mental health, differences in learning, grief counseling, giftedness, psychodynamic treatment, sexual therapy, non-majority sexual orientation & transgender mental health.' , 'assets/du.JPG', "Michael.LaFarr@du.edu"),
                      ],
                    ),
                  ),
                ] else ...[
                  for (var link in realm['links'])
                    InkWell(
                      onTap: () async {
                         FlutterWebBrowser.openWebPage(
          url: link['url'],
          customTabsOptions: CustomTabsOptions(
            toolbarColor: Colors.blue,
            showTitle: true,
          ),
                         );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        padding: const EdgeInsets.all(12.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.messageBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          link['title'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
  }