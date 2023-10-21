import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.firebaseAuth) : super(LoginInitial());

  User? currentUser;

  final FirebaseAuth firebaseAuth;
  StreamSubscription? subscription;

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }

  void initilize() {
    try {
      subscription = firebaseAuth.userChanges().listen((user) async {
        if (user == null) {
          return emit(LoginRequired());
        }
        try {
          await user.reload();
          emit(LoginSuccessfull(user: user));
        } on FirebaseAuthException catch (_) {
          
          await firebaseAuth.signOut().onError((error, stackTrace) => null);
          return emit(LoginRequired());
        }
      });
      emit(LoginInitialized());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void signIn(String phoneNumber) async {
    emit(const LoginLoading());
    if (kIsWeb) {
      var confirmation = await firebaseAuth.signInWithPhoneNumber(phoneNumber);
      return emit(LoginOTPRequired(XConfirmationResult.web(
        confirmationResult: confirmation,
        auth: firebaseAuth,
        phoneNumber: phoneNumber,
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
            auth: firebaseAuth,
            phoneNumber: phoneNumber,
            verificationId: verificationId,
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
  final String phoneNumber;

  final FirebaseAuth auth;

  XConfirmationResult.web({
    required this.confirmationResult,
    required this.auth,
    required this.phoneNumber,
  });
  XConfirmationResult.none({
    required this.auth,
    required this.phoneNumber,
  });
  XConfirmationResult.iosOrAndroid({
    required this.verificationId,
    required this.auth,
    required this.phoneNumber,
  });

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
