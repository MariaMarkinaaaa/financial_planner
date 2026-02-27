import 'package:flutter/material.dart';

import '../classes/finance_entry.dart';
import '../components/input_card.dart';

class AddEntryPage extends StatelessWidget {
  const AddEntryPage({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.selectedType,
    required this.onTypeChanged,
    required this.onAddPressed,
  });

  final TextEditingController titleController;
  final TextEditingController amountController;
  final TransactionType selectedType;
  final ValueChanged<TransactionType?> onTypeChanged;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Добавление операции',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        InputCard(
          titleController: titleController,
          amountController: amountController,
          selectedType: selectedType,
          onTypeChanged: onTypeChanged,
          onAddPressed: onAddPressed,
        ),
      ],
    );
  }
}
