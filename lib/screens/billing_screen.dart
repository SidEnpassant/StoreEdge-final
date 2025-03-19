import 'package:flutter/material.dart';
import 'package:storeedge/services/functions/bill_service.dart';
import 'package:storeedge/services/models/products_here.dart';
import 'package:storeedge/widgets/global/noti_and_account_icon.dart';
import 'package:storeedge/widgets/others/used-in-billing-screen/customer_info.dart';
import 'package:storeedge/widgets/others/used-in-billing-screen/header.dart';
import 'package:storeedge/widgets/others/used-in-billing-screen/payment_details.dart';
import 'package:storeedge/widgets/others/used-in-billing-screen/products_section.dart';
import 'package:storeedge/widgets/others/used-in-billing-screen/total_section.dart';
import 'package:storeedge/utils/constants.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  List<ProductsHere> products = [];
  double total = 0;
  double discount = 0;
  String customerName = '';
  String customerAddress = '';
  String customerPhone = '';
  String paymentMethod = 'Cash';
  String paymentStatus = 'Paid';
  double paidAmount = 0;

  void _handleProductsChanged(List<ProductsHere> newProducts) {
    setState(() {
      products = newProducts;
    });
  }

  void _handleTotalChanged(double newTotal) {
    setState(() {
      total = newTotal;
      if (paymentStatus == 'Paid') {
        paidAmount = total - discount;
      }
    });
  }

  void _handleCustomerInfoChanged(String name, String address, String phone) {
    setState(() {
      customerName = name;
      customerAddress = address;
      customerPhone = phone;
    });
  }

  // Modified to use Future.microtask to avoid setState during build
  void _handlePaymentDetailsChanged(
    String method,
    String status,
    double amount,
  ) {
    Future.microtask(() {
      setState(() {
        paymentMethod = method;
        paymentStatus = status;
        paidAmount = amount;
      });
    });
  }

  void _handleDiscountChanged(double newDiscount) {
    setState(() {
      discount = newDiscount;
      if (paymentStatus == 'Paid') {
        paidAmount = total - discount;
      }
    });
  }

  Future<void> _generateBill() async {
    if (products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add products to the bill')),
      );
      return;
    }

    if (customerName.isEmpty ||
        customerAddress.isEmpty ||
        customerPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all customer details')),
      );
      return;
    }

    try {
      final response = await BillService.generateBill(
        discount: discount,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        paidAmount: paidAmount,
        customerName: customerName,
        customerAddress: customerAddress,
        customerPhone: customerPhone,
        items: products.map((p) => p.toBillItem()).toList(),
      );

      if (response['success'] == true) {
        final billUrl = response['data']['billUrl'];
        if (mounted) {
          // Add mounted check before showing dialog
          _showBillOptions(billUrl);
        }
      }
    } catch (e) {
      if (mounted) {
        // Add mounted check before showing error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating bill: $e')),
        );
      }
    }
  }

  void _showBillOptions(String billUrl) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bill Generated Successfully'),
        content: const Text('What would you like to do with the bill?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              BillService.viewBill(billUrl, context);
            },
            child: const Text('View'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await BillService.downloadBill(billUrl, context);
            },
            child: const Text('Download'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.pop(context);
                await BillService.shareBill(billUrl);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error sharing bill: $e')),
                );
              }
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }

  // void _showBillOptions(String billUrl) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Bill Generated Successfully'),
  //       content: const Text('What would you like to do with the bill?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () async {
  //             try {
  //               Navigator.pop(context);
  //               await BillService.viewBill(billUrl);
  //             } catch (e) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('Error viewing bill: $e')),
  //               );
  //             }
  //           },
  //           child: const Text('View'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             Navigator.pop(context);
  //             await BillService.downloadBill(billUrl, context);
  //           },
  //           child: const Text('Download'),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             try {
  //               Navigator.pop(context);
  //               await BillService.shareBill(billUrl);
  //             } catch (e) {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 SnackBar(content: Text('Error sharing bill: $e')),
  //               );
  //             }
  //           },
  //           child: const Text('Share'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _showBillOptions(String billUrl) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Bill Generated Successfully'),
  //       content: const Text('What would you like to do with the bill?'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: const Text('View'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             BillService.downloadBill(billUrl);
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Download'),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: const Text('Share'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: const Color(0xFFEEEEEE),

        body: Container(
      decoration: BoxDecoration(
        gradient: ThemeConstants.backgroundGradient,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
            child: Column(
              children: [
                const NotiAndAccountIconHeader(),
                const SizedBox(height: 16),
                const BillingHeader(),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    CustomerInfo(
                      onCustomerInfoChanged: _handleCustomerInfoChanged,
                    ),
                    const SizedBox(height: 16),
                    ProductsSection(
                      onProductsChanged: _handleProductsChanged,
                      onTotalChanged: _handleTotalChanged,
                    ),
                    const SizedBox(height: 16),
                    TotalSection(
                      total: total,
                      onDiscountChanged: _handleDiscountChanged,
                    ),
                    const SizedBox(height: 16),
                    PaymentDetails(
                      totalAmount: total - discount,
                      onPaymentDetailsChanged: _handlePaymentDetailsChanged,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _generateBill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5044FC),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.fromLTRB(89, 7, 89, 7),
                      ),
                      child: const Text(
                        'Generate bill',
                        style: TextStyle(
                          color: Color(0xFFB6EF86),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
