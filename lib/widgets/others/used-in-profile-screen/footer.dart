import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Made with ❤ by team devolt',
        style: TextStyle(
          color: Color(0xFF000001),
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
