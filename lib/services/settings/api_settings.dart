class ApiSettings {
  static const String baseUrl = 'https://diversionbackend.onrender.com/api';
  static const String loginEndpoint = '$baseUrl/users/login';
}

class ApiSettingsInventory {
  static const String baseUrl = 'https://diversionbackend.onrender.com';
}

// lib/services/settings/api_settings.dart

class ApiSettingsUpdateProducts {
  static const String baseUrl = 'https://diversionbackend.onrender.com';

  // You can add other API-related constants here
  static const int requestTimeout = 30; // seconds
  static const int maxRetries = 3;
}
