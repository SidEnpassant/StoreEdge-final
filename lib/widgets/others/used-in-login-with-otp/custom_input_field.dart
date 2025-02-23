import 'package:flutter/material.dart';
import 'package:storeedge/utils/theme/app_colors.dart';

class CustomInputFieldLoginWithOtp extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool isCenter;
  final Widget? prefix;
  final TextInputType keyboardType;

  const CustomInputFieldLoginWithOtp({
    Key? key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.isCenter = false,
    this.prefix,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.w900,
            height: 1.5,
            letterSpacing: -0.176,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            textAlign: isCenter ? TextAlign.center : TextAlign.start,
            style: const TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              prefixIcon: prefix,
              hintText: placeholder,
              hintStyle: TextStyle(
                color: AppColors.black.withOpacity(0.5),
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
