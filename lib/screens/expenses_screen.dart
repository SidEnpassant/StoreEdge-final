import 'package:flutter/material.dart';
import 'package:storeedge/screens/add_expense_screen.dart';
import 'package:storeedge/widgets/global/floating_action_button.dart';
import 'package:storeedge/widgets/global/noti_and_account_icon.dart';
import 'package:storeedge/widgets/others/used-in-expenses/header.dart';
import 'package:storeedge/widgets/others/used-in-expenses/tab_section.dart';
import 'package:storeedge/widgets/others/used-in-expenses/total_expenses_card.dart';
import 'package:storeedge/utils/constants.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFEEEEEE),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeConstants.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NotiAndAccountIconHeader(),
                const SizedBox(height: 20),
                const Header(),
                const SizedBox(height: 20),
                const TotalExpensesCard(),
                const SizedBox(height: 20),
                const Expanded(
                  child: TabSection(),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExpenseScreen(),
            ),
          );
        },
        assetPath: "assets/icons/add_icon.png",
        backgroundColor: const Color(0xFFB6EF86),
        size: 56,
        iconSize: 25,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
