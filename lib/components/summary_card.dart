import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.income,
    required this.expenses,
    required this.balance,
  });

  final double income;
  final double expenses;
  final double balance;

  @override
  Widget build(BuildContext context) {
    final bankrot = balance < 0;
    final balanceColor = balance < 0 ? Colors.red : Colors.teal;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Итоги', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Доходы: ${income.toStringAsFixed(2)} ₽'),
            Text('Расходы: ${expenses.toStringAsFixed(2)} ₽'),
            const Divider(height: 24),
            Text(
              bankrot?'У тебя больше нет дома! Твой дом мы продаём за долги и срыв проекта. Контракт надо было внимательно читать!!!':'Остаток: ${balance.toStringAsFixed(2)} ₽',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: balanceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
