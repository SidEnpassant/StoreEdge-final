// import 'package:flutter/material.dart';
// import 'package:storeedge/services/models/product_fetching_inventory_model.dart';

// class ProductCard extends StatelessWidget {
//   final ProductFetchingInventoryModel product;

//   const ProductCard({
//     super.key,
//     required this.product,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF5044FC),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       padding: const EdgeInsets.all(18),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 64,
//                 height: 64,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.grey[300],
//                 ),
//                 child: product.image.isNotEmpty
//                     ? ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.network(
//                           product.image,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return const Icon(Icons.laptop_mac, size: 32);
//                           },
//                         ),
//                       )
//                     : const Icon(Icons.laptop_mac, size: 32),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           product.name,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           'Rs - ${product.price}',
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 6,
//                           ),
//                           decoration: BoxDecoration(
//                             color:
//                                 product.isLowStock ? Colors.red : Colors.green,
//                             borderRadius: BorderRadius.circular(9999),
//                           ),
//                           child: Text(
//                             product.isLowStock
//                                 ? 'Low Stock: ${product.quantity}'
//                                 : 'In Stock: ${product.quantity}',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           product.unitType,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 15),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.trending_up,
//                     color: Colors.white,
//                     size: 16,
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     '+${product.growth}% this month',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // Update functionality
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFFB6EF86),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(9999),
//                   ),
//                 ),
//                 child: const Text(
//                   'Update',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:storeedge/services/functions/product_service.dart';
import 'package:storeedge/services/models/product_fetching_inventory_model.dart';

class ProductCard extends StatefulWidget {
  final ProductFetchingInventoryModel product;
  final VoidCallback onProductUpdated;

  const ProductCard({
    super.key,
    required this.product,
    required this.onProductUpdated,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isUpdating = false;

  Future<void> _showUpdateDialog() async {
    final TextEditingController quantityController = TextEditingController(
      text: widget.product.quantity.toString(),
    );

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Quantity'),
        content: TextField(
          controller: quantityController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'New Quantity',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final newQuantity = int.tryParse(quantityController.text);
              if (newQuantity != null) {
                Navigator.pop(context, newQuantity);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    ).then((value) async {
      if (value != null) {
        try {
          setState(() => _isUpdating = true);
          await ProductService.updateProductQuantity(
            widget.product.id,
            value,
          );
          widget.onProductUpdated();
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error updating quantity: $e')),
            );
          }
        } finally {
          if (mounted) {
            setState(() => _isUpdating = false);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF5044FC),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[300],
                ),
                child: widget.product.image.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.product.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.laptop_mac, size: 32);
                          },
                        ),
                      )
                    : const Icon(Icons.laptop_mac, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rs - ${widget.product.price}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: widget.product.isLowStock
                                ? Colors.red
                                : Colors.green,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            widget.product.isLowStock
                                ? 'Low Stock: ${widget.product.quantity}'
                                : 'In Stock: ${widget.product.quantity}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.product.unitType,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '+${widget.product.growth}% this month',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _isUpdating ? null : _showUpdateDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB6EF86),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9999),
                  ),
                ),
                child: _isUpdating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      )
                    : const Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
