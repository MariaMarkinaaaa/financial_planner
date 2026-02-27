import 'package:flutter/material.dart';

import 'pages/budget_home_page.dart';
import 'services/async_finance_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final financeService = AsyncFinanceService(
    storage: SharedPrefsEntryStorage(),
  );
  runApp(BudgetPlannerApp(financeService: financeService));
}

class BudgetPlannerApp extends StatelessWidget {
  const BudgetPlannerApp({super.key, required this.financeService});

  final AsyncFinanceService financeService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Планировщик бюджета',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: BudgetHomePage(financeService: financeService),
    );
  }
}
