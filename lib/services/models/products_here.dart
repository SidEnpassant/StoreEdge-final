class ProductsHere {
  String id; // This will store the _id from the API
  String name;
  int quantity;
  int price;

  ProductsHere({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  int get total => quantity * price;

  Map<String, dynamic> toBillItem() {
    return {"productId": id, "quantity": quantity, "priceAtSale": price};
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  factory ProductsHere.fromJson(Map<String, dynamic> json) {
    return ProductsHere(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}
