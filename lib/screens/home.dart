import 'package:flutter/material.dart';
import 'package:storeedge/widgets/others/used-in-home/action_grid.dart';
import 'package:storeedge/widgets/global/floating_action_button.dart';
import 'package:storeedge/widgets/others/used-in-home/footer.dart';
import 'package:storeedge/widgets/global/noti_and_account_icon.dart';
import 'package:storeedge/widgets/others/used-in-home/revenue_card.dart';
import 'package:storeedge/widgets/others/used-in-home/welcome_header.dart';
import 'package:storeedge/utils/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: const Color(0xFFEEEEEE),
        body: Container(
      decoration: BoxDecoration(
        gradient: ThemeConstants.backgroundGradient,
      ),

      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                NotiAndAccountIconHeader(),
                const SizedBox(height: 10),
                WelcomeHeader(),
                const SizedBox(height: 20),
                RevenueCard(),
                const SizedBox(height: 20),
                ActionGrid(),
                const SizedBox(height: 16),
                Footer(),
              ],
            ),
          ),
        ),
      ),

      // Add Floating Action Button
      // floatingActionButton: CustomFAB(
      //   onPressed: () {},
      //   assetPath:
      //       "assets/icons/message-notif.png", // Ensure this matches your asset
      //   backgroundColor: Color(0xFF5044FC), // Customize FAB color
      //   size: 56, // Adjust size if needed
      //   iconSize: 30, // Adjust icon size if needed
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ));
  }
}
