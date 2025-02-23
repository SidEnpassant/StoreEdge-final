import 'package:flutter/material.dart';

class CustomerInfo extends StatefulWidget {
  final Function(String, String, String) onCustomerInfoChanged;

  const CustomerInfo({
    Key? key,
    required this.onCustomerInfoChanged,
  }) : super(key: key);

  @override
  State<CustomerInfo> createState() => _CustomerInfoState();
}

class _CustomerInfoState extends State<CustomerInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    void onChanged() {
      widget.onCustomerInfoChanged(
        _nameController.text,
        _addressController.text,
        _phoneController.text,
      );
    }

    _nameController.addListener(onChanged);
    _addressController.addListener(onChanged);
    _phoneController.addListener(onChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5044FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(_nameController, 'Name', 'Enter customer name',
              TextInputType.text),
          const SizedBox(height: 19),
          _buildInputField(_addressController, 'Address',
              'Enter customer address', TextInputType.text),
          const SizedBox(height: 19),
          _buildInputField(_phoneController, 'Phone number',
              'Enter customer phone number', TextInputType.number),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String label,
    String hint,
    TextInputType keyboardType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB6EF86),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 19),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  const BorderSide(color: Color.fromARGB(153, 231, 223, 223)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}
