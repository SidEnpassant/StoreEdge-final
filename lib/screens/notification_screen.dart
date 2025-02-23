import 'package:flutter/material.dart';
import 'package:storeedge/utils/theme/app_colors.dart';
import 'package:storeedge/widgets/others/used-in-notification-screen/notification_item.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            screenWidth > 991 ? 28 : (screenWidth > 640 ? 24 : 20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 27,
                  height: 28,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.black,
                    size: 24,
                  ),
                ),
              ),
              SizedBox(height: 27),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification',
                    style: TextStyle(
                      color: Color(0xFF5044FC),
                      fontSize: screenWidth > 991
                          ? 32
                          : (screenWidth > 640 ? 28 : 24),
                      fontWeight: FontWeight.w900,
                      height: 24 / 32,
                    ),
                  ),
                  SizedBox(height: 13),
                  Text(
                    "All the notification's are shown here",
                    style: TextStyle(
                      color: Color(0xFFC8C8C8),
                      fontSize: screenWidth > 640 ? 14 : 13,
                      fontWeight: FontWeight.w900,
                      height: 24 / 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 27),
              Expanded(
                child: ListView(
                  children: [
                    NotificationItem(message: 'New product is added'),
                    SizedBox(height: 21),
                    NotificationItem(message: 'product is added'),
                    SizedBox(height: 21),
                    NotificationItem(message: 'New product is deleted'),
                    SizedBox(height: 21),
                    NotificationItem(message: 'Profile updated'),
                    SizedBox(height: 21),
                    NotificationItem(message: 'New things got added'),
                    SizedBox(height: 21),
                    NotificationItem(message: 'App got a new update'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
