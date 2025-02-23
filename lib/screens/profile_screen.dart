import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:storeedge/auth/login/login_screen.dart';
import 'package:storeedge/utils/theme/app_colors.dart';
import 'package:storeedge/widgets/others/used-in-home/footer.dart';
import 'package:storeedge/widgets/others/used-in-profile-screen/profile_item.dart';
import 'package:storeedge/widgets/others/used-in-profile-screen/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = 'Loading...';
  String email = 'Loading...';
  Map<String, String> profileDetails = {};

  @override
  void initState() {
    super.initState();
    fetchProfileDetails();
  }

  Future<void> fetchProfileDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      print('Access token not found');
      return;
    }

    final response = await http.get(
      Uri.parse('https://diversionbackend.onrender.com/api/users/profile'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];

      setState(() {
        name = data['name'];
        email = data['email'];
        profileDetails = {
          'Phone': data['phone'],
          'Business Name': data['business_name'],
          'Business Address': data['business_address'],
          'GST Number': data['gst'],
          'Signature': data['signature'], // Image URL
          'Created At': data['createdAt'],
          'Updated At': data['updatedAt'],
        };
      });
    } else {
      print('Failed to load profile: ${response.body}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios,
                        color: Colors.black, size: 24),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: logout,
                    child:
                        const Icon(Icons.logout, color: Colors.black, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Profile',
                style: TextStyle(
                  color: Color(0xFF5044FC),
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 32),
              UserProfile(name: name, email: email),
              const SizedBox(height: 32),
              const Text(
                'Options',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView(
                  children: profileDetails.entries.map((entry) {
                    return Column(
                      children: [
                        ProfileItem(title: "${entry.key}: ${entry.value}"),
                        const SizedBox(height: 29),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 23),
              const Footer(),
            ],
          ),
        ),
      ),
    );
  }
}
