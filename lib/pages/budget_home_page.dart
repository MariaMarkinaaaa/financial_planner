import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../classes/finance_entry.dart';
import '../services/async_finance_service.dart';
import 'add_entry_page.dart';
import 'history_page.dart';
import 'overview_page.dart';

class BudgetHomePage extends StatefulWidget {
  const BudgetHomePage({super.key, required this.financeService});

  final AsyncFinanceService financeService;

  @override
  State<BudgetHomePage> createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  TransactionType _selectedType = TransactionType.expense;
  List<FinanceEntry> _entries = [];

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _loadEntries();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _initNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _notificationsPlugin.initialize(settings);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> _loadEntries() async {
    final loaded = await widget.financeService.loadHistory();
    setState(() {
      _entries = loaded;
    });
    _showMessage('Асинхронная загрузка завершена. Записей: ${loaded.length}');
  }

  double get _totalIncome => _entries
      .where((entry) => entry.type == TransactionType.income)
      .fold(0, (sum, entry) => sum + entry.amount);

  double get _totalExpense => _entries
      .where((entry) => entry.type == TransactionType.expense)
      .fold(0, (sum, entry) => sum + entry.amount);

  double get _balance => _totalIncome - _totalExpense;

  Future<void> _showOverBudgetNotification() async {
    const android = AndroidNotificationDetails(
      'budget_alerts',
      'Budget Alerts',
      channelDescription: 'Уведомления о превышении бюджета',
      importance: Importance.max,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);

    await _notificationsPlugin.show(
      0,
      'Бюджет превышен',
      'Расходы превысили доходы. Проверьте траты.',
      details,
    );
  }

  Future<void> _addEntry() async {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));

    if (title.isEmpty || amount == null || amount <= 0) {
      _showMessage('Введите корректные название и сумму.');
      return;
    }

    final entry = FinanceEntry(
      title: title,
      amount: amount,
      type: _selectedType,
      date: DateTime.now(),
    );

    final updated = await widget.financeService.addEntry(
      current: _entries,
      newEntry: entry,
    );

    setState(() {
      _entries = updated;
      _titleController.clear();
      _amountController.clear();
    });

    _showMessage('Операция добавлена и сохранена асинхронно.');

    if (_balance < 0) {
      await _showOverBudgetNotification();
    }
  }

  Future<void> _removeEntry(int index) async {
    final updated = await widget.financeService.removeEntry(
      current: _entries,
      index: index,
    );

    setState(() {
      _entries = updated;
    });
    _showMessage('Операция удалена и изменения сохранены.');
  }

  void _showMessage(String text) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Планировщик бюджета'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.pie_chart_outline), text: 'Обзор'),
              Tab(icon: Icon(Icons.add_circle_outline), text: 'Добавить'),
              Tab(icon: Icon(Icons.history), text: 'История'),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              OverviewPage(
                income: _totalIncome,
                expenses: _totalExpense,
                balance: _balance,
              ),
              AddEntryPage(
                titleController: _titleController,
                amountController: _amountController,
                selectedType: _selectedType,
                onTypeChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedType = value;
                  });
                },
                onAddPressed: _addEntry,
              ),
              HistoryPage(entries: _entries, onRemoveEntry: _removeEntry),
            ],
          ),
        ),
      ),
    );
  }
}
