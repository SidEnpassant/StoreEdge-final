import 'package:flutter/material.dart';
import 'dart:io';

class ImageUploadWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String? imagePath;

  const ImageUploadWidget({
    Key? key,
    required this.onTap,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width <= 640 ? 100 : 128,
            height: MediaQuery.of(context).size.width <= 640 ? 100 : 128,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
              image: imagePath != null
                  ? DecorationImage(
                      image: FileImage(File(imagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imagePath == null
                ? const Center(
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 30,
                      color: Color(0xFF9CA3AF),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          imagePath == null ? 'Add Product Image' : 'Change Image',
          style: const TextStyle(
            color: Color(0xFF5044FC),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
