class ProductFetchAddInBillModel {
  final String id;
  final String name;
  final int price;
  final int stock;
  final String imageUrl;
  final String unitType;

  ProductFetchAddInBillModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.unitType,
  });

  factory ProductFetchAddInBillModel.fromJson(Map<String, dynamic> json) {
    return ProductFetchAddInBillModel(
      id: json['_id'],
      name: json['name'],
      price: json['price'],
      stock: json['quantity'],
      imageUrl: json['image'],
      unitType: json['unitType'],
    );
  }
}
