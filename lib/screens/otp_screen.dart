import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/auth_bloc.dart';
import 'package:otp_sample_screen/bloc/auth_event.dart';
import 'package:otp_sample_screen/bloc/auth_state.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';
import 'package:otp_sample_screen/di/firebase_di.dart';
import 'package:otp_sample_screen/screens/home_screen.dart';
import 'package:otp_sample_screen/screens/login_screen.dart';
import 'package:otp_sample_screen/widgets/otp_pin_widget.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({super.key, required this.phoneNumber});
  final String phoneNumber;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  final FirebaseAuth auth = serviceLocator.get();

  RoundedLoadingButtonController verifyController =
      RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 300,
                width: 300,
                child: Image.asset('images/verification.webp'),
              ),
              Text(
                'Enter your verification code',
                style: Theme.of(context).textTheme.headline2,
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                'We have sent a verification',
                style: TextStyle(
                    color: CustomColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
              Text(
                ' code to ${widget.phoneNumber}',
                style: TextStyle(
                    color: CustomColors.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(
                height: 18,
              ),
              _getOtpBoxRow(),
              SizedBox(
                height: 62,
              ),
              //listen to the action that authenticates user
              //if authenticated navigates to the home screen
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthLoggedInState) {
                    verifyController.success();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: ((context) => HomeScreen()),
                      ),
                    );
                  } else if (state is AuthErrorState) {
                    verifyController.error();
                  }
                },
                builder: (context, state) {
                  return _getSignInButton(context);
                },
              ),
              SizedBox(
                height: 62,
              ),
              Text(
                'Didn\'t receive any code?',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontSize: 16,
                      color: CustomColors.mainColor,
                    ),
              ),
              SizedBox(
                height: 12,
              ),
              _showCountDownTimer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showCountDownTimer(BuildContext context) {
    return TweenAnimationBuilder(
      tween: StepTween(begin: 60, end: 00),
      duration: Duration(seconds: 60),
      builder: ((context, value, child) => value == 0
          ? TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: ((context) => LoginScreen()),
                  ),
                );
              },
              child: Text(
                'Resend code!',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontSize: 16,
                      color: CustomColors.mainColor,
                    ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'the code will expired after: ',
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        fontSize: 16,
                        color: CustomColors.mainColor,
                      ),
                ),
                Text('00:${value.toInt()}')
              ],
            )),
    );
  }

  Widget _getSignInButton(BuildContext context) {
    return RoundedLoadingButton(
      color: CustomColors.secondColor,
      controller: verifyController,
      onPressed: () async {
        if (_fieldOne.text.isNotEmpty &&
            _fieldTwo.text.isNotEmpty &&
            _fieldThree.text.isNotEmpty &&
            _fieldFour.text.isNotEmpty &&
            _fieldFive.text.isNotEmpty &&
            _fieldSix.text.isNotEmpty) {
          String smsCode =
              '${_fieldOne.text.trim()}${_fieldTwo.text.trim()}${_fieldThree.text.trim()}${_fieldFour.text.trim()}${_fieldFive.text.trim()}${_fieldSix.text.trim()}';
          //verify the user
          BlocProvider.of<AuthBloc>(context).add(SignInPressed(smsCode));
        }
      },
      child: Text('Sign In'),
    );
  }

  Widget _getOtpBoxRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OTPPinInput(textEditingController: _fieldOne, autoFocus: true),
        OTPPinInput(textEditingController: _fieldTwo, autoFocus: false),
        OTPPinInput(textEditingController: _fieldThree, autoFocus: false),
        OTPPinInput(textEditingController: _fieldFour, autoFocus: false),
        OTPPinInput(textEditingController: _fieldFive, autoFocus: false),
        OTPPinInput(textEditingController: _fieldSix, autoFocus: false),
      ],
    );
  }
}
