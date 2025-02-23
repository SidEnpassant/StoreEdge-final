// services/functions/expense_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense_fetch_model.dart';
import '../settings/token_storage.dart';

class ExpenseFetchService {
  static const String baseUrl = 'https://diversionbackend.onrender.com/api';

  static Future<Map<String, dynamic>> changeExpenseStatus(
      String expenseId, String status) async {
    try {
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/expenses/change-status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'expenseId': expenseId,
          'status': status,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 202 && responseData['success'] == true) {
        return {
          'success': true,
          'data': responseData['data'],
          'message': responseData['message'],
        };
      } else {
        throw Exception(
            'Failed to update expense status: ${responseData['message']}');
      }
    } catch (e) {
      throw Exception('Error updating expense status: $e');
    }
  }

  static Future<List<ExpenseFetchModel>> getExpenses() async {
    try {
      // Get the authentication token
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Make API request with authentication
      final response = await http.get(
        Uri.parse('$baseUrl/expenses'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Check if request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> expensesJson = data['data'];
          return expensesJson
              .map((json) => ExpenseFetchModel.fromJson(json))
              .toList();
        } else {
          throw Exception('Failed to parse expenses: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load expenses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching expenses: $e');
    }
  }

  static Future<List<ExpenseFetchModel>> getCompletedExpenses() async {
    final allExpenses = await getExpenses();
    return allExpenses
        .where((expense) => expense.status == 'Completed')
        .toList();
  }

  static Future<List<ExpenseFetchModel>> getIncompleteExpenses() async {
    final allExpenses = await getExpenses();
    return allExpenses
        .where((expense) => expense.status == 'Incomplete')
        .toList();
  }
}
