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
class sign_up_screen extends StatelessWidget {
  const sign_up_screen({super.key});



  @override
  Widget build(BuildContext context) {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  TextEditingController _schoolController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
    const Text('Create Account',
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
      hintText: 'Enter your full name',
      hintStyle: TextStyle(color: Colors.white)
      ),
      controller: _nameController,
      style: const TextStyle(color: Colors.white)
      ),
    ),
),
          //email
    Center(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: TextField(
      decoration: const InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      border: OutlineInputBorder(),
      hintText: 'Enter your email',
      hintStyle: TextStyle(color: Colors.white)
      ),
      controller: _emailController,
      style: const TextStyle(color: Colors.white)
      ),
        
    ),
),
          //birthdate
    Center(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: TextField(
      decoration: const InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      border: OutlineInputBorder(),
      hintText: 'Enter your birthday',
      hintStyle: TextStyle(color: Colors.white)
      ),
      controller: _birthDateController,
      style: const TextStyle(color: Colors.white)
        ),
    ),
),
          //school
    Center(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: TextField(
      decoration: const InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      border: OutlineInputBorder(),
      hintText: 'Enter the school you go to',
      hintStyle: TextStyle(color: Colors.white)
      ),
      controller: _schoolController,
      style: const TextStyle(color: Colors.white)
        ),
    ),
),
          //password
    Center(
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: TextField(
      decoration: const InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      border: OutlineInputBorder(),
      hintText: 'Enter your password',
      hintStyle: TextStyle(color: Colors.white)
      ),
      controller: _passwordController,
      style: const TextStyle(color: Colors.white)
        ),
    ),
),
          //password confirm
              const Center(
      child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
      child: TextField(
      decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      border: OutlineInputBorder(),
      hintText: 'Verify your password',
      hintStyle: TextStyle(color: Colors.white)
      ),
      style: TextStyle(color: Colors.white)
        ),
    ),
),

GestureDetector(
          onTap: () {
            print(_nameController);
            print(_passwordController);
            print(_schoolController);
            print(_birthDateController);
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
        ],)
        
    );
  }
}