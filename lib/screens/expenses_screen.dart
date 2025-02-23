import 'package:flutter/material.dart';
import 'package:storeedge/screens/add_expense_screen.dart';
import 'package:storeedge/widgets/global/floating_action_button.dart';
import 'package:storeedge/widgets/global/noti_and_account_icon.dart';
import 'package:storeedge/widgets/others/used-in-expenses/header.dart';
import 'package:storeedge/widgets/others/used-in-expenses/tab_section.dart';
import 'package:storeedge/widgets/others/used-in-expenses/total_expenses_card.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
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
                child: const TabSection(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddExpenseScreen()), // Assumes you have a ProfileScreen widget
          );
        },
        assetPath:
            "assets/icons/add_icon.png", // Ensure this matches your asset
        backgroundColor: Color(0xFFB6EF86), // Customize FAB color
        size: 56, // Adjust size if needed
        iconSize: 25, // Adjust icon size if needed
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
