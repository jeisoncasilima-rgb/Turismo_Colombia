import 'package:flutter/material.dart';
import 'package:guia_turistica/core/constants/app_constants.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector(
      {super.key,
      required this.selectedCategory,
      required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.categories.length,
        itemBuilder: (ctx, i) {
          String cat = AppConstants.categories[i];
          return GestureDetector(
            onTap: () => onCategorySelected(cat),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    selectedCategory == cat ? Colors.green : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(AppConstants.categoryIcons[cat]!),
                  const SizedBox(width: 8),
                  Text(cat.toUpperCase(),
                      style: TextStyle(
                          color: selectedCategory == cat
                              ? Colors.white
                              : Colors.black)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
