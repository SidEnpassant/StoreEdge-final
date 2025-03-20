import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeedge/auth/login/login_screen.dart';
import 'package:storeedge/screens/notification_screen.dart';
import 'package:storeedge/screens/profile_screen.dart';

class NotiAndAccountIconHeader extends StatelessWidget {
  const NotiAndAccountIconHeader({Key? key}) : super(key: key);

  void _navigateToProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ProfileScreen()), // Assumes you have a ProfileScreen widget
    );
  }

  void _navigateToNoti(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              NotificationScreen()), // Assumes you have a ProfileScreen widget
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side - Profile Icon
        Container(
          width: 45,
          height: 45,
          child: IconButton(
            icon: Image.asset(
              'assets/icons/profile-icon.png',
              width: 31,
              height: 31,
            ),
            onPressed: () => _navigateToProfile(context),
          ),
        ),

        // Right side - Notification Icon
        Container(
          width: 45,
          height: 45,
          child: IconButton(
            onPressed: () => _navigateToNoti(context),
            icon: Image.asset(
              'assets/icons/notification-icon.png',
              width: 31,
              height: 31,
            ),
          ),
        ),
      ],
    );
  }
}
