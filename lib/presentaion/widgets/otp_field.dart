import 'package:blackcoffer_assignment/presentaion/consts.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpField extends StatefulWidget {
  const OtpField({
    super.key,
    this.lenght = 4,
    this.onCompleted,
    this.controller,
    this.onChanged,
  });

  final int lenght;
  final TextEditingController? controller;
  final void Function(String value)? onCompleted;
  final void Function(String value)? onChanged;

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField> {
  final controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  bool showError = false;
  @override
  Widget build(BuildContext context) {
    var length = widget.lenght;
    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    final errorColor = mainColorScheme.error;
    const fillColor = Color.fromRGBO(222, 231, 240, .57);
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 58,
      textStyle: const TextStyle(fontSize: 18),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return SizedBox(
      height: 58,
      child: Pinput(
        length: length,
        controller: widget.controller,
        focusNode: focusNode,
        defaultPinTheme: defaultPinTheme,
        onCompleted: widget.onCompleted,
        focusedPinTheme: defaultPinTheme.copyWith(
          width: 50,
          height: 60,
          decoration: defaultPinTheme.decoration!.copyWith(
            border: Border.all(color: borderColor),
          ),
        ),
        errorPinTheme: defaultPinTheme.copyWith(
          decoration: BoxDecoration(
            color: errorColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
