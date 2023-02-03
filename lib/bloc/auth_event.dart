abstract class AuthEvent {}

class CodeSentPressed extends AuthEvent {
  String phoneNumber;
  CodeSentPressed(this.phoneNumber);
}

class SignInPressed extends AuthEvent {
  String smsCode;
  SignInPressed(this.smsCode);
}

class SignOutPressed extends AuthEvent {}
