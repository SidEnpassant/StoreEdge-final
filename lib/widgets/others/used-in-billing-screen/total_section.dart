import 'package:flutter/material.dart';

class TotalSection extends StatefulWidget {
  final double total;
  final Function(double) onDiscountChanged;

  const TotalSection({
    Key? key,
    required this.total,
    required this.onDiscountChanged,
  }) : super(key: key);

  @override
  State<TotalSection> createState() => _TotalSectionState();
}

class _TotalSectionState extends State<TotalSection> {
  final TextEditingController _discountController = TextEditingController();
  double _discount = 0;

  @override
  void initState() {
    super.initState();
    _discountController.addListener(_updateDiscount);
  }

  void _updateDiscount() {
    setState(() {
      _discount = double.tryParse(_discountController.text) ?? 0;
      widget.onDiscountChanged(_discount);
    });
  }

  @override
  Widget build(BuildContext context) {
    double grandTotal = widget.total - _discount;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF5044FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildRow('Total -', 'Rs ${widget.total.toStringAsFixed(2)}'),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Discount -',
                style: TextStyle(
                  color: Color(0xFFB6EF86),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Rs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      controller: _discountController,
                      cursorColor: const Color(0xFFB6EF86),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 13),
          _buildRow('Grand total -', 'Rs ${grandTotal.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFB6EF86),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
