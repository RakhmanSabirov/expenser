import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense_model.dart';
import '../view_models/expense_view_model.dart';
import '../enums/period_type.dart';

class ChartView extends StatelessWidget {
  final PeriodType period;
  final DateTimeRange? filterRange;

  const ChartView({
    super.key,
    required this.period,
    this.filterRange,
  });

  List<Expense> _filterByPeriod(List<Expense> allExpenses, PeriodType period) {
    final now = DateTime.now();
    late final DateTime startDate;

    switch (period) {
      case PeriodType.day:
        startDate = DateTime(now.year, now.month, now.day);
        break;
      case PeriodType.week:
        startDate = now.subtract(Duration(days: 6));
        break;
      case PeriodType.month:
        startDate = now.subtract(Duration(days: 29));
        break;
    }

    return allExpenses.where((expense) {
      return !expense.date.isBefore(startDate) &&
          !expense.date.isAfter(DateTime(now.year, now.month, now.day, 23, 59, 59));
    }).toList();
  }

  String _getPeriodTitle(PeriodType period) {
    switch (period) {
      case PeriodType.day:
        return 'за день';
      case PeriodType.week:
        return 'за неделю';
      case PeriodType.month:
        return 'за месяц';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final allExpenses = Provider.of<ExpenseViewModel>(context).expenses;

    final expenses = filterRange != null
        ? allExpenses.where((e) =>
    e.date.isAfter(filterRange!.start.subtract(Duration(seconds: 1))) &&
        e.date.isBefore(filterRange!.end.add(Duration(days: 1))))
        .toList()
        : _filterByPeriod(allExpenses, period);

    final grouped = <String, double>{};
    for (var e in expenses) {
      grouped[e.category] = (grouped[e.category] ?? 0) + e.amount;
    }

    final total = grouped.values.fold(0.0, (a, b) => a + b);
    final items = grouped.entries.toList();

    final colors = [
      Colors.redAccent,
      Colors.blueAccent,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Диаграмма")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: items.isEmpty
            ? Center(child: Text('Нет данных для отображения'))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              filterRange != null
                  ? 'Диаграмма расходов: ${dateFormat.format(filterRange!.start)} - ${dateFormat.format(filterRange!.end)}'
                  : 'Диаграмма расходов ${_getPeriodTitle(period)}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Theme.of(context).cardColor,
              elevation: 2,
              margin: EdgeInsets.only(bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 10,
                  children: List.generate(items.length, (i) {
                    final entry = items[i];
                    final percent = (entry.value / total * 100).toStringAsFixed(1);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: colors[i % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          '${entry.key}: $percent%',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            Expanded(
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  sections: items.asMap().entries.map((entry) {
                    final i = entry.key;
                    final e = entry.value;
                    return PieChartSectionData(
                      color: colors[i % colors.length],
                      value: e.value,
                      title: '${e.key}\n${e.value.toStringAsFixed(0)}₸',
                      radius: 70,
                      titleStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
