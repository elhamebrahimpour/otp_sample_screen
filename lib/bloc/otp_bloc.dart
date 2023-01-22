import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_sample_screen/bloc/otp_event.dart';
import 'package:otp_sample_screen/bloc/otp_state.dart';

class OTPBloc extends Bloc<OTPEvent, OTPState> {
  String otp = 'verified';
  OTPBloc() : super(OTPInitial(otp: 'The code will expired after: ')) {
    on<OTPVerifiedPressed>(
      (event, emit) => emit(
        OTPVerifiedState(otp: otp),
      ),
    );
  }
}
