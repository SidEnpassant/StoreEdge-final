// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:storeedge/auth/login/login_screen.dart';
// import 'package:storeedge/auth/register/register_phone_verify.dart';
// import 'dart:io';
// import 'package:storeedge/utils/constants.dart';
// import 'package:storeedge/widgets/others/used-in-register/custom_text_field_register.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   File? _signatureImage;

//   Future<void> _pickImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(source: ImageSource.gallery);

//       if (image != null) {
//         setState(() {
//           _signatureImage = File(image.path);
//         });
//       }
//     } catch (e) {
//       // Handle error
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to pick image')),
//       );
//     }
//   }

//   Widget _buildSignatureSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Add Signature (optional)',
//           style: ThemeConstants.labelStyle,
//         ),
//         const SizedBox(height: 6),
//         GestureDetector(
//           onTap: _pickImage,
//           child: Container(
//             width: double.infinity,
//             height: 120,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(ThemeConstants.borderRadius),
//               border: Border.all(
//                 color: ThemeConstants.primaryColor,
//                 width: 2,
//               ),
//             ),
//             padding: const EdgeInsets.symmetric(
//               vertical: 16,
//               horizontal: 20,
//             ),
//             child: _signatureImage != null
//                 ? ClipRRect(
//                     borderRadius:
//                         BorderRadius.circular(ThemeConstants.borderRadius - 2),
//                     child: Image.file(
//                       _signatureImage!,
//                       fit: BoxFit.contain,
//                     ),
//                   )
//                 : Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: const [
//                       Icon(
//                         Icons.add_photo_alternate_outlined,
//                         size: 32,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Click to upload signature',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ThemeConstants.backgroundColor,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             constraints: const BoxConstraints(maxWidth: 412),
//             margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back),
//                 ),
//                 const SizedBox(height: 24),
//                 Text('Register', style: ThemeConstants.titleStyle),
//                 const SizedBox(height: 16),
//                 RichText(
//                   text: TextSpan(
//                     style: ThemeConstants.subtitleStyle,
//                     children: [
//                       const TextSpan(text: 'Create an '),
//                       TextSpan(
//                         text: 'account',
//                         style: ThemeConstants.subtitleStyle.copyWith(
//                           color: ThemeConstants.primaryColor,
//                         ),
//                       ),
//                       const TextSpan(
//                         text: ' to access all the features of StoreEdge',
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       const CustomTextFieldRegister(
//                         label: 'Email',
//                         placeholder: 'Ex: abc@example.com',
//                         icon: Icons.mail_outline_sharp,
//                         keyboardType: TextInputType.emailAddress,
//                       ),
//                       const SizedBox(height: ThemeConstants.spacing),
//                       const CustomTextFieldRegister(
//                         label: 'Your Name',
//                         placeholder: 'Ex. Saul Ramirez',
//                         icon: Icons.person,
//                       ),
//                       const SizedBox(height: ThemeConstants.spacing),
//                       const CustomTextFieldRegister(
//                         label: 'Your Password',
//                         icon: Icons.lock,
//                         obscureText: true,
//                       ),
//                       const SizedBox(height: ThemeConstants.spacing),
//                       const CustomTextFieldRegister(
//                         label: 'Phone number',
//                         placeholder: 'Ex. 9999999999',
//                         icon: Icons.phone,
//                         keyboardType: TextInputType.phone,
//                       ),
//                       const SizedBox(height: ThemeConstants.spacing),
//                       const CustomTextFieldRegister(
//                         label: 'Business name',
//                         placeholder: 'Ex. Sp stores',
//                       ),
//                       const SizedBox(height: ThemeConstants.spacing),
//                       const CustomTextFieldRegister(
//                         label: 'Business address',
//                         placeholder: 'Ex. 32 sukhia street,kol-700021',
//                       ),
//                       const SizedBox(height: ThemeConstants.spacing),
//                       const CustomTextFieldRegister(
//                         label: 'GST number (optional)',
//                         placeholder: '27AAAPA1234A1Z5',
//                       ),
//                       const SizedBox(height: ThemeConstants.spacing),
//                       _buildSignatureSection(),
//                       const SizedBox(height: 40),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         RegisterPhoneVerifyScreen()), // Assumes you have a ProfileScreen widget
//                               );
//                               // Handle registration
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: ThemeConstants.primaryColor,
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(
//                                 ThemeConstants.borderRadius,
//                               ),
//                             ),
//                           ),
//                           child: Text(
//                             'Register',
//                             style: ThemeConstants.buttonStyle,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Already have an account?',
//                             style: ThemeConstants.labelStyle,
//                           ),
//                           const SizedBox(width: 6),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         LoginScreen()), // Assumes you have a ProfileScreen widget
//                               );
//                               // Handle navigation to login
//                             },
//                             child: Text(
//                               'Login',
//                               style: ThemeConstants.labelStyle.copyWith(
//                                   decoration: TextDecoration.underline,
//                                   color: Color(0xFF5044FC)),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/screens/auth/register/register_screen.dart

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

class _RegisterScreenState extends State<RegisterScreen> {
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _gstController.dispose();
    super.dispose();
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
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false,
        );
        // Step 2: Automatically login the user
        final loginResponse = await _authService.login(
          _emailController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        if (loginResponse.success && loginResponse.data != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );

          // Navigate to MainScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        } else {
          throw Exception(loginResponse.message);
        }
      } else {
        throw Exception(registerResponse.message);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.backgroundColor,
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
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(height: 24),
                  Text('Register', style: ThemeConstants.titleStyle),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: ThemeConstants.subtitleStyle,
                      children: [
                        const TextSpan(text: 'Create an '),
                        TextSpan(
                          text: 'account',
                          style: ThemeConstants.subtitleStyle.copyWith(
                            color: ThemeConstants.primaryColor,
                          ),
                        ),
                        const TextSpan(
                          text: ' to access all the features of StoreEdge',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomTextFieldRegister(
                    controller: _nameController,
                    label: 'Your Name',
                    placeholder: 'Ex. Saul Ramirez',
                    icon: Icons.person,
                    validator: (value) => _validateRequired(value, 'name'),
                  ),
                  const SizedBox(height: ThemeConstants.spacing),
                  CustomTextFieldRegister(
                    controller: _emailController,
                    label: 'Email',
                    placeholder: 'Ex: abc@example.com',
                    icon: Icons.mail_outline_sharp,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: ThemeConstants.spacing),
                  CustomTextFieldRegister(
                    controller: _passwordController,
                    label: 'Your Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) => _validateRequired(value, 'password'),
                  ),
                  const SizedBox(height: ThemeConstants.spacing),
                  CustomTextFieldRegister(
                    controller: _phoneController,
                    label: 'Phone number',
                    placeholder: 'Ex. 9999999999',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: ThemeConstants.spacing),
                  CustomTextFieldRegister(
                    controller: _businessNameController,
                    label: 'Business name',
                    placeholder: 'Ex. Sp stores',
                    validator: (value) =>
                        _validateRequired(value, 'business name'),
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
                  const SizedBox(height: ThemeConstants.spacing),
                  _buildSignatureSection(),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeConstants.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            ThemeConstants.borderRadius,
                          ),
                        ),
                      ),
                      child: Text(
                        _isLoading ? 'Registering...' : 'Register',
                        style: ThemeConstants.buttonStyle,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: ThemeConstants.labelStyle,
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Login',
                          style: ThemeConstants.labelStyle.copyWith(
                            decoration: TextDecoration.underline,
                            color: const Color(0xFF5044FC),
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
