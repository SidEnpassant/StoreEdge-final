import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:storeedge/auth/login/login_screen.dart';
import 'package:storeedge/auth/register/register_phone_verify.dart';
import 'package:storeedge/screens/nav-bar-call-main-screen/main_screen.dart';
import 'package:storeedge/services/functions/auth_service.dart';
import 'package:storeedge/services/functions/register_service.dart';
import 'package:storeedge/utils/constants.dart';
import 'package:storeedge/widgets/others/used-in-register/custom_text_field_register.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _gstController = TextEditingController();
  File? _signatureImage;
  bool _isLoading = false;
  final _registerService = RegisterService();
  final _authService = AuthService();

  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _registrationSteps = [
    {
      'title': 'What\'s your name?',
      'subtitle': 'Enter your full name',
      'field': 'name',
    },
    {
      'title': 'Your email address',
      'subtitle': 'We\'ll send you important updates',
      'field': 'email',
    },
    {
      'title': 'Create a password',
      'subtitle': 'Make it strong and secure',
      'field': 'password',
    },
    {
      'title': 'Your phone number',
      'subtitle': 'We\'ll use this for verification',
      'field': 'phone',
    },
    {
      'title': 'Business details',
      'subtitle': 'Tell us about your business',
      'field': 'business',
    },
    {
      'title': 'Add your signature',
      'subtitle': 'Upload your signature (optional)',
      'field': 'signature',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero)
            .animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _gstController.dispose();
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _registrationSteps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    } else {
      _handleRegistration();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _animationController.reset();
      _animationController.forward();
    }
  }

  Widget _buildProgressIndicator() {
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentPage + 1) / _registrationSteps.length,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          valueColor:
              AlwaysStoppedAnimation<Color>(ThemeConstants.primaryColor),
          minHeight: 4,
        ),
        const SizedBox(height: 8),
        Text(
          '${_currentPage + 1}/${_registrationSteps.length}',
          style: ThemeConstants.labelStyle,
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _signatureImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Signature (optional)',
          style: ThemeConstants.labelStyle,
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
              border: Border.all(
                color: ThemeConstants.primaryColor,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 20,
            ),
            child: _signatureImage != null
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(ThemeConstants.borderRadius - 2),
                    child: Image.file(
                      _signatureImage!,
                      fit: BoxFit.contain,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 32,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Click to upload signature',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepContent(Map<String, dynamic> step) {
    switch (step['field']) {
      case 'name':
        return CustomTextFieldRegister(
          controller: _nameController,
          label: 'Your Name',
          placeholder: 'Ex. Saul Ramirez',
          icon: Icons.person,
          validator: (value) => _validateRequired(value, 'name'),
        );
      case 'email':
        return CustomTextFieldRegister(
          controller: _emailController,
          label: 'Email',
          placeholder: 'Ex: abc@example.com',
          icon: Icons.mail_outline_sharp,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
        );
      case 'password':
        return CustomTextFieldRegister(
          controller: _passwordController,
          label: 'Your Password',
          icon: Icons.lock,
          obscureText: true,
          validator: (value) => _validateRequired(value, 'password'),
        );
      case 'phone':
        return CustomTextFieldRegister(
          controller: _phoneController,
          label: 'Phone number',
          placeholder: 'Ex. 9999999999',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          validator: _validatePhone,
        );
      case 'business':
        return Column(
          children: [
            CustomTextFieldRegister(
              controller: _businessNameController,
              label: 'Business name',
              placeholder: 'Ex. Sp stores',
              validator: (value) => _validateRequired(value, 'business name'),
            ),
            const SizedBox(height: ThemeConstants.spacing),
            CustomTextFieldRegister(
              controller: _businessAddressController,
              label: 'Business address',
              placeholder: 'Ex. 32 sukhia street,kol-700021',
              validator: (value) =>
                  _validateRequired(value, 'business address'),
            ),
            const SizedBox(height: ThemeConstants.spacing),
            CustomTextFieldRegister(
              controller: _gstController,
              label: 'GST number (optional)',
              placeholder: '27AAAPA1234A1Z5',
            ),
          ],
        );
      case 'signature':
        return _buildSignatureSection();
      default:
        return const SizedBox.shrink();
    }
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your $fieldName';
    }
    return null;
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

  String? _validatePhone(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please enter your phone number';
    }
    if (value!.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Step 1: Register the user
      final registerResponse = await _registerService.register(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text,
        businessName: _businessNameController.text,
        businessAddress: _businessAddressController.text,
        gst: _gstController.text,
        signatureImage: _signatureImage,
      );

      if (!mounted) return;

      if (registerResponse.success) {
        // Step 2: Automatically login the user to get the token
        final loginResponse = await _authService.login(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        if (loginResponse.success && loginResponse.data != null) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );

          // Navigate to MainScreen and clear the stack
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        } else {
          throw Exception(
              loginResponse.message ?? 'Login failed after registration');
        }
      } else {
        throw Exception(registerResponse.message ?? 'Registration failed');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (_currentPage > 0)
                            GestureDetector(
                              onTap: _previousPage,
                              child: const Icon(Icons.arrow_back),
                            ),
                          if (_currentPage > 0) const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildProgressIndicator(),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                      _animationController.reset();
                      _animationController.forward();
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _registrationSteps.length,
                    itemBuilder: (context, index) {
                      final step = _registrationSteps[index];
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(step['title'],
                                    style: ThemeConstants.titleStyle),
                                const SizedBox(height: 8),
                                Text(step['subtitle'],
                                    style: ThemeConstants.subtitleStyle),
                                const SizedBox(height: 40),
                                _buildStepContent(step),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _nextPage,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          ThemeConstants.primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            ThemeConstants.borderRadius),
                                      ),
                                    ),
                                    child: Text(
                                      _currentPage ==
                                              _registrationSteps.length - 1
                                          ? (_isLoading
                                              ? 'Registering...'
                                              : 'Register')
                                          : 'Next',
                                      style: ThemeConstants.buttonStyle,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
