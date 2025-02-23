import 'package:flutter/material.dart';

class ProfileItem extends StatelessWidget {
  final String title;

  const ProfileItem({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFB6EF86),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.grid_view,
            color: Colors.black,
            size: 24,
          ),
        ),
        const SizedBox(width: 23),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Colors.black,
                size: 28,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
