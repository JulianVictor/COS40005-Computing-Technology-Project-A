import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final Color color;
  final VoidCallback? onMenuTap;
  final VoidCallback? onHomeTap;
  final VoidCallback? onProfileTap;

  const BottomNavBar({
    super.key,
    this.color = const Color(0xFF2D108E),
    this.onMenuTap,
    this.onHomeTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: onMenuTap,
          ),
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: onHomeTap,
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: onProfileTap,
          ),
        ],
      ),
    );
  }
}
