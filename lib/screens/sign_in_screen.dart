import 'package:flutter/material.dart';
import '../themes.dart';
import '../widgets/top_navbar.dart';
import '../widgets/drawer_menu.dart';

class AppColors {
  static const Color background = Color(0xFF242325);
  static const Color white = Color(0xFFF0F4EF);
  static const Color primaryBlue = Color(0xFF9dd4f1);
  static const Color messageBlue = Color(0xFF9dcaf1);
}

// ignore: camel_case_types
class sign_in_screen extends StatelessWidget {
  const sign_in_screen({super.key});


  @override
  Widget build(BuildContext context) {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          //name
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: SizedBox(height: 40),
            ),
          ),
    const Text('Sign In To Account',
    style: TextStyle(fontWeight: FontWeight.bold,
    fontSize: 40,
    color: Colors.white
    )
    ),

    Center(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: TextField(
      decoration: const InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      border: OutlineInputBorder(),
      hintText: 'Enter your Password',
      hintStyle: TextStyle(color: Colors.white)
      ),
      controller: _nameController,
      style: const TextStyle(color: Colors.white)
      ),
    ),
),

    Center(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: TextField(
      decoration: const InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      border: OutlineInputBorder(),
      hintText: 'Enter your Email',
      hintStyle: TextStyle(color: Colors.white)
      ),
      controller: _emailController,
      style: const TextStyle(color: Colors.white)
      ),

    ),
),

GestureDetector(
          onTap: () {
          Navigator.pushReplacementNamed(context, '/wellness_reflection_screen');
          print(_nameController);
          print(_emailController);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
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
        ]
      )
    );
  }
}