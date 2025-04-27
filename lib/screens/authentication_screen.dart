import 'package:flutter/material.dart';


class AppColors {
  static const Color background = Color(0xFF242325);
  static const Color white = Color(0xFFF0F4EF);
  static const Color primaryBlue = Color(0xFF9dd4f1);
  static const Color messageBlue = Color(0xFF9dcaf1);
}

class authenticationScreen extends StatelessWidget {
  const authenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          children: [
        const SizedBox(height: 40),
        
        const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('lucent', style: 
          TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 50,
          ),
                ),
        ),

        const Text('How do you feel?',
        style: TextStyle(
          fontSize: 24,
          color: Colors.white
        ),),

          Padding(
            padding: const EdgeInsets.all(45.0),
            child: ClipRRect(
             borderRadius: BorderRadius.circular(40.0),
              child: Image.asset(
              'assets/bansaiOffical.png',
              height: 200.0,
              width: 200.0,
             ),
            ),
          ),

        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/sign_in_screen'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 50),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(20),
              child: const Center(
                child: Text('Sign In',
                style: TextStyle(
                   color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
                ),
              ),
            ),
            ),
        ),

          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/sign_up_screen'),
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(20),
              child: const Center(
                child: Text('Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30
                ),
                ),
              ),
            ),
            ),
          ),
    ]


        )
      ),
    );
  }
}