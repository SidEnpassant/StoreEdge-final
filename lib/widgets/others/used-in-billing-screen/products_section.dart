import 'package:flutter/material.dart';
import 'package:storeedge/screens/add_products_to_billScreen.dart';
import 'package:storeedge/services/models/products_here.dart';
import 'package:storeedge/screens/add_products_to_billScreen.dart';

class ProductsSection extends StatefulWidget {
  final Function(List<ProductsHere>) onProductsChanged;
  final Function(double) onTotalChanged;

  const ProductsSection({
    Key? key,
    required this.onProductsChanged,
    required this.onTotalChanged,
  }) : super(key: key);

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> {
  bool isExpanded = false;
  List<ProductsHere> products = [];

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
      _notifyChanges();
    });
  }

  void _notifyChanges() {
    widget.onProductsChanged(products);
    double total = products.fold(
      0,
      (sum, product) => sum + (product.quantity * product.price),
    );
    widget.onTotalChanged(total);
  }

  void addNewProducts(List<ProductsHere> newProducts) {
    setState(() {
      for (var newProduct in newProducts) {
        int existingIndex = products.indexWhere((p) => p.id == newProduct.id);
        if (existingIndex != -1) {
          products[existingIndex].quantity += newProduct.quantity;
        } else {
          products.add(newProduct);
        }
      }
      _notifyChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF5044FC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildHeader(),
          if (products.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No products added yet',
                style: TextStyle(color: Colors.white),
              ),
            )
          else ...[
            const SizedBox(height: 23),
            ...products
                .asMap()
                .entries
                .take(isExpanded ? products.length : 2)
                .map(
                  (entry) => Column(
                    children: [
                      _buildProductItem(entry.value, entry.key),
                      if (entry.key < products.length - 1)
                        const Divider(color: Colors.white),
                    ],
                  ),
                ),
            if (products.length > 2)
              InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductItem(ProductsHere product, int index) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              onTap: () => deleteProduct(index),
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 19),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Quantity: ${product.quantity}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              'Rs ${product.price * product.quantity}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 23),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.shopping_bag, color: Color(0xFFB6EF86)),
            SizedBox(width: 12),
            Text(
              'Products',
              style: TextStyle(
                color: Color(0xFFB6EF86),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push<List<ProductsHere>>(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductListingScreen(),
              ),
            );
            if (result != null) {
              addNewProducts(result);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFB6EF86),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
          ),
          child: const Text(
            'Add more',
            style: TextStyle(
              color: Color(0xFF5044FC),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
