import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense_model.dart';
import '../view_models/expense_view_model.dart';
import '../widgets/expense_text_field.dart';
import '../widgets/expense_dropdown.dart';
import '../widgets/expense_date_picker.dart';

class NewExpenseView extends StatefulWidget {
  const NewExpenseView({super.key});

  @override
  _NewExpenseViewState createState() => _NewExpenseViewState();
}

class _NewExpenseViewState extends State<NewExpenseView> {
  final _formKey = GlobalKey<FormState>();
  double? _amount;
  String _category = 'Еда';
  DateTime _date = DateTime.now();
  String? _comment;

  final List<String> _categories = [
    'Еда',
    'Транспорт',
    'Развлечения',
    'Прочее',
  ];

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ExpenseViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Новая трата')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  ExpenseTextField(
                    hint: 'Сумма',
                    inputType: TextInputType.number,
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Введите сумму' : null,
                    onSaved: (val) => _amount = double.tryParse(val!),
                  ),
                  SizedBox(height: 16),
                  ExpenseDropdown(
                    categories: _categories,
                    selected: _category,
                    onChanged: (val) => setState(() => _category = val),
                  ),
                  SizedBox(height: 16),
                  ExpenseDatePicker(
                    date: _date,
                    onDatePicked: (picked) => setState(() => _date = picked),
                  ),
                  SizedBox(height: 16),
                  ExpenseTextField(
                    hint: 'Комментарий',
                    inputType: TextInputType.text,
                    onSaved: (val) => _comment = val,
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    viewModel.addExpense(
                      Expense(
                        amount: _amount!,
                        category: _category,
                        date: _date,
                        comment: _comment,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: SizedBox(
                  width: double.infinity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: Text(
                          "Сохранить",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
