enum TransactionType { income, expense }

abstract class FinancialRecord {
  FinancialRecord({
    required String title,
    required double amount,
    required DateTime date,
  }) : _title = title,
       _amount = amount,
       _date = date;

  String _title;
  double _amount;
  DateTime _date;

  String get title => _title;
  set title(String value) => _title = value;

  double get amount => _amount;
  set amount(double value) => _amount = value;

  DateTime get date => _date;
  set date(DateTime value) => _date = value;
}

class FinanceEntry extends FinancialRecord {
  FinanceEntry({
    required super.title,
    required super.amount,
    required TransactionType type,
    required super.date,
  }) : _type = type;

  TransactionType _type = TransactionType.expense;

  TransactionType get type => _type;
  set type(TransactionType value) => _type = value;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'type': type.name,
      'date': date.toIso8601String(),
    };
  }

  factory FinanceEntry.fromJson(Map<String, dynamic> json) {
    return FinanceEntry(
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      date: DateTime.parse(json['date'] as String),
    );
  }
}
