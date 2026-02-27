import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/finance_entry.dart';

abstract interface class EntryStorage {
  Future<List<FinanceEntry>> loadEntries();
  Future<void> saveEntries(List<FinanceEntry> entries);
}

class AppLogger {
  AppLogger._internal();

  static final AppLogger _instance = AppLogger._internal();

  factory AppLogger() => _instance;

  void technical(String message) {
    debugPrint('[TECH] $message');
  }
}

class SharedPrefsEntryStorage implements EntryStorage {
  SharedPrefsEntryStorage({this.storageKey = 'budget_entries'});

  final String storageKey;
  final AppLogger _logger = AppLogger();

  @override
  Future<List<FinanceEntry>> loadEntries() async {
    _logger.technical('Запущена асинхронная загрузка операций');
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);

    if (raw == null) {
      _logger.technical('Хранилище пустое, возвращаем пустой список');
      return [];
    }

    final decoded = jsonDecode(raw) as List<dynamic>;
    final entries = decoded
        .map((item) => FinanceEntry.fromJson(item as Map<String, dynamic>))
        .toList();

    _logger.technical('Загрузка завершена. Записей: ${entries.length}');
    return entries;
  }

  @override
  Future<void> saveEntries(List<FinanceEntry> entries) async {
    _logger.technical('Запущено асинхронное сохранение операций');
    final prefs = await SharedPreferences.getInstance();
    final payload = entries.map((e) => e.toJson()).toList();
    await prefs.setString(storageKey, jsonEncode(payload));
    _logger.technical('Сохранение завершено успешно.');
  }
}

class AsyncFinanceService {
  AsyncFinanceService({required EntryStorage storage}) : _storage = storage;

  final EntryStorage _storage;

  Future<List<FinanceEntry>> loadHistory() => _storage.loadEntries();

  Future<List<FinanceEntry>> addEntry({
    required List<FinanceEntry> current,
    required FinanceEntry newEntry,
  }) async {
    final updated = [...current, newEntry];
    await _storage.saveEntries(updated);
    return updated;
  }

  Future<List<FinanceEntry>> removeEntry({
    required List<FinanceEntry> current,
    required int index,
  }) async {
    final updated = [...current]..removeAt(index);
    await _storage.saveEntries(updated);
    return updated;
  }
}
