import 'package:flutter/material.dart';

import '../classes/finance_entry.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
    required this.entries,
    required this.onRemoveEntry,
  });

  final List<FinanceEntry> entries;
  final ValueChanged<int> onRemoveEntry;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Пока нет данных. Добавьте доход или расход.'),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = entries[index];
        final isIncome = item.type == TransactionType.income;

        return Card(
          child: ListTile(
            title: Text(item.title),
            subtitle: Text('${item.date.day}.${item.date.month}.${item.date.year}'),
            leading: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}${item.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => onRemoveEntry(index),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
