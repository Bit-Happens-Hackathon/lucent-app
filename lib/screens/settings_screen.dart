import 'package:flutter/material.dart';


class AppColors {
  static const Color background = Color(0xFF242325);
  static const Color white = Color(0xFFF0F4EF);
  static const Color primaryBlue = Color(0xFF9dd4f1);
  static const Color messageBlue = Color(0xFF9dcaf1);
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: AppColors.background,
      body: Column(
        children: [
        //box
        const SizedBox(height: 70),
      
        //image asset

          Center(
            child: ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: Image.asset(
                'assets/ceec.JPG',
                height: 100.0,
                width: 100.0,
               ),
            ),
          ),

        // text box
        Text('Settings', style: 
        TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30)),

         Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,//.horizontal
              child: Text(
                "Settings place Holder 1 \n" 
                "Settings place Holder 2 \n"  
                "Settings place Holder 3 \n",     
                style: TextStyle(
                  fontSize: 20.0, color: Colors.white,
                ),
              ),
            ),
         )
    ]
    )
  );
  }
}