// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:storeedge/widgets/others/used-in-add-product/custom_button.dart';
// import 'package:storeedge/widgets/others/used-in-add-product/custom_text_field_add_product.dart';
// import 'package:storeedge/widgets/others/used-in-add-product/image_upload_widget.dart';

// class AddProductScreenToInventory extends StatefulWidget {
//   const AddProductScreenToInventory({Key? key}) : super(key: key);

//   @override
//   State<AddProductScreenToInventory> createState() =>
//       _AddProductScreenToInventoryState();
// }

// class _AddProductScreenToInventoryState
//     extends State<AddProductScreenToInventory> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();
//   final TextEditingController _priceController =
//       TextEditingController(text: '');
//   String _selectedUnit = 'piece';
//   String? _imagePath;

//   Future<void> _pickImage() async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? photo = await picker.pickImage(source: ImageSource.camera);

//       if (photo != null) {
//         setState(() {
//           _imagePath = photo.path;
//         });
//       }
//     } catch (e) {
//       // Show error message to user
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error picking image: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFEEEEEE),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: MediaQuery.of(context).size.width <= 640 ? 15 : 20,
//               vertical: MediaQuery.of(context).size.width <= 640 ? 20 : 27,
//             ),
//             constraints: const BoxConstraints(maxWidth: 412),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     width: 38,
//                     height: 38,
//                     alignment: Alignment.center,
//                     child: const Icon(
//                       Icons.arrow_back_ios,
//                       color: Color(0xFF151515),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 Text(
//                   'Add product',
//                   style: TextStyle(
//                     color: const Color(0xFF5044FC),
//                     fontSize:
//                         MediaQuery.of(context).size.width <= 640 ? 28 : 32,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal:
//                         MediaQuery.of(context).size.width <= 640 ? 20 : 31,
//                     vertical:
//                         MediaQuery.of(context).size.width <= 640 ? 25 : 33,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Column(
//                     children: [
//                       ImageUploadWidget(
//                         onTap: _pickImage, // Add this line
//                         imagePath: _imagePath, // Add this line
//                       ),
//                       const SizedBox(height: 30),
//                       CustomTextFieldAddProductScreen(
//                         label: 'Product Name',
//                         placeholder: 'Enter product name',
//                         controller: _nameController,
//                       ),
//                       const SizedBox(height: 24),
//                       CustomTextFieldAddProductScreen(
//                         label: 'Quantity',
//                         placeholder: 'Enter quantity',
//                         controller: _quantityController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.digitsOnly
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       CustomTextFieldAddProductScreen(
//                         label: 'Price',
//                         placeholder: '0.00',
//                         controller: _priceController,
//                         isPrice: false,
//                         keyboardType: const TextInputType.numberWithOptions(
//                             decimal: true),
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(
//                               RegExp(r'^\d*\.?\d{0,2}')),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Unit Type',
//                             style: TextStyle(
//                               color: Color(0xFF5044FC),
//                               fontSize: 14,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Container(
//                             height: 50,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(
//                                 color: const Color(0xFFE5E7EB),
//                               ),
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 value: _selectedUnit,
//                                 isExpanded: true,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 16),
//                                 items: ['piece', 'kgs'].map((String value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value,
//                                     child: Text(
//                                       value,
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w900,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? newValue) {
//                                   if (newValue != null) {
//                                     setState(() {
//                                       _selectedUnit = newValue;
//                                     });
//                                   }
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       CustomButtonAddProductScreen(
//                         text: 'Add Product',
//                         onPressed: () {
//                           // Implement add product functionality
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Center(
//                   child: Text(
//                     'Or',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w900,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Center(
//                   child: CustomButtonAddProductScreen(
//                     text: 'Scan',
//                     onPressed: () {
//                       // Implement scan functionality
//                     },
//                     width: 300,
//                     fontSize: 24,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _quantityController.dispose();
//     _priceController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storeedge/services/functions/product_add_service.dart';
import 'package:storeedge/widgets/others/used-in-add-product/custom_button.dart';
import 'package:storeedge/widgets/others/used-in-add-product/custom_text_field_add_product.dart';
import 'package:storeedge/widgets/others/used-in-add-product/image_upload_widget.dart';

class AddProductScreenToInventory extends StatefulWidget {
  const AddProductScreenToInventory({Key? key}) : super(key: key);

  @override
  State<AddProductScreenToInventory> createState() =>
      _AddProductScreenToInventoryState();
}

class _AddProductScreenToInventoryState
    extends State<AddProductScreenToInventory> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController =
      TextEditingController(text: '');
  String _selectedUnit = 'piece';
  String? _imagePath;
  bool _isLoading = false;
  final ProductAddService _productService = ProductAddService();

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.camera);

      if (photo != null) {
        setState(() {
          _imagePath = photo.path;
        });
      }
    } catch (e) {
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _addProduct() async {
    // Validate inputs
    if (_nameController.text.isEmpty) {
      _showErrorMessage('Product name is required');
      return;
    }

    if (_quantityController.text.isEmpty) {
      _showErrorMessage('Quantity is required');
      return;
    }

    if (_priceController.text.isEmpty) {
      _showErrorMessage('Price is required');
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final product = await _productService.addProduct(
        name: _nameController.text,
        price: double.parse(_priceController.text),
        quantity: int.parse(_quantityController.text),
        unitType: _selectedUnit,
        imagePath: _imagePath,
      );

      setState(() {
        _isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form or navigate back
      Navigator.pop(context, product);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage('Failed to add product: ${e.toString()}');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width <= 640 ? 15 : 20,
              vertical: MediaQuery.of(context).size.width <= 640 ? 20 : 27,
            ),
            constraints: const BoxConstraints(maxWidth: 412),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 38,
                    height: 38,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFF151515),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Add product',
                  style: TextStyle(
                    color: const Color(0xFF5044FC),
                    fontSize:
                        MediaQuery.of(context).size.width <= 640 ? 28 : 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        MediaQuery.of(context).size.width <= 640 ? 20 : 31,
                    vertical:
                        MediaQuery.of(context).size.width <= 640 ? 25 : 33,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      ImageUploadWidget(
                        onTap: _pickImage,
                        imagePath: _imagePath,
                      ),
                      const SizedBox(height: 30),
                      CustomTextFieldAddProductScreen(
                        label: 'Product Name',
                        placeholder: 'Enter product name',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 24),
                      CustomTextFieldAddProductScreen(
                        label: 'Quantity',
                        placeholder: 'Enter quantity',
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomTextFieldAddProductScreen(
                        label: 'Price',
                        placeholder: '0.00',
                        controller: _priceController,
                        isPrice: false,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Unit Type',
                            style: TextStyle(
                              color: Color(0xFF5044FC),
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedUnit,
                                isExpanded: true,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                items: ['piece', 'kgs'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedUnit = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _isLoading
                          ? const CircularProgressIndicator(
                              color: Color(0xFF5044FC),
                            )
                          : CustomButtonAddProductScreen(
                              text: 'Add Product',
                              onPressed: _addProduct,
                            ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'Or',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: CustomButtonAddProductScreen(
                    text: 'Scan',
                    onPressed: () {
                      // Implement scan functionality
                    },
                    width: 300,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}
