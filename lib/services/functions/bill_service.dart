// services/functions/bill_service.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class BillService {
  static const String baseUrl = 'https://diversionbackend.onrender.com/api';

  static Future<Map<String, dynamic>> generateBill({
    required double discount,
    required String paymentMethod,
    required String paymentStatus,
    required double paidAmount,
    required String customerName,
    required String customerAddress,
    required String customerPhone,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$baseUrl/sales/bill'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'discount': discount,
          'paymentMethod': paymentMethod,
          'paymentStatus': paymentStatus,
          'paidAmount': paidAmount,
          'customer_name': customerName,
          'customer_address': customerAddress,
          'customer_phone': customerPhone,
          'items': items,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to generate bill: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error generating bill: $e');
    }
  }

  static Future<void> viewBill(String urlString, BuildContext context) async {
    try {
      final Uri url = Uri.parse(urlString.trim());

      if (!await canLaunchUrl(url)) {
        throw Exception('Could not launch URL');
      }

      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );

      if (!launched) {
        throw Exception('Failed to launch URL');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening bill: $e')),
      );
    }
  }

  // static Future<void> viewBill(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw Exception('Could not launch $url');
  //   }
  // }

  static Future<void> downloadBill(String url, BuildContext context) async {
    try {
      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        throw Exception('Storage permission is required to download the bill');
      }

      // Show download starting notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Starting download...')),
      );

      // Get the downloads directory
      final dir = await getExternalStorageDirectory();
      if (dir == null) throw Exception('Could not access storage directory');

      // Create a unique filename
      final fileName = 'bill_${DateTime.now().millisecondsSinceEpoch}.png';
      final savePath = '${dir.path}/$fileName';

      // Initialize Dio
      final dio = Dio();

      // Download the file
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            // Calculate progress percentage
            final progress = (received / total * 100).toStringAsFixed(0);
            print('Download progress: $progress%');
          }
        },
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bill downloaded successfully to Downloads folder'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading bill: $e')),
      );
    }
  }

  // static Future<void> downloadBill(String url, BuildContext context) async {
  //   try {
  //     final snackBar = SnackBar(content: Text('Downloading bill...'));
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);

  //     await FileDownloader.downloadFile(
  //       url: url,
  //       name: 'bill_${DateTime.now().millisecondsSinceEpoch}.png',
  //       onProgress: (String? fileName, double progress) {
  //         print('Download progress: $progress%');
  //       },
  //       onDownloadCompleted: (String path) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Bill downloaded successfully')),
  //         );
  //       },
  //       onDownloadError: (String error) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Error downloading bill: $error')),
  //         );
  //       },
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error downloading bill: $e')),
  //     );
  //   }
  // }

  static Future<void> shareBill(String url) async {
    try {
      await Share.share(
        'Check out this bill: $url',
        subject: 'Bill Share',
      );
    } catch (e) {
      throw Exception('Error sharing bill: $e');
    }
  }
}
