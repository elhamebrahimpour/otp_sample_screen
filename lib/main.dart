import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/auth_bloc.dart';
import 'package:otp_sample_screen/bloc/auth_state.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';
import 'package:otp_sample_screen/di/firebase_di.dart';
//import 'package:otp_sample_screen/firebase_options.dart';
import 'package:otp_sample_screen/screens/home_screen.dart';
import 'package:otp_sample_screen/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize firebase before app runs
  //when we run flutterfire configure command
  //firebase_options class added to the lib => this class is private to each application
  //after that we can use => DefaultFirebaseOptions.currentPlatform
  await Firebase.initializeApp();
  await getFirebaseInit();
  runApp(MyApplication());
}

class MyApplication extends StatelessWidget {
  MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _getThemeData(),
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoggedInState) {
                return HomeScreen();
              } else if (state is AuthLoggedOutState) {
                return LoginScreen();
              }
              return LoginScreen();
            },
          )),
    );
  }

  ThemeData _getThemeData() {
    return ThemeData(
      primarySwatch: Colors.indigo,
      //text theme for titles
      textTheme: TextTheme(
        headline2: TextStyle(
          color: CustomColors.secondColor,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      //button theme for main action buttons
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
