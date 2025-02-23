import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final String assetPath;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final Color borderColor;
  final double borderWidth;

  const CustomFAB({
    Key? key,
    required this.onPressed,
    required this.assetPath, // Custom asset icon path
    this.backgroundColor = Colors.blue,
    this.size = 40.0, // Default FAB size
    this.iconSize = 30.0, // Default icon size
    this.borderColor =
        const Color.fromARGB(255, 0, 0, 0), // Default border color
    this.borderWidth = 2.0, // Default border width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor, // Custom background color
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Color(0xFF5044FC), // Primary background color
        elevation: 0,
        shape: const CircleBorder(), // Ensures full round shape
        child: ClipOval(
          child: Image.asset(
            assetPath,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
