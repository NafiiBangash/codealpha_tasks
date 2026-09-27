import 'package:flutter/material.dart';
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.style_outlined, size: 72, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No flashcards yet',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Tap "Add Card" to create your first one.',
          style: TextStyle(color: Colors.grey.shade500),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Add Card'),
        ),
      ],
    );
  }
}