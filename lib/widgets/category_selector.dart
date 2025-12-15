import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  static const List<IconData> _icons = [
    Icons.grid_view, // All
    Icons.checkroom, // Dresses
    Icons.shopping_bag, // Shirts
    Icons.accessibility_new, // Pants
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _icons.length,
        separatorBuilder: (_, __) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Container(
              width: isSelected ? 80 : 50,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1D1F22) : Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Icon(
                  _icons[index],
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
