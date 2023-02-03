import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/auth_bloc.dart';
import 'package:otp_sample_screen/bloc/auth_event.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'user login successfully',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 32,
              ),
              TextButton(
                //logout action handles
                onPressed: () =>
                    BlocProvider.of<AuthBloc>(context).add(SignOutPressed()),
                child: Text(
                  'Logout',
                  style:
                      TextStyle(fontSize: 16, color: CustomColors.secondColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
