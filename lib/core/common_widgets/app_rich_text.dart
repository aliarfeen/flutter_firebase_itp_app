import 'package:flutter/material.dart';

class AppRichText extends StatelessWidget {
  const AppRichText({
    super.key,
    required this.originalText,
    required this.originalTextStyle,
    required this.highlightedText,
    required this.highlightedTextStyle,
    this.onTap,
  });

  final String originalText;
  final TextStyle originalTextStyle;
  final String highlightedText;
  final TextStyle highlightedTextStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text.rich(
        TextSpan(
          text: originalText,
          style: originalTextStyle,
          children: [
            TextSpan(text: highlightedText, style: highlightedTextStyle),
          ],
        ),
      ),
    );
  }
}
