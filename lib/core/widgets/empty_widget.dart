import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/extensions/text_style_extension.dart';
import 'package:dani/core/utils/text_theme_util.dart';
import 'package:dani/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.report_gmailerrorred_outlined,
            size: Constants.iconSize,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: Constants.padding,
          ),
          Text(
            tr(LocaleKeys.common_emptyData),
            style: TextThemeUtil.instance.bodyLarge?.regular,
          ),
        ],
      ),
    );
  }
}
