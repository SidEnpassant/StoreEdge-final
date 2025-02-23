// services/models/budget_model.dart
class BudgetData {
  final double expense;
  final double revenue;

  BudgetData({
    required this.expense,
    required this.revenue,
  });

  factory BudgetData.fromJson(Map<String, dynamic> json) {
    return BudgetData(
      expense: (json['expense'] ?? 0).toDouble(),
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }

  // Calculate what percentage of revenue remains after expenses
  double getRemainingPercentage() {
    if (revenue <= 0) return 0;
    double spent = expense / revenue;
    double remaining = 1 - spent;
    // Ensure we don't return negative values
    return remaining > 0 ? remaining * 100 : 0;
  }

  // Get formatted currency string
  String getFormattedExpense() {
    return 'Rs ${expense.toStringAsFixed(2)}';
  }

  String getFormattedRevenue() {
    return 'Rs ${revenue.toStringAsFixed(2)}';
  }
}
