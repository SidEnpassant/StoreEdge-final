import 'package:flutter/material.dart';
import 'package:storeedge/screens/show_bills_screen.dart';

class ActionGrid extends StatelessWidget {
  const ActionGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        ActionItem(
          imagePath: 'assets/icons/bills.png',
          iconSize: 40,
          label: 'Bills',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BillsScreen()),
          ),
        ),
        ActionItem(
          imagePath: 'assets/icons/stock-flow.png',
          iconSize: 40,
          label: 'Stock Flow',
          onTap: () {}, // Add navigation for other screens as needed
        ),
        ActionItemComingSoon(
          imagePath: 'assets/icons/tax.png',
          iconSize: 40,
          label: 'Tax',
          onTap: () {},
        ),
        ActionItemComingSoon(
          imagePath: 'assets/icons/details.png',
          iconSize: 40,
          label: 'Details',
          onTap: () {},
        ),
        ActionItemComingSoon(
          imagePath: 'assets/icons/scan.png',
          iconSize: 40,
          label: 'Scan',
          onTap: () {},
        ),
        ActionItemComingSoon(
          imagePath: 'assets/icons/others.png',
          iconSize: 40,
          label: 'Others',
          onTap: () {},
        ),
      ],
    );
  }
}

class ActionItem extends StatelessWidget {
  final String imagePath;
  final String label;
  final double iconSize;
  final VoidCallback onTap;

  const ActionItem({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF5044FC), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: iconSize,
              height: iconSize,
              color: const Color(0xFF5044FC),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ActionItemComingSoon extends StatelessWidget {
  final String imagePath;
  final String label;
  final double iconSize;
  final VoidCallback onTap;

  const ActionItemComingSoon({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
    this.iconSize = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: const Color.fromARGB(255, 150, 149, 149), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: iconSize,
              height: iconSize,
              color: const Color.fromARGB(255, 129, 129, 130),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
