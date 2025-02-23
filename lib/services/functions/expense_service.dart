// services/functions/expense_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense_model.dart';
import '../settings/token_storage.dart';

class ExpenseService {
  static const String baseUrl = 'https://diversionbackend.onrender.com/api';

  // Add a new expense
  static Future<Map<String, dynamic>> addExpense(Expense expense) async {
    try {
      final token = await TokenStorage.getToken();

      if (token == null) {
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/expenses/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': expense.name,
          'amount': expense.amount,
          'status': expense.status,
          'date': expense.date,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        return {
          'success': true,
          'data': responseData['data'],
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to add expense',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }
}
