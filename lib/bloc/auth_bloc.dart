import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/auth_event.dart';
import 'package:otp_sample_screen/bloc/auth_state.dart';
import 'package:otp_sample_screen/di/firebase_di.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = serviceLocator.get();
  String? _verificationId;

  AuthBloc() : super(AuthInitialState()) {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(AuthLoggedInState(user));
    } else {
      emit(AuthLoggedOutState());
    }

    on<CodeSentPressed>(_sendCode);

    on<SignInPressed>(_signIn);

    on<SignOutPressed>(_signOut);
  }

  Future<void> _sendCode(event, emit) async {
    emit(AuthVerifingState());
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: event.phoneNumber,
      timeout: Duration(seconds: 6),
      verificationCompleted: (PhoneAuthCredential authCredential) {
        signInWithPhoneNumber(authCredential);
      },
      verificationFailed: ((error) {
        emit(AuthErrorState(error.message.toString()));
      }),
      codeSent: ((verificationId, forceResendingToken) {
        emit(AuthCodeSentState());
      }),
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
    emit(AuthCodeSentState());
  }

  Future<void> _signIn(event, emit) async {
    emit(AuthVerifingState());
    PhoneAuthCredential _creadential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: event.smsCode);
    signInWithPhoneNumber(_creadential);
  }

  Future<void> _signOut(event, emit) async {
    await _firebaseAuth.signOut();
    emit(AuthLoggedOutState());
  }

//use phone credential to signin to the app
  Future<void> signInWithPhoneNumber(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(AuthLoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    }
  }
}
