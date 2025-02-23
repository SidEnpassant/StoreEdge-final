// services/models/expense_model.dart
class ExpenseFetchModel {
  final String id;
  final String name;
  final double amount;
  final String status;
  final String date;
  final String userId;
  final String createdAt;
  final String updatedAt;

  ExpenseFetchModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.status,
    required this.date,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseFetchModel.fromJson(Map<String, dynamic> json) {
    return ExpenseFetchModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      date: json['date'] ?? '',
      userId: json['userId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
