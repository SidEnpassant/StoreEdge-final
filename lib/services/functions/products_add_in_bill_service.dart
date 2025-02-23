import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeedge/services/models/product_fetch_add_in_bill.dart';

class ProductFetchInAddingToBillScreen {
  static const String baseUrl = 'https://diversionbackend.onrender.com/api';

  static Future<List<ProductFetchAddInBillModel>> getProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/products/search'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> productsJson = data['data'];
        return productsJson
            .map((json) => ProductFetchAddInBillModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
