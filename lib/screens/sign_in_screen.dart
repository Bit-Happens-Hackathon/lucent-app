import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../themes.dart';

class sign_in_screen extends StatefulWidget {
  const sign_in_screen({super.key});

  @override
  State<sign_in_screen> createState() => _sign_in_screenState();
}

class _sign_in_screenState extends State<sign_in_screen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String baseUrl = 'http://10.6.131.67:8000';

  Future<void> _signIn() async {
    final url = Uri.parse('$baseUrl/users/signin');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      print('Server response (${response.statusCode}): ${response.body}');

      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/wellness_reflection_screen');
      } else {
        _showErrorDialog('Sign in failed. Check your email and password.');
      }
    } catch (e) {
      _showErrorDialog('Error: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Error', style: TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppColors.primaryBlue)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        cursorColor: AppColors.primaryBlue,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
          ),
          border: const OutlineInputBorder(),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              'Sign In \nTo Account',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(_emailController, 'Enter your email'),
            _buildTextField(_passwordController, 'Enter your password', obscureText: true),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _signIn,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 250,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                child: const Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: AppColors.background,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
