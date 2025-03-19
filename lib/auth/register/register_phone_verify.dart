import 'package:flutter/material.dart';
import 'package:storeedge/screens/nav-bar-call-main-screen/main_screen.dart';
import 'package:storeedge/utils/constants.dart';
import 'package:storeedge/widgets/others/used-in-register/custom_text_field_register.dart';

class RegisterPhoneVerifyScreen extends StatefulWidget {
  const RegisterPhoneVerifyScreen({Key? key}) : super(key: key);

  @override
  _RegisterPhoneVerifyScreenState createState() =>
      _RegisterPhoneVerifyScreenState();
}

class _RegisterPhoneVerifyScreenState extends State<RegisterPhoneVerifyScreen> {
  final _formKey = GlobalKey<FormState>();

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
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(height: 24),
                  Text('Verify', style: ThemeConstants.titleStyle),
                  const SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: ThemeConstants.subtitleStyle,
                      children: [
                        const TextSpan(text: 'We have sent a '),
                        TextSpan(
                          text: 'MESSAGE',
                          style: ThemeConstants.subtitleStyle.copyWith(
                            color: ThemeConstants.primaryColor,
                          ),
                        ),
                        const TextSpan(
                          text: ' to your phone number to verify',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const CustomTextFieldRegister(
                          label: 'Verification Code',
                          placeholder: 'Ex. 786987',
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: ThemeConstants.spacing),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeConstants.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  ThemeConstants.borderRadius,
                                ),
                              ),
                            ),
                            child: Text(
                              'Verify',
                              style: ThemeConstants.buttonStyle,
                            ),
                          ),
                        ),
                      ],
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
