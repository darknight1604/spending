import 'package:flutter/material.dart';

import '../../constants.dart';

extension TextStyleExtension on TextStyle {
  TextStyle get disable => this.copyWith(color: Constants.disableColor);

  TextStyle get regular => this.copyWith(fontWeight: FontWeight.w400);
  TextStyle get semiBold => this.copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => this.copyWith(fontWeight: FontWeight.w700);
}
