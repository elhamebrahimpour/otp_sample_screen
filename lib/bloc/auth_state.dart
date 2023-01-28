import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthVerifingState extends AuthState {}

class AuthCodeSentState extends AuthState {}

class AuthLoggedInState extends AuthState {
  final User firbaseUser;
  AuthLoggedInState(this.firbaseUser);
}

class AuthLoggedOutState extends AuthState {}

class AuthErrorState extends AuthState {
  String message;
  AuthErrorState(this.message);
}
