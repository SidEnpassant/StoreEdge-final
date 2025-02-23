import 'package:flutter/material.dart';
import 'package:storeedge/services/functions/product_search_service.dart';
import 'package:storeedge/services/functions/products_add_in_bill_service.dart';

import 'package:storeedge/services/models/product_fetch_add_in_bill.dart';
import 'package:storeedge/services/models/products_here.dart';
import 'package:storeedge/widgets/others/used-in-adding-product-to-bill/adding_prod_card.dart';
import 'package:storeedge/widgets/others/used-in-adding-product-to-bill/search_bar.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({Key? key}) : super(key: key);

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  List<ProductFetchAddInBillModel> products = [];
  List<ProductFetchAddInBillModel> filteredProducts = [];
  bool isLoading = true;
  List<ProductsHere> selectedProducts = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts =
          await ProductFetchInAddingToBillScreen.getProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading products: $e')),
      );
    }
  }

  Future<void> handleSearch(String query) async {
    setState(() {
      isLoading = true;
      searchQuery = query;
    });

    try {
      if (query.isEmpty) {
        setState(() {
          filteredProducts = products;
          isLoading = false;
        });
        return;
      }

      final searchResults = await ProductSearchService.searchProducts(query);
      setState(() {
        filteredProducts = searchResults;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching products: $e')),
      );
    }
  }

  Future<void> _showQuantityDialog(ProductFetchAddInBillModel product) async {
    int? quantity;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter Quantity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Available stock: ${product.stock}'),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Quantity',
                hintText: 'Enter quantity (max ${product.stock})',
              ),
              onChanged: (value) {
                quantity = int.tryParse(value);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (quantity != null &&
                  quantity! <= product.stock &&
                  quantity! > 0) {
                setState(() {
                  selectedProducts.add(ProductsHere(
                    id: product.id,
                    name: product.name,
                    quantity: quantity!,
                    price: product.price,
                  ));
                });
                Navigator.pop(
                    context); // Only dismiss the dialog, not the screen
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid quantity')),
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, selectedProducts);
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEEEE),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context, selectedProducts);
                      },
                      child: const Icon(Icons.chevron_left, size: 24),
                    ),
                    Text('${selectedProducts.length} items selected'),
                  ],
                ),
                const SizedBox(height: 26),
                const Text(
                  'Add products',
                  style: TextStyle(
                    fontSize: 32,
                    color: Color(0xFF5044FC),
                  ),
                ),
                const SizedBox(height: 6),
                CustomSearchBar(
                  onSearch: handleSearch,
                ),
                if (isLoading)
                  Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return AddingProdCard(
                          product: products[index],
                          onAdd: () => _showQuantityDialog(products[index]),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
