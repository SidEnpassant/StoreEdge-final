// widgets/others/used-in-expenses/incomplete_expenses.dart
import 'package:flutter/material.dart';
import '../../../services/models/expense_fetch_model.dart';
import '../../../services/functions/expense_fetch_service.dart';

class IncompleteExpenseCards extends StatefulWidget {
  const IncompleteExpenseCards({Key? key}) : super(key: key);

  @override
  State<IncompleteExpenseCards> createState() => _IncompleteExpenseCardsState();
}

class _IncompleteExpenseCardsState extends State<IncompleteExpenseCards> {
  List<ExpenseFetchModel> expenses = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      final fetchedExpenses = await ExpenseFetchService.getIncompleteExpenses();
      setState(() {
        expenses = fetchedExpenses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _handleExpenseCompletion(ExpenseFetchModel expense) async {
    try {
      await ExpenseFetchService.changeExpenseStatus(expense.id, "Completed");
      // Refresh the list after successful status change
      _loadExpenses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to complete expense: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadExpenses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (expenses.isEmpty) {
      return const Center(
        child: Text(
          'No incomplete expenses found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadExpenses,
      child: RentPaymentList(
        expenses: expenses,
        onPaymentCompleted: _handleExpenseCompletion,
      ),
    );
  }
}

class RentPaymentList extends StatelessWidget {
  final List<ExpenseFetchModel> expenses;
  final Function(ExpenseFetchModel) onPaymentCompleted;

  const RentPaymentList({
    Key? key,
    required this.expenses,
    required this.onPaymentCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(2.0),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: _ExpensePaymentCard(
            expense: expense,
            onComplete: () => onPaymentCompleted(expense),
          ),
        );
      },
    );
  }
}

class _ExpensePaymentCard extends StatelessWidget {
  final ExpenseFetchModel expense;
  final VoidCallback onComplete;

  const _ExpensePaymentCard({
    Key? key,
    required this.expense,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        onComplete();
        return false;
      },
      background: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(
          Icons.check_circle,
          color: Colors.white,
          size: 30,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF5044FC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    expense.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Rs ${expense.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Due date - ${expense.date}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFB6EF86),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.arrow_forward,
                      color: Color.fromARGB(255, 0, 0, 0),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Swipe to complete',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
