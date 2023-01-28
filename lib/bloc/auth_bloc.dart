import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/auth_state.dart';
import 'package:otp_sample_screen/di/firebase_di.dart';

class AuthBloc extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth = serviceLocator.get();
  String? _verificationId;

  AuthBloc() : super(AuthInitialState()) {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(AuthLoggedInState(user));
    } else {
      emit(AuthLoggedOutState());
    }
  }

  Future sendSmsCode(String phoneNumber) async {
    emit(AuthVerifingState());
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout:  Duration(seconds: 10),
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
  }

  Future verifyOTPCode(String otpCode) async {
    emit(AuthVerifingState());
    PhoneAuthCredential _creadential = PhoneAuthProvider.credential(
        verificationId: _verificationId!, smsCode: otpCode);
    signInWithPhoneNumber(_creadential);
  }

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

  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
      emit(AuthLoggedOutState());
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(e.message.toString()));
    }
  }
}
