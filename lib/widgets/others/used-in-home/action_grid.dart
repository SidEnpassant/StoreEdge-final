import 'package:flutter/material.dart';
import 'package:storeedge/screens/show_bills_screen.dart';

class ActionGrid extends StatefulWidget {
  const ActionGrid({Key? key}) : super(key: key);

  @override
  State<ActionGrid> createState() => _ActionGridState();
}

class _ActionGridState extends State<ActionGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimations = List.generate(6, (index) {
      final start = index * 0.15;
      final end = (start + 0.15).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start,
            end,
            curve: Curves.easeOutBack,
          ),
        ),
      );
    });

    _fadeAnimations = List.generate(6, (index) {
      final start = index * 0.15;
      final end = (start + 0.15).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start,
            end,
            curve: Curves.easeIn,
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      children: List.generate(6, (index) {
        final item = index == 0
            ? ActionItem(
                imagePath: 'assets/icons/bills.png',
                iconSize: 40,
                label: 'Bills',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BillsScreen()),
                ),
              )
            :
            // index == 1
            //     ? ActionItem(
            //         imagePath: 'assets/icons/stock-flow.png',
            //         iconSize: 40,
            //         label: 'Cashflow',
            //         onTap: () {},
            //       )
            ActionItemComingSoon(
                imagePath: index == 1
                    ? 'assets/icons/stock-flow.png'
                    : index == 2
                        ? 'assets/icons/tax.png'
                        : index == 3
                            ? 'assets/icons/details.png'
                            : index == 4
                                ? 'assets/icons/scan.png'
                                : 'assets/icons/others.png',
                iconSize: 40,
                label: index == 1
                    ? 'Cashflow'
                    : index == 2
                        ? 'Tax'
                        : index == 3
                            ? 'Details'
                            : index == 4
                                ? 'Scan'
                                : 'Others',
                onTap: () {},
              );

        return ScaleTransition(
          scale: _scaleAnimations[index],
          child: FadeTransition(
            opacity: _fadeAnimations[index],
            child: item,
          ),
        );
      }),
    );
  }
}

class ActionItem extends StatefulWidget {
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
  State<ActionItem> createState() => _ActionItemState();
}

class _ActionItemState extends State<ActionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _controller.reverse();
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5044FC).withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFF5044FC),
                      width: _isHovered ? 2.5 : 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5044FC).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          widget.imagePath,
                          width: widget.iconSize,
                          height: widget.iconSize,
                          color: const Color(0xFF5044FC),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ActionItemComingSoon extends StatefulWidget {
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
  State<ActionItemComingSoon> createState() => _ActionItemComingSoonState();
}

class _ActionItemComingSoonState extends State<ActionItemComingSoon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _controller.reverse();
        });
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: _isHovered ? 2.5 : 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              widget.imagePath,
                              width: widget.iconSize,
                              height: widget.iconSize,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.label,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Soon',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
