import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rashodnik/widgets/total_tile.dart';
import '../view_models/expense_view_model.dart';
import '../enums/period_type.dart';
import 'chart_view.dart';
import 'new_expense_view.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  const HomeView({super.key, this.onToggleTheme});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  DateTimeRange? _filterRange;

  void _openChartView(PeriodType period, {DateTimeRange? range}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChartView(
          period: period,
          filterRange: range,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final viewModel = Provider.of<ExpenseViewModel>(context);
    final filteredExpenses = _filterRange == null
        ? viewModel.expenses
        : viewModel.getFilteredExpenses(_filterRange!);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Расходы',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(icon: Icon(Icons.filter_alt), onPressed: _pickDateRange),
          if (_filterRange != null)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () => setState(() => _filterRange = null),
            ),
        ],
      ),
      body: viewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TotalTile(
                  label: 'День',
                  amount: viewModel.totalToday,
                  onTap: () => _openChartView(PeriodType.day),
                ),
                TotalTile(
                  label: 'Неделя',
                  amount: viewModel.totalWeek,
                  onTap: () => _openChartView(PeriodType.week),
                ),
                TotalTile(
                  label: 'Месяц',
                  amount: viewModel.totalMonth,
                  onTap: () => _openChartView(PeriodType.month),
                ),
              ],
            ),
          ),
          if (_filterRange != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: [
                  Text(
                    'Период: ${dateFormat.format(_filterRange!.start)} - ${dateFormat.format(_filterRange!.end)}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _openChartView(
                        PeriodType.day,
                        range: _filterRange,
                      ),
                      icon: Icon(Icons.pie_chart),
                      label: Text(
                        'Диаграмма за период',
                        style: TextStyle(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: filteredExpenses.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wallet_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Нет расходов',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NewExpenseView(),
                      ),
                    ),
                    child: Text('Добавить расход'),
                  ),
                ],
              ),
            )
                : Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: ListView.separated(
                itemCount: filteredExpenses.length,
                separatorBuilder: (_, __) => SizedBox(height: 4),
                itemBuilder: (context, index) {
                  final e = filteredExpenses[index];
                  return TweenAnimationBuilder<Offset>(
                    duration: Duration(
                      milliseconds: 300 + index * 50,
                    ),
                    tween: Tween<Offset>(
                      begin: Offset(1, 0),
                      end: Offset.zero,
                    ),
                    builder: (context, offset, child) {
                      return Transform.translate(
                        offset: offset * 20,
                        child: child!,
                      );
                    },
                    child: Dismissible(
                      key: Key(e.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        final deletedExpense = e;
                        viewModel.expenses.removeAt(index);
                        setState(() {});
                        final controller = AnimationController(
                          vsync: this,
                          duration: const Duration(seconds: 3),
                        )..forward();

                        bool isUndone = false;

                        ScaffoldMessenger.of(context)
                            .clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.red.shade400,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.delete_forever,
                                        color: Colors.white),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Расход удалён',
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                LinearProgressIndicator(
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  backgroundColor:
                                  Colors.red.shade300,
                                  value: null,
                                ),
                              ],
                            ),
                            action: SnackBarAction(
                              label: 'Отменить',
                              textColor: Colors.white,
                              onPressed: () {
                                isUndone = true;
                                viewModel.expenses.insert(
                                    index, deletedExpense);
                                setState(() {});
                              },
                            ),
                          ),
                        );

                        Future.delayed(Duration(seconds: 3), () {
                          if (!isUndone) {
                            viewModel.deleteExpense(
                                deletedExpense.id!);
                          }
                          controller.dispose();
                        });
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(
                              e.category,
                            ).withAlpha(50),
                            child: Icon(
                              Icons.label,
                              color: _getCategoryColor(e.category),
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            '${e.category}: ${e.amount.toStringAsFixed(2)}₸',
                            style: TextStyle(
                              color: _getCategoryColor(e.category),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${e.date.toLocal().toString().split(" ")[0]} — ${e.comment ?? "Без комментария"}',
                          ),
                          trailing: Icon(
                            Icons.swipe_left,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewExpenseView()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _filterRange = picked);
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Еда':
        return Colors.orange;
      case 'Транспорт':
        return Colors.blue;
      case 'Развлечения':
        return Colors.purple;
      case 'Прочее':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}