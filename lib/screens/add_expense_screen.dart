import 'package:flutter/material.dart';
import 'package:storeedge/utils/theme/app_colors.dart';
import 'package:storeedge/widgets/others/used-in-add-expense/custom_text_field_add_expense.dart';
import '../utils/theme/app_theme.dart';
import '../services/models/expense_model.dart';
import '../services/functions/expense_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _selectedStatus = 'Completed';
  String _selectedDate = '21/02/2025';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _amountController.text = '';
    // Set today's date as default
    final now = DateTime.now();
    _selectedDate =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
  }

  // Validate form inputs
  bool _validateInputs() {
    if (_nameController.text.isEmpty) {
      _showSnackBar('Please enter expense name');
      return false;
    }

    if (_amountController.text.isEmpty) {
      _showSnackBar('Please enter amount');
      return false;
    }

    try {
      double.parse(_amountController.text);
    } catch (e) {
      _showSnackBar('Please enter a valid amount');
      return false;
    }

    return true;
  }

  // Show snackbar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Handle add expense
  Future<void> _addExpense() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Create expense object
      final expense = Expense(
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        status: _selectedStatus,
        date: _selectedDate,
      );

      // Call the API service
      final result = await ExpenseService.addExpense(expense);

      if (result['success']) {
        _showSnackBar('Expense added successfully');
        // Clear the form
        _nameController.clear();
        _amountController.clear();
        // Navigate back or reset state
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        _showSnackBar(result['message']);
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 27,
                    height: 28,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.black,
                      size: 24,
                    ),
                  ),
                ),

                // Title
                const SizedBox(height: 50),
                const Text(
                  'Add expense',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 55),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(31),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Name Input
                      CustomTextFieldAddExpense(
                        label: 'Name',
                        hint: 'Expense name here',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 24),

                      // Status Dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: AppTheme.inputHeight,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.inputBorder),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.borderRadius),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedStatus,
                                isExpanded: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                items: ['Completed', 'Incomplete']
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() => _selectedStatus = newValue);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Amount Input
                      CustomTextFieldAddExpense(
                        label: 'Amount',
                        hint: '0.00',
                        controller: _amountController,
                        prefix: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '\Rs',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Date Input
                      CustomTextFieldAddExpense(
                        label: 'Date',
                        hint: 'Select date',
                        controller: TextEditingController(text: _selectedDate),
                        readOnly: true,
                        suffix: const Icon(Icons.keyboard_arrow_down),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              _selectedDate =
                                  '${picked.day.toString().padLeft(2, '0')}/'
                                  '${picked.month.toString().padLeft(2, '0')}/'
                                  '${picked.year}';
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 25),

                      // Add Product Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _addExpense,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppTheme.borderRadius),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text(
                                  'Add Expense',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 33),
                  child: Center(
                    child: Text(
                      'Or',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),

                // Scan Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            // Handle scan functionality
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadius),
                      ),
                    ),
                    child: const Text(
                      'Scan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }
}
