import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.firebaseAuth) : super(LoginInitial()) {
    firebaseAuth.userChanges().listen((event) {
      if (event == null) {
        return emit(LoginRequired());
      }
      emit(LoginSuccessfull(user: event));
    });
  }

  User? currentUser;

  final FirebaseAuth firebaseAuth;

  void signIn(String phoneNumber) async {
    emit(const LoginLoading());
    if (kIsWeb) {
      var confirmation = await firebaseAuth.signInWithPhoneNumber(phoneNumber);
      return emit(LoginOTPRequired(XConfirmationResult.web(
        confirmation,
        firebaseAuth,
      )));
    }
    if (Platform.isAndroid || Platform.isIOS) {
      await firebaseAuth.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
        verificationFailed: (FirebaseAuthException error) {
          debugPrint(error.message);
          if (error.code == 'unknown') {
            emit(LoginFailedConnection());
          }
        },
        codeSent: (verificationId, forceResendingToken) {
          emit(LoginOTPRequired(XConfirmationResult.iosOrAndroid(
            verificationId,
            firebaseAuth,
          )));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  void verifyCode(XConfirmationResult confirmationResult, String code) async {
    emit(const LoginLoading());

    try {
      var credential = await confirmationResult.verify(code);
      return emit(LoginSuccessfull(user: credential.user!));
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      debugPrint(e.code);
      return emit(OtpVerificationFailed(confirmationResult));
    }
  }
}

class XConfirmationResult {
  ConfirmationResult? confirmationResult;
  String? verificationId;

  final FirebaseAuth auth;

  XConfirmationResult.web(this.confirmationResult, this.auth);
  XConfirmationResult.none(this.auth);
  XConfirmationResult.iosOrAndroid(this.verificationId, this.auth);

  Future<UserCredential> verify(String code) async {
    if (kIsWeb) {
      return await confirmationResult!.confirm(code);
    }
    if (Platform.isAndroid || Platform.isAndroid) {
      return await auth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: code,
      ));
    }

    throw UnimplementedError();
  }
}
