// import 'package:flutter/material.dart';
// import 'package:storeedge/screens/add_product_in_inventory_screen.dart';
// import 'package:storeedge/services/functions/product_service.dart';
// import 'package:storeedge/services/models/product_fetching_inventory_model.dart';
// import 'package:storeedge/widgets/global/floating_action_button.dart';
// import 'package:storeedge/widgets/global/noti_and_account_icon.dart';
// import 'package:storeedge/widgets/others/used-in-inventory/product_card.dart';
// import 'package:storeedge/widgets/others/used-in-inventory/search_bar.dart';
// import 'package:storeedge/widgets/others/used-in-inventory/stat_card.dart';

// class InventoryScreen extends StatefulWidget {
//   const InventoryScreen({Key? key}) : super(key: key);

//   @override
//   State<InventoryScreen> createState() => _InventoryScreenState();
// }

// class _InventoryScreenState extends State<InventoryScreen> {
//   late Future<List<ProductFetchingInventoryModel>> _productsFuture;
//   int _totalProducts = 0;
//   int _lowStockCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _loadProducts();
//   }

//   void _loadProducts() {
//     _productsFuture = ProductService.fetchInventoryProducts();
//     _productsFuture.then((products) {
//       setState(() {
//         _totalProducts = products.length;
//         _lowStockCount = ProductService.getLowStockCount(products);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEEEEEE),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Fixed header section
//             const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//               child: NotiAndAccountIconHeader(),
//             ),

//             // Stats and search section (non-scrollable)
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: StatCard(
//                           iconAssetPath: 'assets/icons/total_product.png',
//                           title: 'Total Products',
//                           value: _totalProducts.toString(),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: StatCard(
//                           iconAssetPath: 'assets/icons/low_stock.png',
//                           title: 'Low Stock',
//                           value: _lowStockCount.toString(),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   const SearchWithFilter(),
//                   const SizedBox(height: 15),
//                 ],
//               ),
//             ),

//             // Product list (vertically scrollable)
//             // In the InventoryScreen widget:
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: FutureBuilder<List<ProductFetchingInventoryModel>>(
//                   future: _productsFuture,
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Center(
//                         child: Text(
//                           'Error: ${snapshot.error}',
//                           style: const TextStyle(color: Colors.red),
//                         ),
//                       );
//                     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                       return const Center(
//                         child: Text('No products found'),
//                       );
//                     } else {
//                       final products = snapshot.data!;
//                       return ListView.separated(
//                         itemCount: products.length,
//                         separatorBuilder: (context, index) =>
//                             const SizedBox(height: 12),
//                         itemBuilder: (context, index) {
//                           return ProductCard(
//                             product: products[
//                                 index], // Using products[index] instead of product
//                             onProductUpdated:
//                                 _loadProducts, // This will refresh the product list
//                           );
//                         },
//                       );
//                     }
//                   },
//                 ),
//               ),
//             )

//           ],
//         ),
//       ),
//       floatingActionButton: CustomFAB(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddProductScreenToInventory(),
//             ),
//           ).then((_) => _loadProducts()); // Refresh products after returning
//         },
//         assetPath: "assets/icons/add_icon.png",
//         backgroundColor: const Color(0xFFB6EF86),
//         size: 56,
//         iconSize: 25,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:storeedge/screens/add_product_in_inventory_screen.dart';
import 'package:storeedge/services/functions/product_service.dart';
import 'package:storeedge/services/models/product_fetching_inventory_model.dart';
import 'package:storeedge/widgets/global/floating_action_button.dart';
import 'package:storeedge/widgets/global/noti_and_account_icon.dart';
import 'package:storeedge/widgets/others/used-in-inventory/product_card.dart';
import 'package:storeedge/widgets/others/used-in-inventory/search_bar.dart';
import 'package:storeedge/widgets/others/used-in-inventory/stat_card.dart';
import 'package:storeedge/utils/constants.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late Future<List<ProductFetchingInventoryModel>> _productsFuture;
  List<ProductFetchingInventoryModel> _displayedProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = '';
  int _totalProducts = 0;
  int _lowStockCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_searchQuery.isEmpty) {
        _productsFuture = ProductService.fetchInventoryProducts();
      } else {
        _productsFuture = ProductService.searchProducts(_searchQuery);
      }

      final products = await _productsFuture;
      _filterAndUpdateProducts(products);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading products: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterAndUpdateProducts(List<ProductFetchingInventoryModel> products) {
    setState(() {
      switch (_selectedFilter) {
        case 'Low stock':
          _displayedProducts = products.where((p) => p.isLowStock).toList();
          break;
        case 'In stock':
          _displayedProducts = products.where((p) => !p.isLowStock).toList();
          break;
        default:
          _displayedProducts = products;
      }
      _totalProducts = products.length;
      _lowStockCount = products.where((p) => p.isLowStock).length;
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _loadProducts();
  }

  void _handleFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeConstants.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: NotiAndAccountIconHeader(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            iconAssetPath: 'assets/icons/total_product.png',
                            title: 'Total Products',
                            value: _totalProducts.toString(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatCard(
                            iconAssetPath: 'assets/icons/low_stock.png',
                            title: 'Low Stock',
                            value: _lowStockCount.toString(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SearchWithFilter(
                      onSearch: _handleSearch,
                      onFilterSelected: _handleFilter,
                      selectedFilter: _selectedFilter,
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _displayedProducts.isEmpty
                          ? const Center(child: Text('No products found'))
                          : ListView.separated(
                              itemCount: _displayedProducts.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                return ProductCard(
                                  product: _displayedProducts[index],
                                  onProductUpdated: _loadProducts,
                                );
                              },
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreenToInventory(),
            ),
          ).then((_) => _loadProducts());
        },
        assetPath: "assets/icons/add_icon.png",
        backgroundColor: const Color(0xFFB6EF86),
        size: 56,
        iconSize: 25,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
