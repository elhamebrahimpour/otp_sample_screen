import 'package:flutter/material.dart';
import 'package:otp_sample_screen/constants/custom_colors.dart';

class OTPPinInput extends StatelessWidget {
  OTPPinInput(
      {super.key,
      required this.textEditingController,
      required this.autoFocus});
  final TextEditingController textEditingController;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      width: 48,
      child: TextField(
        autofocus: autoFocus,
        controller: textEditingController,
        textAlign: TextAlign.center,
        maxLines: 1,
        keyboardType: TextInputType.number,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          counterText: '',
          hintStyle: TextStyle(
            color: CustomColors.secondColor,
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        onChanged: (value) {
          value.length == 1
              ? FocusScope.of(context).nextFocus()
              : value.isEmpty
                  ? FocusScope.of(context).previousFocus()
                  : null;
        },
      ),
    );
  }
}
