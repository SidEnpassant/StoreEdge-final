// widgets/tab_section.dart
import 'package:flutter/material.dart';
import 'package:storeedge/services/functions/expense_fetch_service.dart';
import 'package:storeedge/services/models/expense_fetch_model.dart';
import 'package:storeedge/widgets/others/used-in-expenses/completed_expense_item.dart';
import 'package:storeedge/widgets/others/used-in-expenses/incomplete_expenses.dart';

class TabSection extends StatefulWidget {
  const TabSection({Key? key}) : super(key: key);

  @override
  _TabSectionState createState() => _TabSectionState();
}

class _TabSectionState extends State<TabSection> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  List<ExpenseFetchModel> _completedExpenses = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchCompletedExpenses();
  }

  Future<void> _fetchCompletedExpenses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final expenses = await ExpenseFetchService.getCompletedExpenses();
      setState(() {
        _completedExpenses = expenses.cast<ExpenseFetchModel>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.width > 640 ? 74 : 64,
            decoration: BoxDecoration(
              color: const Color(0xFFB6EF86),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildTab('Completed', 0),
                const VerticalDivider(
                  indent: 1,
                  color: Color(0xFFB6B6B6),
                  width: 1,
                  thickness: 1,
                ),
                _buildTab('Incomplete', 1),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedIndex == 0
                ? _buildCompletedExpensesView()
                : const IncompleteExpenseCards(),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedExpensesView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_error',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchCompletedExpenses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchCompletedExpenses,
      child: CompletedExpensesList(expenses: _completedExpenses),
    );
  }

  Widget _buildTab(String title, int index) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });

          // Fetch appropriate data based on selected tab
          if (index == 0) {
            _fetchCompletedExpenses();
          }
        },
        child: Container(
          margin: const EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: isSelected
                ? Border.all(
                    color: const Color(0xFF5044FC),
                    width: 2,
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? const Color(0xFF5044FC) : Colors.black54,
              fontSize: MediaQuery.of(context).size.width > 640 ? 24 : 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}
