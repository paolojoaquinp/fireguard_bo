import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.onTap,
    required this.text,
    required this.secondaryText,
  });
  final VoidCallback onTap;
  final String text;
  final String secondaryText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: '$text\n',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        children: [
          TextSpan(
            text: secondaryText,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
