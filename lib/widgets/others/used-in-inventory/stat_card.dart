import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String iconAssetPath;
  final String title;
  final String value;

  const StatCard({
    Key? key,
    required this.iconAssetPath,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add constraints to limit the width
      constraints: const BoxConstraints(maxWidth: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5044FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        // Prevent Row from expanding beyond bounds
        mainAxisSize: MainAxisSize.min,
        children: [
          // Using Image.asset with fixed dimensions
          SizedBox(
            width: 24,
            height: 24,
            child: Image.asset(
              iconAssetPath,
              color: Colors.white,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          // Flexible allows the child to shrink
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                  // Force single line with ellipsis
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  // Force single line with ellipsis
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
