import 'package:flutter/material.dart';
import 'package:lucent/themes.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryBlue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/bansaiOffical.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Lucent',
                  style: TextStyle(
                      color: AppColors.background,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            title: const Text(
              'Chatbot',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            leading: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/chatbot') {
                Navigator.pushNamed(context, '/chatbot');
              }
            },
          ),
          const Divider(color: AppColors.white, height: 1),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            leading: const Icon(Icons.person_outline, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/profile') {
                Navigator.pushNamed(context, '/profile');
              }
            },
          ),
          const Divider(color: AppColors.white, height: 1),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            title: const Text(
              'Resources',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            leading:
                const Icon(Icons.library_books_outlined, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
              if (ModalRoute.of(context)?.settings.name != '/resources') {
                Navigator.pushNamed(context, '/resources');
              }
            },
          ),
          const Divider(color: AppColors.white, height: 1),
          ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            leading: const Icon(Icons.settings_outlined, color: Colors.white),
            onTap: () {
              Navigator.pop(context);
              // Later navigate to settings screen (not priority)
            },
          ),
          const Divider(color: AppColors.white, height: 1),
        ],
      ),
    );
  }
}
