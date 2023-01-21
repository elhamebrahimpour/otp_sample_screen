import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';
import 'package:otp_sample_screen/firebase_options.dart';
import 'package:otp_sample_screen/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApplication());
}

class MyApplication extends StatelessWidget {
  MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _getThemeData(),
      home: LoginScreen(),
    );
  }

  ThemeData _getThemeData() {
    return ThemeData(
      primarySwatch: Colors.indigo,
      textTheme: TextTheme(
        headline2: TextStyle(
          color: CustomColors.secondColor,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: CustomColors.mainColor,
          fixedSize: Size(200, 46),
          elevation: 1,
        ),
      ),
    );
  }
}
