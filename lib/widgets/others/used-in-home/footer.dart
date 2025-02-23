import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Made with ❤ by team devolt',
          style: TextStyle(
            fontSize: 12,
            color: Color.fromARGB(255, 181, 176, 249),
          ),
        ),
      ],
    );
  }
}
