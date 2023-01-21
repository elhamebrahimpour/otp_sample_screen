import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/otp_bloc.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';
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
  final TextEditingController countryCodeController = TextEditingController();
  RoundedLoadingButtonController sendCodeBtnController =
      RoundedLoadingButtonController();
  String? phonenumber;

  //this method handles sign in to the app via phone number
  void signinWithPhoneNumber() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: countryCodeController.text + phonenumber!,
          verificationCompleted: (_) {},
          verificationFailed: ((error) {
            throw Exception();
          }),
          codeSent: ((verificationId, forceResendingToken) async {
            await Future.delayed(Duration(seconds: 2));
            sendCodeBtnController.success();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => BlocProvider(
                      create: (context) => OTPBloc(),
                      child: OTPScreen(
                        verificationId: verificationId,
                      ),
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
              onPressed: () => signinWithPhoneNumber(),
              child: Text('send code'),
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
          //we can select country code via this package
          CountryListPick(
            theme: CountryTheme(
              isDownIcon: false,
              isShowCode: false,
              isShowFlag: true,
              isShowTitle: false,
            ),
            initialSelection: '+98',
            /* onChanged: (value) {
              setState(() {
                countryCode = value.toString();
              });
            },*/
            pickerBuilder: (context, countryCode) {
              if (countryCode != null) {
                countryCodeController.text = countryCode.dialCode!;
              }
              return Image.asset(
                '${countryCode?.flagUri!}',
                package: 'country_list_pick',
                width: 32,
              );
            },
          ),
          SizedBox(
            width: 36,
            child: TextField(
              controller: countryCodeController,
              enabled: false,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                border: InputBorder.none,
                //labelText: 'enter phone number',
                hintText: '000 000 0000',
                hintStyle: TextStyle(
                  color: CustomColors.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onChanged: (value) => setState(() {
                phonenumber = phoneNumberController.text;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
