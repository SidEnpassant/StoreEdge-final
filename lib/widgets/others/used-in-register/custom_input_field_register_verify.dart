import 'package:flutter/material.dart';
import 'package:storeedge/utils/constants.dart';

class CustomTextFieldRegisterVerify extends StatelessWidget {
  final String label;
  final String? placeholder;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;

  const CustomTextFieldRegisterVerify({
    Key? key,
    required this.label,
    this.placeholder,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.controller,
    this.initialValue,
    this.validator,
  })  : assert(!(controller != null && initialValue != null),
            'Cannot provide both controller and initialValue'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[300]!, // Added border color
              width: 1.5, // Adjusted width for better appearance
            ),
            // Optional: Add shadow for better depth
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                // Padding(
                //   padding: const EdgeInsets.only(left: 20),
                //   child: Icon(
                //     icon,
                //     size: 18,
                //     color: Colors.grey[600], // Added icon color
                //   ),
                // ),
                const SizedBox(width: 15),
              ],
              Expanded(
                child: TextFormField(
                  controller: controller,
                  initialValue: controller == null ? initialValue : null,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  validator: validator,
                  decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: TextStyle(
                        color: Colors.grey[400]), // Added hint text color
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
