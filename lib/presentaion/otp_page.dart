import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'consts.dart';
import 'widgets/logo.dart';
import 'widgets/otp_field.dart';
import 'widgets/rounded_elevated_button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData.from(colorScheme: mainColorScheme),
      home: const OTPPage(),
    );
  }
}

class OTPPage extends StatelessWidget {
  const OTPPage({super.key});

  @override
  Widget build(BuildContext context) {
    var viewSize = MediaQuery.of(context).size;
    var vh = viewSize.height;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _editPhoneNumber,
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
                const OtpField(lenght: 6),
                const SizedBox(height: 12),
                OTPResendButtonTimer(duration: 60, resetHandler: true.obs),
                SizedBox(
                  height: vh * .15,
                  child: Align(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: RoundedElevatedTextButton(
                        onPressed: _verifyOTP,
                        text: 'Get Started',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _editPhoneNumber() {}
  void _verifyOTP() {}
}

class OTPResendButtonTimer extends StatefulWidget {
  const OTPResendButtonTimer({
    super.key,
    required this.duration,
    required this.resetHandler,
  });
  final int duration;
  final RxBool resetHandler;
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
  }
}
