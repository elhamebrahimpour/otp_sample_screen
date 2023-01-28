abstract class AuthEvent {}

class CodeSentPressed extends AuthEvent {
  String phoneNumber;
  CodeSentPressed(this.phoneNumber);
}

class LoginPressed extends AuthEvent {
  String smsCode;
  LoginPressed(this.smsCode);
}

class LogoutPressed extends AuthEvent {}
