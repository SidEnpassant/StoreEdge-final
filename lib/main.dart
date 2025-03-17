import 'package:flutter/material.dart';
import 'package:storeedge/auth/login/login_screen.dart';
// import 'package:storeedge/auth/register/register_phone_verify.dart';
// import 'package:storeedge/auth/register/register_screen.dart';
import 'package:storeedge/screens/nav-bar-call-main-screen/main_screen.dart';
import 'package:storeedge/services/models/user_model.dart';
import 'package:storeedge/services/settings/local_storage.dart';
// import 'package:storeedge/widgets/global/bottom%20nav%20bar/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  User? user = await getUser(); // Retrieve user from SharedPreferences
  runApp(MyApp(user: user));
}

//

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StoreEdge',
      theme: ThemeData(
        primaryColor: const Color(0xFF5044FC),
        fontFamily: 'ravenna-serial-extrabold-regular',
      ),
      home: user != null ? const MainScreen() : const LoginScreen(),
    );
  }
}
