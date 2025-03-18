import 'package:flutter/material.dart';

class ThemeConstants {
  static const Color primaryColor = Color(0xFF5044FC);
  static const Color backgroundColor = Color.fromARGB(255, 255, 255, 255);
  static const Color textColor = Color(0xFF000001);
  static const Color iconColor = Color(0xFF5044FC);

  static const TextStyle titleStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: Color(0xFF5044FC),
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static const TextStyle labelStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: textColor,
  );

  static const TextStyle inputStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static const TextStyle buttonStyle = TextStyle(
    fontFamily: 'ravenna-serial-extrabold-regular',
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );

  static const double borderRadius = 16.0;
  static const double inputPadding = 16.0;
  static const double spacing = 28.0;
}
