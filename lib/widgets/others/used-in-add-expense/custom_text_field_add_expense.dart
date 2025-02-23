import 'package:flutter/material.dart';
import 'package:storeedge/utils/theme/app_colors.dart';
import 'package:storeedge/utils/theme/app_theme.dart';

class CustomTextFieldAddExpense extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextFieldAddExpense({
    Key? key,
    required this.label,
    required this.hint,
    this.controller,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: AppTheme.inputHeight,
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            decoration: AppTheme.inputDecoration(
              hintText: hint,
              prefixIcon: prefix,
              suffixIcon: suffix,
            ),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
