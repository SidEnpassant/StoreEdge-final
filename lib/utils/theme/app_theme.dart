import 'package:flutter/material.dart';
import 'package:storeedge/utils/theme/app_colors.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF5044FC);
  static const Color backgroundColor = Color(0xFFEEEEEE);
  static const Color textColor = Colors.black;
  static const Color hintColor = Color(0xFF666666);
  static const double borderRadius = 8.0;
  static const double inputHeight = 50.0;

  static ThemeData get theme {
    return ThemeData(
      primaryColor: Color(0xFF5044FC),
      scaffoldBackgroundColor: Color(0xFFEEEEEE),
      fontFamily: 'ravenna-serial-extrabold-regular',
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: Color(0xFF5044FC),
          fontSize: 32,
          fontWeight: FontWeight.w900,
          height: 24 / 32,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w900,
          height: 29 / 20,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFFC8C8C8),
          fontSize: 14,
          fontWeight: FontWeight.w900,
          height: 24 / 14,
        ),
      ),
    );
  }

  static InputDecoration inputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: AppColors.inputText,
        fontSize: 16,
        fontFamily: 'ravenna-serial-extrabold-regular',
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 16,
    color: textColor,
    height: 1.4,
  );
  static const TextStyle subtitleStyleRegister = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 16,
    color: Color(0xFF5044FC),
    height: 1.4,
  );

  static const TextStyle labelStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textColor,
  );

  static const TextStyle inputStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 16,
    color: hintColor,
  );

  static const TextStyle buttonStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const double borderRadius2 = 16.0;
  static const double inputHeight2 = 56.0;
  static const double buttonHeight = 56.0;
  static const double mobileInputHeight = 48.0;
  static const double mobileButtonHeight = 48.0;
}
