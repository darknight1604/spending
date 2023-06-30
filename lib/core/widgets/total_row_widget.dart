import 'package:flutter/material.dart';
import 'package:dani/core/utils/extensions/text_style_extension.dart';
import '../utils/text_theme_util.dart';

class TotalRowWidget extends StatelessWidget {
  final String title;
  final String content;
  const TotalRowWidget({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextThemeUtil.instance.bodyMedium,
        ),
        Text(
          content,
          style: TextThemeUtil.instance.bodyMedium?.semiBold.copyWith(
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
