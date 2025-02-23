// lib/services/functions/product_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:storeedge/services/models/product_add_model.dart';

import 'package:storeedge/services/settings/api_config.dart';
import 'package:storeedge/services/settings/token_storage.dart';

class ProductAddService {
  Future<ProductAddModel> addProduct({
    required String name,
    required double price,
    required int quantity,
    required String unitType,
    String? imagePath,
  }) async {
    try {
      final String? token = await TokenStorage.getToken();

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '${ApiConfigAddProductInventory.baseUrl}/api/products/create'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add text fields
      request.fields['name'] = name;
      request.fields['price'] = price.toString();
      request.fields['quantity'] = quantity.toString();
      request.fields['unitType'] = unitType;

      // Add image if provided
      if (imagePath != null) {
        final file = File(imagePath);
        final filename = basename(file.path);
        final mimeType = _getMimeType(filename);

        request.files.add(
          http.MultipartFile(
            'image',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: filename,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseBody);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        return ProductAddModel.fromJson(jsonResponse['data']);
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  String _getMimeType(String filename) {
    final ext = extension(filename).toLowerCase();
    switch (ext) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}
