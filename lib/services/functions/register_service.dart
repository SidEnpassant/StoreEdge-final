// lib/services/functions/register_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class RegisterResponse {
  final int statusCode;
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  RegisterResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      data: json['data'],
    );
  }
}

class RegisterService {
  static const String registerEndpoint =
      'https://diversionbackend.onrender.com/api/users/register';

  Future<RegisterResponse> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String businessName,
    required String businessAddress,
    required String gst,
    File? signatureImage,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(registerEndpoint));

      // Add text fields
      request.fields.addAll({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'business_name': businessName,
        'business_address': businessAddress,
        'gst': gst,
      });

      // Add signature image if provided
      if (signatureImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          signatureImage.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final responseData = json.decode(response.body);

      if (response.statusCode != 201) {
        throw Exception(responseData['message'] ?? 'Registration failed');
      }

      return RegisterResponse.fromJson(responseData);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
}
