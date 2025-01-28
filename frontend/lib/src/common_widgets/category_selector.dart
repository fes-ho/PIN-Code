import 'package:flutter/material.dart';
import 'package:frontend/src/features/habits/domain/category.dart';

class CategorySelector extends StatelessWidget {
  final Category selectedCategory;
  final Function(Category) onCategoryChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            CategoryButton(
              icon: Icons.bed,
              label: "Sleep and relaxation",
              color: Colors.purple.shade100,
              isSelected: selectedCategory == Category.sleep,
              onTap: () => onCategoryChanged(Category.sleep),
            ),
            CategoryButton(
              icon: Icons.book,
              label: "Work and learning",
              color: Colors.orange.shade100,
              isSelected: selectedCategory == Category.work,
              onTap: () => onCategoryChanged(Category.work),
            ),
            CategoryButton(
              icon: Icons.water_drop,
              label: "Hydration",
              color: Colors.cyan.shade100,
              isSelected: selectedCategory == Category.hydration,
              onTap: () => onCategoryChanged(Category.hydration),
            ),
            CategoryButton(
              icon: Icons.fitness_center,
              label: "Exercise and hobbies",
              color: Colors.yellow.shade100,
              isSelected: selectedCategory == Category.exercise,
              onTap: () => onCategoryChanged(Category.exercise),
            ),
            CategoryButton(
              icon: Icons.restaurant,
              label: "Food and meals",
              color: Colors.green.shade100,
              isSelected: selectedCategory == Category.food,
              onTap: () => onCategoryChanged(Category.food),
            ),
        ],
      )
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
          border: isSelected
              ? Border.all(color: Colors.black, width: 2.0)
              : Border.all(color: Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.black, size: 24),
          ],
        ),
      ),
    );
  }
}