import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'view_models/expense_view_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ExpenseViewModel()..loadExpenses(),
      child: MyApp(),
    ),
  );
}
