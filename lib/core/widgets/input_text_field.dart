import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/extensions/text_style_extension.dart';
import 'package:dani/core/utils/string_util.dart';
import 'package:dani/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/text_theme_util.dart';

class InputTextField extends StatelessWidget {
  final int? maxLines;
  final String? labelText;
  final String? hintText;
  final Widget? hintWidget;
  final Widget? labelWidget;
  final TextEditingController? controller;
  final void Function(String value)? onChanged;
  final String? prefixText;
  final String? suffixText;
  final TextInputType? keyboardType;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool? isRequired;
  final TextInputAction? textInputAction;

  const InputTextField({
    super.key,
    this.maxLines,
    this.labelText,
    this.controller,
    this.onChanged,
    this.prefixText,
    this.keyboardType,
    this.suffixText,
    this.onSaved,
    this.validator,
    this.hintText,
    this.hintWidget,
    this.labelWidget,
    this.isRequired = false,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextThemeUtil.instance.bodyMedium,
      maxLines: maxLines,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSaved: onSaved,
      validator: validator ?? _onValidator,
      decoration: InputDecoration(
        // border: InputBorder()
        alignLabelWithHint: true,
        hintText: hintText,
        hintStyle: TextThemeUtil.instance.bodyMedium?.regular.disable,
        label: labelWidget,
        labelText: labelText,
        labelStyle: TextThemeUtil.instance.bodyMedium?.regular,
        prefixText: prefixText,
        prefixStyle: TextThemeUtil.instance.bodyMedium?.regular.disable,
        suffixText: suffixText,
        suffixStyle: TextThemeUtil.instance.bodyMedium?.regular.disable,
        contentPadding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Constants.borderColor),
          borderRadius: BorderRadius.circular(Constants.radius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  String? _onValidator(String? value) {
    if ((isRequired ?? false) && StringUtil.isNullOrEmpty(value)) {
      return tr(LocaleKeys.common_requireField);
    }
    return null;
  }
}
