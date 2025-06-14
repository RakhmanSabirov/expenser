import 'package:flutter/material.dart';

class ExpenseDropdown extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onChanged;

  const ExpenseDropdown({super.key, 
    required this.categories,
    required this.selected,
    required this.onChanged,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Еда':
        return Icons.fastfood;
      case 'Транспорт':
        return Icons.directions_car;
      case 'Развлечения':
        return Icons.movie;
      case 'Прочее':
        return Icons.category;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selected,
      items: categories
          .map(
            (cat) => DropdownMenuItem(
              value: cat,
              child: Row(
                children: [
                  Icon(
                    _getCategoryIcon(cat),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 8),
                  Text(cat),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (val) => onChanged(val!),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
