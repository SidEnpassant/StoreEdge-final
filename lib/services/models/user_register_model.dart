// lib/services/models/user_model.dart

class UserRegisterModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String businessName;
  final String businessAddress;
  final String gst;
  final String? signature;
  final String? signatureId;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserRegisterModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.businessName,
    required this.businessAddress,
    required this.gst,
    this.signature,
    this.signatureId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      businessName: json['business_name'] ?? '',
      businessAddress: json['business_address'] ?? '',
      gst: json['gst'] ?? '',
      signature: json['signature'],
      signatureId: json['signature_id'],
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
