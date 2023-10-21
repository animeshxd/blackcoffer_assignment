import 'dart:async';

import 'package:blackcoffer_assignment/presentaion/widgets/auth_aware.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';

import '../application/auth/login_cubit.dart';
import 'consts.dart';
import 'home_page.dart';
import 'signin_phone.dart';
import 'widgets/logo.dart';
import 'widgets/otp_field.dart';
import 'widgets/rounded_elevated_button.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Material App',
//       theme: ThemeData.from(colorScheme: mainColorScheme),
//       home: OTPPage(
//         confirmationResult: XConfirmationResult.none(FirebaseAuth.instance),
//         phoneNumber: '+919064510870',
//       ),
//     );
//   }
// }

class OTPPage extends StatefulWidget {
  const OTPPage({
    super.key,
    required this.confirmationResult,
  });

  /// XConfirmationResult as extra
  static const path = '/otp';

  final XConfirmationResult confirmationResult;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final otpController = TextEditingController();
  late XConfirmationResult confirmationResult = widget.confirmationResult;
  late final LoginCubit loginCubit;
  final errorText = RxnString();
  @override
  void initState() {
    super.initState();
    loginCubit = context.read();
  }

  @override
  Widget build(BuildContext context) {
    var viewSize = MediaQuery.of(context).size;
    var vh = viewSize.height;
    return SafeArea(
      child: AuthAware(
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            switch (state) {
              case LoginOTPRequired(confirmationResult: var cResult):
                confirmationResult = cResult;
                break;
              case OtpVerificationFailed(confirmationResult: var cResult):
                confirmationResult = cResult;
                break;
              default:
            }
          },
          builder: (context, state) {
            if (state is OtpVerificationFailed) {
              errorText.value = 'Invalid code';
            } else {
              errorText.value = null;
            }
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () => goToSignInPage(context),
                mini: true,
                child: const Icon(Icons.edit),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: vh * .28,
                        child: const Center(child: Logo()),
                      ),
                      const Text("Enter OTP"),
                      const SizedBox(height: 12),
                      OtpField(
                        controller: otpController,
                        lenght: 6,
                      ),
                      if (errorText.value != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 5),
                          child: Text(
                            errorText.value!,
                            style: TextStyle(color: mainColorScheme.error),
                          ),
                        ),
                      const SizedBox(height: 12),
                      OTPResendButtonTimer(
                        duration: 60,
                        resetHandler: true.obs,
                        onResendClicked: onResendClicked,
                      ),
                      SizedBox(
                        height: vh * .15,
                        child: Align(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: RoundedElevatedTextButton(
                              onPressed: () => _verifyOTP(context),
                              text: 'Get Started',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _verifyOTP(BuildContext context) => context
      .read<LoginCubit>()
      .verifyCode(confirmationResult, otpController.text);

  void onResendClicked() {
    otpController.clear();
    context.read<LoginCubit>().signIn(widget.confirmationResult.phoneNumber);
  }

  void goToHomePage(BuildContext context) => context.replace(HomePage.path);
  void goToSignInPage(BuildContext context) =>
      context.replace(SignInPage.pathWithForced);
}

class OTPResendButtonTimer extends StatefulWidget {
  const OTPResendButtonTimer({
    super.key,
    required this.duration,
    required this.resetHandler,
    required this.onResendClicked,
  });
  final int duration;
  final RxBool resetHandler;
  final void Function()? onResendClicked;
  @override
  State<OTPResendButtonTimer> createState() => _OTPResendButtonTimerState();
}

class _OTPResendButtonTimerState extends State<OTPResendButtonTimer> {
  late var counter = widget.duration.obs;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    setTimer();
    widget.resetHandler.stream.listen((event) => setTimer());
  }

  Timer? setTimer() {
    counter.value = widget.duration;
    timer?.cancel();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => counter.value == 0 ? timer.cancel() : counter--,
    );
    return timer!;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        const Text('Did not get OTP?'),
        Obx(
          () => TextButton(
            onPressed: counter.value == 0 ? _resendOTPAndResetTimer : null,
            child: const Text(
              'Resend',
              style: TextStyle(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        Obx(() => Text(counter.value > 0 ? '( ${counter.value} )' : ''))
      ],
    );
  }

  void _resendOTPAndResetTimer() {
    setTimer();
    widget.onResendClicked?.call();
  }
}
