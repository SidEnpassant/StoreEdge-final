// welcome_header.dart
import 'package:flutter/material.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        'Welcome',
        style: TextStyle(
          color: Color(0xFF5044FC),
          fontSize: 40,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    // Row(

    //   // children: [
    //   //   // Middle - Welcome Text

    //   // ],
    // );
  }
}
