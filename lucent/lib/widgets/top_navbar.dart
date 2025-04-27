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
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            FocusScope.of(context).unfocus(); // dismiss keyboard
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 1.5,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                if (ModalRoute.of(context)?.settings.name != '/profile') {
                  Navigator.pushNamed(context, '/profile');
                }
              },
              child: const CircleAvatar(
                backgroundColor: AppColors.primaryBlue,
                child: Icon(Icons.person, color: Colors.black),
              ),
            ),
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
