import 'package:flutter/material.dart';
import 'package:storeedge/auth/login/login_with_otp.dart';
import 'package:storeedge/auth/register/register_screen.dart';
import 'package:storeedge/screens/nav-bar-call-main-screen/main_screen.dart';
import 'package:storeedge/services/models/user_model.dart';
import 'package:storeedge/services/settings/local_storage.dart';
import 'package:storeedge/services/settings/token_storage.dart';
import 'package:storeedge/utils/theme/app_theme.dart';
import 'package:storeedge/utils/constants.dart';
import 'package:storeedge/widgets/others/used-in-login/custom_button_login.dart';
import 'package:storeedge/widgets/others/used-in-login/custom_input_field_login.dart';
import 'package:storeedge/services/functions/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your password';
    }
    if (value!.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final response = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        // Save the user data
        User user = User(
          id: response.data!.user.id,
          name: response.data!.user.name,
          email: response.data!.user.email,
          phone: response.data!.user.phone, // This might be a String
          businessName: response.data!.user.businessName,
          businessAddress: response.data!.user.businessAddress,
          gst: response.data!.user.gst,
          signature: response.data!.user.signature,
          signatureId: response.data!.user.signatureId,
          createdAt: response.data!.user.createdAt,
          updatedAt: response.data!.user.updatedAt,
        );
        await saveUser(user);

        // Save the token
        await TokenStorage.saveToken(response.data!.accesstoken);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Login failed: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleLoginSync() {
    _handleLogin(); // Call the async function without awaiting it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 412),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // Header
                  Text('Login', style: ThemeConstants.titleStyle),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: AppTheme.subtitleStyle,
                      children: const [
                        TextSpan(text: 'Login now to get access to\n'),
                        TextSpan(text: 'StoreEdge'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Input
                  CustomInputFieldLogin(
                    label: 'Email',
                    hint: 'Ex: abc@example.com',
                    icon: Icons.mail_sharp,
                    controller: _emailController,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 24),

                  // Password Input
                  CustomInputFieldLogin(
                    label: 'Your Password',
                    hint: '••••••••',
                    obscureText: true,
                    isPassword: true,
                    icon: Icons.lock,
                    controller: _passwordController,
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 24),

                  // Login Button
                  CustomButtonLogin(
                    text: _isLoading ? 'Logging in...' : 'Login',
                    onPressed: _isLoading
                        ? null
                        : () async {
                            await _handleLogin();
                          },
                  ),

                  const SizedBox(height: 24),

                  // Divider
                  const Divider(color: Colors.black, height: 1),
                  const SizedBox(height: 24),

                  // OTP Button
                  CustomButtonLogin(
                    text: 'Login with OTP',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginOtpScreen(),
                        ),
                      );
                    },
                    outlined: true,
                  ),
                  const SizedBox(height: 24),

                  // Register Prompt
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: AppTheme.subtitleStyle,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Register',
                          style: AppTheme.subtitleStyleRegister.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
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
