import 'package:flutter/material.dart';
import '../consts.dart';

class RoundedElevatedTextButton extends StatelessWidget {
  const RoundedElevatedTextButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(300, 45),
        shape: RoundedRectangleBorder(
          borderRadius: buttonBorderRadius,
        ),
        padding: buttonPadding,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
