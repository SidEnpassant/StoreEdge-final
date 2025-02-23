import 'package:flutter/material.dart';

class BillingHeader extends StatelessWidget {
  const BillingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Billing',
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width > 640 ? 32 : 28,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
