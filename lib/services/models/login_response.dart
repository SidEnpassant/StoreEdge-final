// lib/services/models/login_response.dart
class LoginResponse {
  final int statusCode;
  final bool success;
  final String message;
  final LoginData? data;

  LoginResponse({
    required this.statusCode,
    required this.success,
    required this.message,
    this.data,
  });
}

class LoginData {
  final UserData user;
  final String accesstoken;

  LoginData({
    required this.user,
    required this.accesstoken,
  });
}

class UserData {
  final String id;
  final String name;
  final int phone;
  final String email;
  final String businessName;
  final String businessAddress;
  final String gst;
  final String signature;
  final String signatureId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.businessName,
    required this.businessAddress,
    required this.gst,
    required this.signature,
    required this.signatureId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] is int
          ? json['phone']
          : int.tryParse(json['phone'].toString()) ?? 0,
      email: json['email'] ?? '',
      businessName: json['business_name'] ?? '',
      businessAddress: json['business_address'] ?? '',
      gst: json['gst'] ?? '',
      signature: json['signature'] ?? '',
      signatureId: json['signature_id'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'business_name': businessName,
      'business_address': businessAddress,
      'gst': gst,
      'signature': signature,
      'signature_id': signatureId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
