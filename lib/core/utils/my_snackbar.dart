import 'package:dani/core/utils/extensions/text_style_extension.dart';
import 'package:dani/core/utils/text_theme_util.dart';
import 'package:flutter/material.dart';

class MySnackBarUtil {
  static void show(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        showCloseIcon: true,
        closeIconColor: Colors.white,
        content: Text(
          title,
          style: TextThemeUtil.instance.bodyMedium?.regular.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
