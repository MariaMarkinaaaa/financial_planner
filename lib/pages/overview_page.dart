import 'package:flutter/material.dart';

import '../components/finance_pie_chart_card.dart';
import '../components/summary_card.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SummaryCard(
          income: income,
          expenses: expenses,
          balance: balance,
        ),
        const SizedBox(height: 16),
        FinancePieChartCard(totalIncome: income, totalExpense: expenses),
      ],
    );
  }
}
