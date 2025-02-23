import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Expenses',
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width > 640 ? 32 : 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
