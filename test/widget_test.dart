import 'package:flutter_test/flutter_test.dart';
import 'package:kubsau_flutter/main.dart';
import 'package:kubsau_flutter/services/async_finance_service.dart';

void main() {
  testWidgets('Budget app smoke test', (tester) async {
    await tester.pumpWidget(
      BudgetPlannerApp(financeService: AsyncFinanceService(storage: SharedPrefsEntryStorage())),
    );

    expect(find.text('Планировщик бюджета'), findsOneWidget);
    expect(find.text('Итоги'), findsOneWidget);
  });
}
