// services/models/expense_model.dart
class Expense {
  final String? id;
  final String name;
  final double amount;
  final String status;
  final String date;
  final String? userId;
  final String? createdAt;
  final String? updatedAt;

  Expense({
    this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.date,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'],
      name: json['name'],
      amount: json['amount'].toDouble(),
      status: json['status'],
      date: json['date'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'amount': amount,
      'status': status,
      'date': date,
    };
  }
}
