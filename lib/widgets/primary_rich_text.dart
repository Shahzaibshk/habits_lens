import 'package:flutter/material.dart';

import '../utils/app_textstyle.dart';

class PrimaryRichText extends StatelessWidget {
  const PrimaryRichText({
    super.key,
    required this.text,
    required this.linkedText,
    this.textstyle = AppTextstyle.mdSemiBold,
    this.linktextstyle = AppTextstyle.greenStyle,
  });

  final String text;
  final String linkedText;
  final TextStyle? textstyle;
  final TextStyle? linktextstyle;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: linkedText, style: linktextstyle),
          TextSpan(text: text, style: textstyle),
        ],
      ),
    );
  }
}
