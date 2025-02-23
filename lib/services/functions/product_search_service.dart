import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_fetch_add_in_bill.dart';
import '../settings/api_settings.dart';

class ProductSearchService {
  static Future<List<ProductFetchAddInBillModel>> searchProducts(
      String query) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      final response = await http.get(
        Uri.parse('${ApiSettings.baseUrl}/api/products/search?name=$query'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          return (responseData['data'] as List)
              .map((product) => ProductFetchAddInBillModel.fromJson(product))
              .toList();
        }
        return [];
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }
}
