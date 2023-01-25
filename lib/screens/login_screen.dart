import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';
import 'package:otp_sample_screen/di/firebase_di.dart';
import 'package:otp_sample_screen/screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  RoundedLoadingButtonController sendCodeBtnController =
      RoundedLoadingButtonController();
  String _country_code = '+98';

  //this method handles signin/login
  //to the app via phone number
  Future sendSmsCode(String mobile, BuildContext context) async {
    final FirebaseAuth _auth = serviceLocator.get();
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: mobile,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) async {},
          verificationFailed: ((error) {
            throw Exception(error.toString());
          }),
          codeSent: ((verificationId, forceResendingToken) async {
            sendCodeBtnController.success();
            await Future.delayed(Duration(seconds: 2));
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => OTPScreen(
                      verificationId: verificationId,
                      phoneNumber: mobile,
                    )),
              ),
            );
          }),
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: _getMainContent(context),
    );
  }

  Widget _getMainContent(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset('images/verification.webp'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 52),
              child: Text(
                'We need to register your phone number before getting started!',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 42,
            ),
            _getmobileContainer(context),
            SizedBox(
              height: 62,
            ),
            RoundedLoadingButton(
              color: CustomColors.secondColor,
              controller: sendCodeBtnController,
              onPressed: () {
                final String mobilePhone =
                    _country_code + phoneNumberController.text.trim();
                sendSmsCode(mobilePhone, context);
              },
              child: Text('Send Code'),
            ),
          ],
        ),
      ),
    );
  }

  //containes mobilephone textfield
  Widget _getmobileContainer(BuildContext context) {
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 62),
      decoration: BoxDecoration(
        border: Border.all(
          color: CustomColors.textColor,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          //we can select country code via this widget
          //which comes from country_list_pick package
          CountryListPick(
            theme: CountryTheme(
              isDownIcon: false,
              isShowCode: true,
              isShowFlag: true,
              isShowTitle: false,
            ),
            initialSelection: _country_code,
            onChanged: (countryCode) {
              setState(() {
                _country_code = countryCode.toString();
              });
            },
          ),
          Expanded(
            child: TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: '000 000 0000',
                hintStyle: TextStyle(
                  color: CustomColors.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
