import 'package:flutter/material.dart';

class TextThemeUtil {
  TextThemeUtil._internal();

  static TextThemeUtil? _instance;

  static TextThemeUtil get instance => _instance ??= TextThemeUtil._internal();

  void initial(BuildContext context) {
    titleLarge = Theme.of(context).textTheme.titleLarge;
    titleMedium = Theme.of(context).textTheme.titleMedium;
    titleSmall = Theme.of(context).textTheme.titleSmall;

    bodyLarge = Theme.of(context).textTheme.bodyLarge;
    bodyMedium = Theme.of(context).textTheme.bodyMedium;
    bodySmall = Theme.of(context).textTheme.bodySmall;
  }

  TextStyle? titleLarge;
  TextStyle? titleMedium;
  TextStyle? titleSmall;

  TextStyle? bodyLarge;
  TextStyle? bodyMedium;
  TextStyle? bodySmall;
}
