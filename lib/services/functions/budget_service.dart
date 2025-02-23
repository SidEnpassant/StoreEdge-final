// services/functions/budget_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/budget_model.dart';
import '../settings/token_storage.dart';

class BudgetService {
  static const String baseUrl = 'https://diversionbackend.onrender.com/api';

  static Future<BudgetData> getBudgetData() async {
    try {
      // Get the authentication token
      final token = await TokenStorage.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      // Make API request with authentication
      final response = await http.get(
        Uri.parse('$baseUrl/sales/rev&exp'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Check if request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true && responseData['data'] != null) {
          final Map<String, dynamic> data = responseData['data'];
          return BudgetData.fromJson(data);
        } else {
          throw Exception(
              'Failed to parse budget data: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load budget data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching budget data: $e');
    }
  }
}
