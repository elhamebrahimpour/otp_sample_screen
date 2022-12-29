import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/otp_bloc.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';
import 'package:otp_sample_screen/screens/otp_screen.dart';

void main() {
  runApp(const MyApplication());
}

class MyApplication extends StatelessWidget {
  const MyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          textTheme: TextTheme(
            headline2: TextStyle(
              color: CustomColors.secondColor,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: CustomColors.secondColor,
            fixedSize: Size(200, 46),
            elevation: 1,
          ))),
      home: BlocProvider(
        create: (context) => OTPBloc(),
        child: OTPScreen(),
      ),
    );
  }
}
