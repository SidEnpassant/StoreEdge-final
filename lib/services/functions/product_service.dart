// lib/services/functions/product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeedge/services/models/product_fetching_inventory_model.dart';

import '../settings/api_settings.dart';

class ProductService {
  static const int LOW_STOCK_THRESHOLD = 10;

  static Future<List<ProductFetchingInventoryModel>>
      fetchInventoryProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final response = await http.get(
        Uri.parse('${ApiSettingsInventory.baseUrl}/api/products/search'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          final List<dynamic> productsJson = responseData['data'];
          return productsJson
              .map((json) => ProductFetchingInventoryModel.fromJson(json))
              .toList();
        } else {
          throw Exception(
              'Failed to load products: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  // Update product quantity
  static Future<ProductFetchingInventoryModel> updateProductQuantity(
    String productId,
    int quantity,
  ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        throw Exception('Access token not found');
      }

      final response = await http.put(
        Uri.parse(
            '${ApiSettingsUpdateProducts.baseUrl}/api/products/update/quantity'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'productId': productId,
          'quantity': quantity,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 202) {
        return ProductFetchingInventoryModel.fromJson(responseData['data']);
      } else {
        throw Exception(
            responseData['message'] ?? 'Failed to update product quantity');
      }
    } catch (e) {
      throw Exception('Error updating product quantity: $e');
    }
  }

  static Future<List<ProductFetchingInventoryModel>> searchProducts(
      String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken');

      if (accessToken == null) {
        throw Exception('No access token found');
      }

      final response = await http.get(
        Uri.parse(
            'https://diversionbackend.onrender.com/api/products/search?name=$query'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> productsData = responseData['data'];

        return productsData
            .map((product) => ProductFetchingInventoryModel.fromJson(product))
            .toList();
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      throw Exception('Error searching products: $e');
    }
  }

  static int getLowStockCount(List<ProductFetchingInventoryModel> products) {
    return products.where((product) => product.isLowStock).length;
  }

  static String _handleHttpError(http.Response response) {
    try {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      return errorData['message'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Error occurred: ${response.statusCode}';
    }
  }

  // Helper method to get headers with auth token
  static Future<Map<String, String>> _getAuthHeaders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }
}
