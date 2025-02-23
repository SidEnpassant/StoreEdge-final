import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldAddProductScreen extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController? controller;
  final bool isPrice;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFieldAddProductScreen({
    Key? key,
    required this.label,
    required this.placeholder,
    this.controller,
    this.isPrice = false,
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF5044FC),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: isPrice ? 32 : 16,
                right: 16,
              ),
              border: InputBorder.none,
              hintText: placeholder,
              hintStyle: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
              prefixIcon: isPrice
                  ? const Padding(
                      padding: EdgeInsets.only(left: 16, top: 12),
                      child: Text(
                        '\$',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    )
                  : null,
            ),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
