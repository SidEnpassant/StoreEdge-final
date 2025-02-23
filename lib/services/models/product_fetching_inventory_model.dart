// lib/services/models/product_model.dart

class ProductFetchingInventoryModel {
  final String id;
  final String name;
  final int price;
  final int quantity;
  final String unitType;
  final String image;
  final int growth; // Assuming growth is hardcoded for now
  final bool isLowStock;

  ProductFetchingInventoryModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.unitType,
    required this.image,
    this.growth = 12, // Default growth value
    required this.isLowStock,
  });

  factory ProductFetchingInventoryModel.fromJson(Map<String, dynamic> json) {
    final quantity = json['quantity'] is int
        ? json['quantity']
        : int.parse(json['quantity'].toString());
    return ProductFetchingInventoryModel(
      id: json['_id'],
      name: json['name'],
      price: json['price'] is int
          ? json['price']
          : int.parse(json['price'].toString()),
      quantity: quantity,
      unitType: json['unitType'],
      image: json['image'],
      isLowStock: quantity < 10,
    );
  }
}
