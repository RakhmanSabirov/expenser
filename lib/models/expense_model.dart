class Expense {
  final int? id;
  final double amount;
  final String category;
  final DateTime date;
  final String? comment;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.date,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'comment': comment,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
      comment: map['comment'],
    );
  }
}
