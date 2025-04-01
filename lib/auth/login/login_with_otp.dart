import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeedge/screens/nav-bar-call-main-screen/main_screen.dart';
import 'package:storeedge/utils/theme/app_colors.dart';
import 'package:storeedge/widgets/others/used-in-login-with-otp/custom_input_field.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:storeedge/utils/constants.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({Key? key}) : super(key: key);

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String? _userId;
  bool _isLoading = false;
  bool _isOtpSent = false;
  bool _isVerified = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.easeInOut,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _shakeController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _shakeController.forward();
        }
      });
    _shakeController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter phone number')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(
            'https://diversionbackend.onrender.com/api/users/phone/otp/send'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'phone': '+91${_phoneController.text}',
        }),
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        setState(() {
          _userId = data['data']['userId'];
          _isOtpSent = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent successfully')),
        );
      } else {
        throw Exception(data['message'] ?? 'Failed to send OTP');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error: Either no account exists with this phone number or its a internal server error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty || _userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter OTP')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(
            'https://diversionbackend.onrender.com/api/users/phone/otp/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': _userId,
          'phone': '+91${_phoneController.text}',
          'otp': _otpController.text,
        }),
      );

      final data = json.decode(response.body);

      if (data['success'] == true) {
        setState(() => _isVerified = true);

        // Store access token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', data['data']['accesstoken']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );

        // Delay navigation to show success animation
        await Future.delayed(const Duration(milliseconds: 1500));

        // Navigate to MainScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
      } else {
        throw Exception(data['message'] ?? 'Failed to verify OTP');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (!_isVerified) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeConstants.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 412),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(height: 100),
                  const Text(
                    'Login with OTP',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      height: 0.75,
                      letterSpacing: -0.352,
                    ),
                  ),
                  const SizedBox(height: 19),
                  const Text(
                    'Login with OTP by entering your phone number',
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.176,
                    ),
                  ),
                  const SizedBox(height: 51),
                  Container(
                    decoration: BoxDecoration(
                      color: _isOtpSent
                          ? Colors.grey.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        AbsorbPointer(
                          absorbing: _isOtpSent,
                          child: Opacity(
                            opacity: _isOtpSent ? 0.5 : 1.0,
                            child: CustomInputFieldLoginWithOtp(
                              label: 'Phone Number',
                              placeholder: 'Enter your phone number',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              prefix: const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  '+91',
                                  style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (!_isOtpSent) ...[
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _shakeAnimation,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(_shakeAnimation.value, 0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _sendOtp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Get OTP',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontFamily: 'Inter',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 51),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _isOtpSent ? 1.0 : 0.5,
                    child: AbsorbPointer(
                      absorbing: !_isOtpSent,
                      child: Column(
                        children: [
                          CustomInputFieldLoginWithOtp(
                            label: 'Verification Code',
                            placeholder: 'Enter OTP',
                            controller: _otpController,
                            isCenter: true,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 21),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: _isVerified ? 56 : double.infinity,
                            height: 56,
                            child: _isVerified
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  )
                                : ElevatedButton(
                                    onPressed: _isLoading ? null : _verifyOtp,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.all(16),
                                    ),
                                    child: _isLoading
                                        ? const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors.white,
                                          )
                                        : const Text(
                                            'Verify',
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: -0.264,
                                            ),
                                          ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
