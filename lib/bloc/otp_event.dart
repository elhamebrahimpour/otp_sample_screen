abstract class OTPEvent {}

class OTPVerifiedPressed extends OTPEvent {
  String? otp1;
  String? otp2;
  String? otp3;
  String? otp4;

  OTPVerifiedPressed({this.otp1, this.otp2, this.otp3, this.otp4});
}
