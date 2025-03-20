import 'package:flutter/material.dart';
import 'dart:async';

class WelcomeHeader extends StatefulWidget {
  const WelcomeHeader({Key? key}) : super(key: key);

  @override
  State<WelcomeHeader> createState() => _WelcomeHeaderState();
}

class _WelcomeHeaderState extends State<WelcomeHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  String _currentText = '';
  String _targetText = 'Welcome';
  bool _isTyping = false;
  Timer? _greetingTimer;
  Timer? _typingTimer;
  Timer? _subtextTimer;

  bool _showFirstSubtext = true;
  double _subtextOpacity = 1.0;

  final List<String> _welcomeTexts = [
    'Welcome',
    'स्वागत है',
    'স্বাগতম',
  ];
  int _currentWelcomeIndex = 0;

  final List<String> _subtexts = [
    'Manage your store efficiently',
    'Use StoreEdge easily',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-0.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    _controller.forward();

    // Start the typing animation
    _startTypingAnimation();

    // Start greeting timer
    _startGreetingTimer();

    // Start subtext timer
    _startSubtextTimer();
  }

  void _startTypingAnimation() {
    if (_isTyping) return;
    _isTyping = true;
    _currentText = '';

    void typeNextChar(int index) {
      if (!mounted) return;
      setState(() {
        _currentText = _targetText.substring(0, index);
      });

      if (index < _targetText.length) {
        _typingTimer = Timer(const Duration(milliseconds: 100), () {
          typeNextChar(index + 1);
        });
      } else {
        _isTyping = false;
      }
    }

    typeNextChar(0);
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    String timeBasedGreeting;

    if (hour < 12) {
      timeBasedGreeting = _currentWelcomeIndex == 0
          ? 'Good Morning'
          : _currentWelcomeIndex == 1
              ? 'शुभ प्रभात'
              : 'শুভ সকাল';
    } else if (hour < 17) {
      timeBasedGreeting = _currentWelcomeIndex == 0
          ? 'Good Afternoon'
          : _currentWelcomeIndex == 1
              ? 'शुभ दोपहर'
              : 'শুভ দুপুর';
    } else if (hour < 21) {
      timeBasedGreeting = _currentWelcomeIndex == 0
          ? 'Good Evening'
          : _currentWelcomeIndex == 1
              ? 'शुभ संध्या'
              : 'শুভ সন্ধ্যা';
    } else {
      timeBasedGreeting = _currentWelcomeIndex == 0
          ? 'Good Night'
          : _currentWelcomeIndex == 1
              ? 'शुभ रात्रि'
              : 'শুভ রাত্রি';
    }
    return timeBasedGreeting;
  }

  void _startGreetingTimer() {
    _greetingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) return;
      setState(() {
        if (_targetText == _welcomeTexts[_currentWelcomeIndex]) {
          _targetText = _getTimeBasedGreeting();
        } else {
          _currentWelcomeIndex =
              (_currentWelcomeIndex + 1) % _welcomeTexts.length;
          _targetText = _welcomeTexts[_currentWelcomeIndex];
        }
        _startTypingAnimation();
      });
    });
  }

  void _startSubtextTimer() {
    _subtextTimer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
      if (!mounted) return;

      // Start fade out
      setState(() {
        _subtextOpacity = 0.0;
      });

      // Change text and fade in after fade out
      Timer(const Duration(milliseconds: 500), () {
        if (!mounted) return;
        setState(() {
          _showFirstSubtext = !_showFirstSubtext;
          _subtextOpacity = 1.0;
        });
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _greetingTimer?.cancel();
    _typingTimer?.cancel();
    _subtextTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _currentText,
                style: TextStyle(
                  color: const Color(0xFF5044FC),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: const Color(0xFF5044FC).withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: _subtextOpacity,
                child: Text(
                  _showFirstSubtext ? _subtexts[0] : _subtexts[1],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
