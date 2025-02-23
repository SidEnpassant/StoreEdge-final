import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeedge/services/models/login_response.dart';
import 'package:storeedge/services/settings/api_settings.dart';

class AuthService {
  static const String _tokenKey = 'access_token';
  static const String _userKey = 'user_data';

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiSettings.loginEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
          // Create LoginResponse from the nested structure
          final loginResponse = LoginResponse(
            statusCode: responseData['statusCode'],
            success: responseData['success'],
            message: responseData['message'],
            data: responseData['data'] != null
                ? LoginData(
                    user: UserData.fromJson(responseData['data']['user']),
                    accesstoken: responseData['data']['accesstoken'],
                  )
                : null,
          );

          if (loginResponse.success && loginResponse.data != null) {
            await _saveUserData(loginResponse);
          }
          return loginResponse;

        case 401:
          throw 'Invalid credentials';
        case 404:
          throw 'User not found';
        case 500:
          throw 'Server error. Please try again later';
        default:
          throw 'Something went wrong. Please try again';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> _saveUserData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    // Save token from the nested data structure
    await prefs.setString(_tokenKey, loginResponse.data?.accesstoken ?? '');
    // Save user data
    if (loginResponse.data?.user != null) {
      await prefs.setString(
          _userKey, json.encode(loginResponse.data!.user.toJson()));
    }
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
