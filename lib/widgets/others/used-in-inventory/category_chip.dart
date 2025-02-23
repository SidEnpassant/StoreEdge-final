import 'package:flutter/material.dart';

class CategoryChips extends StatefulWidget {
  final List<String> categories;
  final double spacing;
  final EdgeInsetsGeometry padding;

  const CategoryChips({
    Key? key,
    required this.categories,
    this.spacing = 9.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0),
  }) : super(key: key);

  @override
  State<CategoryChips> createState() => _CategoryChipsState();
}

class _CategoryChipsState extends State<CategoryChips> {
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _buildChips(),
        ),
      ),
    );
  }

  List<Widget> _buildChips() {
    List<Widget> chips = [];

    for (int i = 0; i < widget.categories.length; i++) {
      chips.add(
        _CategoryChipItem(
          label: widget.categories[i],
          isSelected: selectedCategory == widget.categories[i],
          onTap: () {
            setState(() {
              selectedCategory = widget.categories[i];
            });
          },
        ),
      );

      // Add spacing between chips (except after the last one)
      if (i < widget.categories.length - 1) {
        chips.add(SizedBox(width: widget.spacing));
      }
    }

    return chips;
  }
}

class _CategoryChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChipItem({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5044FC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF5044FC),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF5044FC),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
