import 'package:flutter/material.dart';

import '../classes/finance_entry.dart';

class InputCard extends StatelessWidget {
  const InputCard({
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Название',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Сумма',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<TransactionType>(
              initialValue: selectedType,
              items: const [
                DropdownMenuItem(
                  value: TransactionType.income,
                  child: Text('Доход'),
                ),
                DropdownMenuItem(
                  value: TransactionType.expense,
                  child: Text('Расход'),
                ),
              ],
              onChanged: onTypeChanged,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onAddPressed,
                icon: const Icon(Icons.add),
                label: const Text('Добавить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
