// lib/widgets/others/used-in-register/custom_text_field_register.dart

import 'package:flutter/material.dart';
import 'package:storeedge/utils/constants.dart';

class CustomTextFieldRegister extends StatefulWidget {
  final String label;
  final String? placeholder;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;

  const CustomTextFieldRegister({
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
  State<CustomTextFieldRegister> createState() =>
      _CustomTextFieldRegisterState();
}

class _CustomTextFieldRegisterState extends State<CustomTextFieldRegister> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: ThemeConstants.labelStyle,
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
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
              if (widget.icon != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Icon(
                    widget.icon,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 15),
              ],
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  initialValue:
                      widget.controller == null ? widget.initialValue : null,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText && _obscureText,
                  validator: widget.validator,
                  decoration: InputDecoration(
                    hintText: widget.placeholder,
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 20,
                    ),
                    // Continuing lib/widgets/others/used-in-register/custom_text_field_register.dart

                    suffixIcon: widget.obscureText
                        ? IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          )
                        : null,
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
