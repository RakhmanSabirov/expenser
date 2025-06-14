import 'package:flutter/material.dart';
import '../models/expense_model.dart';
import '../services/expense_db_service.dart';

class ExpenseViewModel extends ChangeNotifier {
  final ExpenseDbService _dbService = ExpenseDbService();
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  double get totalToday => _calculateTotal(forDays: 1);
  double get totalWeek => _calculateTotal(forDays: 7);
  double get totalMonth => _calculateTotal(forDays: 30);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _expenses = await _dbService.getExpenses();
    } catch (e) {
      debugPrint('Ошибка загрузки: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _dbService.insertExpense(expense);
      await loadExpenses();
    } catch (e) {
      debugPrint('Ошибка при добавлении расхода: $e');
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await _dbService.deleteExpense(id);
      await loadExpenses();
    } catch (e) {
      debugPrint('Ошибка при удалении расхода: $e');
    }
  }

  double _calculateTotal({required int forDays}) {
    final cutoff = DateTime.now().subtract(Duration(days: forDays));
    return _expenses
        .where((e) => e.date.isAfter(cutoff))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  List<Expense> getFilteredExpenses(DateTimeRange range) {
    return _expenses.where((e) {
      return e.date.isAfter(range.start.subtract(Duration(days: 1))) &&
          e.date.isBefore(range.end.add(Duration(days: 1)));
    }).toList();
  }
}
