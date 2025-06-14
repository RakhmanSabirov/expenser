import 'package:flutter/material.dart';

class TotalTile extends StatelessWidget {
  final String label;
  final double amount;
  final VoidCallback? onTap;

  const TotalTile({
    required this.label,
    required this.amount,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded( // добавь это в Row
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withAlpha(100),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 4),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    '${amount.toStringAsFixed(2)}₸',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
