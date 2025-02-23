// widgets/total_expenses_card.dart
import 'package:flutter/material.dart';
import 'package:storeedge/services/functions/budget_service.dart';
import 'package:storeedge/services/models/budget_model.dart';

class TotalExpensesCard extends StatefulWidget {
  const TotalExpensesCard({Key? key}) : super(key: key);

  @override
  State<TotalExpensesCard> createState() => _TotalExpensesCardState();
}

class _TotalExpensesCardState extends State<TotalExpensesCard> {
  bool _isLoading = true;
  String? _error;
  BudgetData? _budgetData;

  @override
  void initState() {
    super.initState();
    _fetchBudgetData();
  }

  Future<void> _fetchBudgetData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final data = await BudgetService.getBudgetData();
      setState(() {
        _budgetData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Get border color based on remaining percentage
  Color _getBorderColor(double percentage) {
    if (percentage >= 70) {
      return const Color(0xFF00AA00); // Deep green
    } else if (percentage >= 50) {
      return const Color(0xFFB6EF86); // Light green
    } else if (percentage >= 25) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFFF0000); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF5044FC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Failed to load budget data',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchBudgetData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Calculate the remaining percentage
    final remainingPercentage = _budgetData?.getRemainingPercentage() ?? 0;
    final formattedPercentage = remainingPercentage.toStringAsFixed(0);
    final borderColor = _getBorderColor(remainingPercentage);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF5044FC),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Expenses',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _budgetData?.getFormattedExpense() ?? 'Rs 0.00',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Budget: ${_budgetData?.getFormattedRevenue() ?? 'Rs 0.00'}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              border: Border.all(
                color: borderColor,
                width: 4,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Center(
              child: Text(
                '$formattedPercentage%',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
