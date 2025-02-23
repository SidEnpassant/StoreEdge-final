import 'package:flutter/material.dart';
import 'package:storeedge/screens/billing_screen.dart';
import 'package:storeedge/screens/expenses_screen.dart';
import 'package:storeedge/screens/home.dart';
import 'package:storeedge/screens/inventory_screen.dart';
import 'package:storeedge/widgets/global/bottom%20nav%20bar/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    const HomeScreen(),
    const ExpensesScreen(),
    const BillingScreen(),
    const InventoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: AnimatedBottomBar(
        currentIndex: _currentIndex,
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
