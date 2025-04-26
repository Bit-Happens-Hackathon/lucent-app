import 'package:flutter/material.dart';
import '../themes.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  const TopNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Will link to a drawer later :v
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey.shade400,
            child: const Icon(Icons.person, color: Colors.white), // Placeholder for user profile icon
          ),
        ),
      ],
      centerTitle: true,
      title: const Text(
        '',
        style: TextStyle(color: Colors.black),
      ),
      elevation: 0,
    );
  }
}
