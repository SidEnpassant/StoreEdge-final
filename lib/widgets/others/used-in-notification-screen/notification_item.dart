import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String message;

  const NotificationItem({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width > 640 ? 20 : 14,
        vertical: MediaQuery.of(context).size.width > 640 ? 26 : 20,
      ),
      decoration: BoxDecoration(
        color: Color(0xFF5044FC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width > 640 ? 20 : 18,
          fontWeight: FontWeight.w900,
          height: 29 / 20,
        ),
      ),
    );
  }
}
