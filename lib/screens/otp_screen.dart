import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/otp_bloc.dart';
import 'package:otp_sample_screen/bloc/otp_event.dart';
import 'package:otp_sample_screen/bloc/otp_state.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';
import 'package:otp_sample_screen/screens/home_screen.dart';
import 'package:otp_sample_screen/widgets/otp_widget.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({super.key, required this.verificationId});
  final String verificationId;
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  int levelClock = 1 * 60;
  bool isVerified = false;

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
// 'K0B+rPPRqed'
  Future smsListener() async {
    String? comingSms = '';
    try {
      while (true) {
        comingSms = await AltSmsAutofill().listenForSms;
        if (comingSms!.contains('AIzaSyC5OQ237li87DTyT2guFuwKrloLvRR-0Tw')) {
          return comingSms.substring(0, 6);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  verifyOTP(String verificationId, String userOTP) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.of(context).push(
        MaterialPageRoute(builder: ((context) => HomeScreen())),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  fillOTP() async {
    String otpCode = await smsListener();
    _fieldOne.text = otpCode.substring(0, 1);
    _fieldTwo.text = otpCode.substring(1, 2);
    _fieldThree.text = otpCode.substring(2, 3);
    _fieldFour.text = otpCode.substring(3, 4);
    _fieldFive.text = otpCode.substring(4, 5);
    _fieldSix.text = otpCode.substring(5, 6);
    verifyOTP(widget.verificationId, otpCode);
  }

  @override
  void initState() {
    fillOTP();

    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));
    _animationController!.forward();
  }

  @override
  void dispose() {
    AltSmsAutofill().unregisterListener();
    super.dispose();
    _animationController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: _getOTPBody(context),
    );
  }

  Widget _getOTPBody(BuildContext context) {
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
              ' code to +98914******',
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
            _getVerifyButton(context),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getOtpVrifiedState(),
                SizedBox(
                  width: 12,
                ),
                Visibility(
                  visible: !isVerified,
                  child: Countdown(
                    animation: StepTween(
                      begin: levelClock, // THIS IS A USER ENTERED NUMBER
                      end: 0,
                    ).animate(_animationController!),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _getVerifyButton(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style,
      onPressed: () {
        setState(() {
          isVerified = true;
        });
        context.read<OTPBloc>().add(
              OTPVerifiedPressed(
                otp1: _fieldOne.text = '',
                otp2: _fieldTwo.text = '',
                otp3: _fieldThree.text = '',
                otp4: _fieldFour.text = '',
                otp5: _fieldFive.text = '',
                otp6: _fieldSix.text = '',
              ),
            );
      },
      child: Text(
        'Verify',
        style: Theme.of(context)
            .textTheme
            .headline2!
            .copyWith(fontSize: 18, color: Colors.white, letterSpacing: 1),
      ),
    );
  }

  Widget _getOtpVrifiedState() {
    return BlocBuilder<OTPBloc, OTPState>(
      builder: ((context, state) {
        if (state is OTPInitial) {
          return Text(
            '${state.otp}',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontSize: 16,
                  color: CustomColors.mainColor,
                ),
          );
        }
        if (state is OTPVerifiedState) {
          return Text(
            '${state.otp}',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  fontSize: 20,
                ),
          );
        }
        return Text(
          'Error!',
          style: Theme.of(context).textTheme.headline2!.copyWith(
                fontSize: 16,
              ),
        );
      }),
    );
  }

  Widget _getOtpBoxRow() {
    return Form(
      onChanged: () {
        if (_fieldOne.text.isNotEmpty &&
            _fieldTwo.text.isNotEmpty &&
            _fieldThree.text.isNotEmpty &&
            _fieldFour.text.isNotEmpty &&
            _fieldFive.text.isNotEmpty &&
            _fieldSix.text.isNotEmpty) {
          verifyOTP(widget.verificationId,
              '${_fieldOne.text}${_fieldTwo.text}${_fieldThree.text}${_fieldFour.text}${_fieldFive.text}${_fieldSix.text}');
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          OTPInput(textEditingController: _fieldOne, autoFocus: true),
          OTPInput(textEditingController: _fieldTwo, autoFocus: false),
          OTPInput(textEditingController: _fieldThree, autoFocus: false),
          OTPInput(textEditingController: _fieldFour, autoFocus: false),
          OTPInput(textEditingController: _fieldFive, autoFocus: false),
          OTPInput(textEditingController: _fieldSix, autoFocus: false),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class Countdown extends AnimatedWidget {
  Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      timerText,
      style: Theme.of(context).textTheme.headline2!.copyWith(
            fontSize: 16,
            color: CustomColors.mainColor,
          ),
    );
  }
}
/*
 TweenAnimationBuilder(
                tween: StepTween(begin: 60, end: 00),
                duration: Duration(seconds: 60),
                builder: ((context, value, child) {
                  if (value == 0) {
                    return Row(
                      children: [
                        Text(
                          'the code will expired after: ',
                          style:
                              Theme.of(context).textTheme.headline2!.copyWith(
                                    fontSize: 16,
                                    color: CustomColors.mainColor,
                                  ),
                        ),
                        Text('00:${value.toInt()}')
                      ],
                    );
                  } else {
                    return TextButton(
                      onPressed: () {},
                      child: Text(
                        'Resend code',
                        style: Theme.of(context).textTheme.headline2!.copyWith(
                              fontSize: 16,
                              color: CustomColors.mainColor,
                            ),
                      ),
                    );
                  }
                }),
              )*/