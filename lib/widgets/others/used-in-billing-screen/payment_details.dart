import 'package:flutter/material.dart';

class PaymentDetails extends StatefulWidget {
  final Function(String, String, double) onPaymentDetailsChanged;
  final double totalAmount;

  const PaymentDetails({
    Key? key,
    required this.onPaymentDetailsChanged,
    required this.totalAmount,
  }) : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  String _selectedPaymentMethod = 'Cash';
  String _selectedPaymentStatus = 'Paid';
  final TextEditingController _paidAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _paidAmountController.text = widget.totalAmount.toString();
    _notifyPaymentDetails();
  }

  void _notifyPaymentDetails() {
    double paidAmount = _selectedPaymentStatus == 'Paid'
        ? widget.totalAmount
        : double.tryParse(_paidAmountController.text) ?? 0;

    widget.onPaymentDetailsChanged(
      _selectedPaymentMethod,
      _selectedPaymentStatus,
      paidAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF5044FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.credit_card, color: Color(0xFFB6EF86)),
              SizedBox(width: 17),
              Text(
                'Payment details',
                style: TextStyle(
                  color: Color(0xFFB6EF86),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildDropdown(
            'Payment method -',
            _selectedPaymentMethod,
            ['Cash', 'Online'],
            (String? value) {
              if (value != null) {
                setState(() {
                  _selectedPaymentMethod = value;
                  _notifyPaymentDetails();
                });
              }
            },
          ),
          const SizedBox(height: 15),
          _buildDropdown(
            'Payment status -',
            _selectedPaymentStatus,
            ['Paid', 'Partially Paid'],
            (String? value) {
              if (value != null) {
                setState(() {
                  _selectedPaymentStatus = value;
                  if (value == 'Paid') {
                    _paidAmountController.text = widget.totalAmount.toString();
                  }
                  _notifyPaymentDetails();
                });
              }
            },
          ),
          const SizedBox(height: 15),
          if (_selectedPaymentStatus == 'Partially Paid') _buildAmountInput(),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Paid amount -',
          style: TextStyle(
            color: Color(0xFFB6EF86),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('Rs -'),
              Expanded(
                child: TextField(
                  controller: _paidAmountController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _notifyPaymentDetails(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    // Same as before
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
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(16),
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: Container(),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
