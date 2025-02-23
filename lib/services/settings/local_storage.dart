import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeedge/services/models/user_model.dart';

// Save user to SharedPreferences
Future<void> saveUser(User user) async {
  final prefs = await SharedPreferences.getInstance();
  final userJson = jsonEncode(user.toJson());
  await prefs.setString('user', userJson);
}

// Retrieve user from SharedPreferences
Future<User?> getUser() async {
  final prefs = await SharedPreferences.getInstance();
  final userJson = prefs.getString('user');

  if (userJson == null) return null;

  return User.fromJson(jsonDecode(userJson));
}

// Remove user from SharedPreferences (for logout)
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
}
