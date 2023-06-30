import 'package:flutter/material.dart';

import '../constants.dart';
import '../utils/text_theme_util.dart';
import 'package:dani/core/utils/extensions/text_style_extension.dart';

abstract class MyBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  MyBtn({
    required this.child,
    required this.onTap,
  });

  final Size minimumSize = Size(120, 50);
  final Size maximumSize = Size(300, 50);
}

class MyFilledBtn extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  MyFilledBtn({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MyFilledWithChildBtn(
      onTap: onTap,
      child: Text(
        title,
        style: TextThemeUtil.instance.bodyMedium?.semiBold.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

class MyFilledWithChildBtn extends MyBtn {
  MyFilledWithChildBtn({
    required super.onTap,
    required super.child,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.primary,
      minimumSize: minimumSize,
      maximumSize: maximumSize,
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Constants.radius)),
      ),
    ).copyWith(
      side: MaterialStateProperty.resolveWith<BorderSide>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed))
            return BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            );
          return BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ); // Defer to the widget's default.
        },
      ),
    );

    return OutlinedButton(
      style: outlineButtonStyle,
      onPressed: onTap,
      child: child,
    );
  }
}

class MyOutlineBtn extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  MyOutlineBtn({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MyOutlineWithChildBtn(
      onTap: onTap,
      child: Text(
        title,
        style: TextThemeUtil.instance.bodyMedium?.semiBold.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class MyOutlineWithChildBtn extends MyBtn {
  MyOutlineWithChildBtn({
    required super.child,
    required super.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
      foregroundColor: Constants.defaultTextColor,
      minimumSize: minimumSize,
      maximumSize: maximumSize,
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(Constants.radius)),
      ),
    ).copyWith(
      side: MaterialStateProperty.resolveWith<BorderSide>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed))
            return BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            );
          return BorderSide(
            color: Constants.borderColor,
          ); // Defer to the widget's default.
        },
      ),
    );

    return OutlinedButton(
      style: outlineButtonStyle,
      onPressed: onTap,
      child: child,
    );
  }
}
