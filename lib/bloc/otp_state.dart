abstract class OTPState {}

class OTPInitial extends OTPState {
  final String? otp;
  OTPInitial({this.otp});
}

class OTPVerifiedState extends OTPState {
  String? otp;
  OTPVerifiedState({this.otp});
}
