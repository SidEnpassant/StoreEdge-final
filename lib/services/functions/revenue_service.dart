// services/functions/revenue_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RevenueService {
  static const String baseUrl = 'https://diversionbackend.onrender.com/api';

  Future<Map<String, dynamic>> getRevenueAndExpense() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/sales/rev&exp'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          return {
            'expense': jsonResponse['data']['expense'] ?? 0,
            'revenue': jsonResponse['data']['revenue'] ?? 0,
          };
        } else {
          throw Exception('Invalid data format received');
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching revenue and expense: $e');
    }
  }
}
