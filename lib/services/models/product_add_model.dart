// lib/services/models/product_model.dart
class ProductAddModel {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String unitType;
  final String? image;
  final String? imageId;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductAddModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.unitType,
    this.image,
    this.imageId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductAddModel.fromJson(Map<String, dynamic> json) {
    return ProductAddModel(
      id: json['_id'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      unitType: json['unitType'],
      image: json['image'],
      imageId: json['imageId'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'unitType': unitType,
      'image': image,
      'imageId': imageId,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
