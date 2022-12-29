import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/otp_bloc.dart';
import 'package:otp_sample_screen/bloc/otp_event.dart';
import 'package:otp_sample_screen/bloc/otp_state.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';
import 'package:otp_sample_screen/widgets/otp_widget.dart';

class OTPScreen extends StatelessWidget {
  OTPScreen({super.key});

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your verification code',
              style: Theme.of(context).textTheme.headline2,
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'We have sent a verification',
              style: TextStyle(
                  color: CustomColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
            Text(
              ' code to +98914******',
              style: TextStyle(
                  color: CustomColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: Image.asset('images/verification.webp'),
            ),
            _getOtpBoxRow(),
            SizedBox(
              height: 62,
            ),
            ElevatedButton(
              style: Theme.of(context).elevatedButtonTheme.style,
              onPressed: () {
                context.read<OTPBloc>().add(OTPVerifiedPressed());
              },
              child: Text(
                'verify and continue',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                    ),
              ),
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
            _getOtpUpdatedState(),
          ],
        ),
      ),
    );
  }

  Widget _getOtpUpdatedState() {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        OTPInput(textEditingController: _fieldOne, autoFocus: true),
        OTPInput(textEditingController: _fieldTwo, autoFocus: false),
        OTPInput(textEditingController: _fieldThree, autoFocus: false),
        OTPInput(textEditingController: _fieldFour, autoFocus: false),
      ],
    );
  }
}
