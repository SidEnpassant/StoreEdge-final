import 'package:flutter/material.dart';

class CustomButtonAddProductScreen extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final double fontSize;
  final bool isPrimary;

  const CustomButtonAddProductScreen({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height = 52,
    this.fontSize = 16,
    this.isPrimary = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5044FC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          // padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
