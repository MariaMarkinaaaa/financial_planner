import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class FinancePieChartCard extends StatelessWidget {
  const FinancePieChartCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  final double totalIncome;
  final double totalExpense;

  @override
  Widget build(BuildContext context) {
    final chartSections = [
      PieChartSectionData(
        value: totalIncome == 0 ? 1 : totalIncome,
        title: 'Доходы\n${totalIncome.toStringAsFixed(0)}',
        color: Colors.green,
        radius: 90,
      ),
      PieChartSectionData(
        value: totalExpense == 0 ? 1 : totalExpense,
        title: 'Расходы\n${totalExpense.toStringAsFixed(0)}',
        color: Colors.redAccent,
        radius: 90,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'График доходов и расходов',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 4,
                  centerSpaceRadius: 22,
                  sections: chartSections,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
