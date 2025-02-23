import 'package:flutter/material.dart';
import 'package:storeedge/utils/theme/app_theme.dart';

class CustomButtonLogin extends StatelessWidget {
  final String text;
  final Function()? onPressed; // Changed from VoidCallback to Function()?
  final bool outlined;

  const CustomButtonLogin({
    Key? key,
    required this.text,
    required this.onPressed,
    this.outlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width <= 640;

    return SizedBox(
      width: double.infinity,
      height:
          isSmallScreen ? AppTheme.mobileButtonHeight : AppTheme.buttonHeight,
      child: outlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
              child: Text(
                text,
                style: AppTheme.buttonStyle.copyWith(color: Colors.black),
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                ),
              ),
              child: Text(text, style: AppTheme.buttonStyle),
            ),
    );
  }
}
