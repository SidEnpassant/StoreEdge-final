// import 'dart:convert';

// class User {
//   final String id;
//   final String name;
//   final int phone;
//   final String email;
//   final String businessName;
//   final String businessAddress;
//   final String gst;
//   final String signature;
//   final String signatureId;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   User({
//     required this.id,
//     required this.name,
//     required this.phone,
//     required this.email,
//     required this.businessName,
//     required this.businessAddress,
//     required this.gst,
//     required this.signature,
//     required this.signatureId,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   // Convert JSON to User
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['_id'],
//       name: json['name'],
//       phone: json['phone'],
//       email: json['email'],
//       businessName: json['business_name'],
//       businessAddress: json['business_address'],
//       gst: json['gst'],
//       signature: json['signature'],
//       signatureId: json['signature_id'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }

//   // Convert User to JSON (for storing in SharedPreferences)
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'phone': phone,
//       'email': email,
//       'business_name': businessName,
//       'business_address': businessAddress,
//       'gst': gst,
//       'signature': signature,
//       'signature_id': signatureId,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }

class User {
  final String id;
  final String name;
  final int phone; // Changed to int to match API response
  final String email;
  final String businessName;
  final String businessAddress;
  final String gst;
  final String signature;
  final String signatureId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] is int
          ? json['phone']
          : int.tryParse(json['phone'].toString()) ??
              0, // Convert String to int safely
      email: json['email'] ?? '',
      businessName: json['business_name'] ?? '',
      businessAddress: json['business_address'] ?? '',
      gst: json['gst'] ?? '',
      signature: json['signature'] ?? '',
      signatureId: json['signature_id'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
