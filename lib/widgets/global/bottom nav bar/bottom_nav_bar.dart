import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedBottomBar extends StatefulWidget {
  final Function(int) onIndexChanged;
  final int currentIndex;

  const AnimatedBottomBar({
    Key? key,
    required this.onIndexChanged,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<AnimatedBottomBar> createState() => _AnimatedBottomBarState();
}

class _AnimatedBottomBarState extends State<AnimatedBottomBar>
    with SingleTickerProviderStateMixin {
  final Color activeColor = const Color(0xFF5044FC);

  late final AnimationController _controller;

  final List<NavItem> _items = [
    NavItem(
      activeSvgPath: 'assets/bottom_nav_bar_icons/active icons/home_active.svg',
      inactiveSvgPath:
          'assets/bottom_nav_bar_icons/inactive icons/home_inactive.svg',
      label: 'Home',
    ),
    NavItem(
      activeSvgPath:
          'assets/bottom_nav_bar_icons/active icons/expenses_active.svg',
      inactiveSvgPath:
          'assets/bottom_nav_bar_icons/inactive icons/expenses_inactive.svg',
      label: 'Expenses',
    ),
    NavItem(
      activeSvgPath:
          'assets/bottom_nav_bar_icons/active icons/billing_active.svg',
      inactiveSvgPath:
          'assets/bottom_nav_bar_icons/inactive icons/billing_inactive.svg',
      label: 'Billing',
    ),
    NavItem(
      activeSvgPath:
          'assets/bottom_nav_bar_icons/active icons/inventory_active.svg',
      inactiveSvgPath:
          'assets/bottom_nav_bar_icons/inactive icons/inventory_inactive.svg',
      label: 'Inventory',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIcon(NavItem item, bool isSelected) {
    try {
      return SvgPicture.asset(
        isSelected ? item.activeSvgPath : item.inactiveSvgPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isSelected ? activeColor : Colors.grey,
          BlendMode.srcIn,
        ),
      );
    } catch (e) {
      debugPrint('Error loading SVG: $e');
      return Icon(
        Icons.circle,
        color: isSelected ? activeColor : Colors.grey,
        size: 24,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isSelected = widget.currentIndex == index;

          return GestureDetector(
            onTap: () => widget.onIndexChanged(index),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIcon(item, isSelected),
                  const SizedBox(height: 4),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: 'Ravenna-Serial-ExtraBold',
                      color: isSelected ? activeColor : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class NavItem {
  final String activeSvgPath;
  final String inactiveSvgPath;
  final String label;

  NavItem({
    required this.activeSvgPath,
    required this.inactiveSvgPath,
    required this.label,
  });
}
