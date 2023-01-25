import 'package:flutter/material.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.phoneNumber}) : super(key: key);
  final String? phoneNumber;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Successfully Verified',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                '${widget.phoneNumber}',
                style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.secondColor,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
