import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const CustomSearchBar({
    Key? key,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 20,
            color: Colors.black,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onSearch,
              decoration: const InputDecoration(
                hintText: 'Search inventory...',
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF010101),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
