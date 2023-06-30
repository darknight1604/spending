import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'utils/text_theme_util.dart';

class Constants {
  static const double iconSizeLarge = 100;

  static const String token = 'token';
  static const String empty = '--';

  static const double padding = 16.0;

  static const double spacingBetweenWidget = 12.0;

  static const String currencySymbol = 'VNĐ';

  static TextSpan redStar = TextSpan(
    text: StringPool.star,
    style: TextThemeUtil.instance.bodyMedium?.copyWith(color: Colors.red),
  );

  static Color disableColor = Colors.grey.shade400;

  static const Color defaultTextColor = Colors.black;

  static const double radius = 8.0;

  static Color borderColor = Colors.grey.shade400;

  static double iconSize = 24;

  static List<BoxShadow> shadow = [
    BoxShadow(
      color: Colors.blueGrey,
      offset: Offset(0, 1),
      blurRadius: 1,
    ),
  ];

  static const int maxLines = 3;

  static const String otherCategoryId = '-1';

  static const int limitNumberOfItem = 10;

  static Color scaffoldBackgroundColor = Colors.blueGrey.shade50;
  static NumberFormat nf = NumberFormat(null, 'vi_VI');
}

class JsonKeyConstants {
  static const String user = 'user';
  static const String isDeleted = 'isDeleted';
  static const String userEmail = 'userEmail';
  static const String index = 'index';
  static const String createdDate = 'createdDate';
  static const String id = 'id';
  static const String isConvertCreatedDate = 'isConvertCreatedDate';
}

class StringPool {
  static const String star = '*';
  static const String empty = '';
  static const String space = ' ';
  static const String comma = ',';
  static const String plus = '+';
}
