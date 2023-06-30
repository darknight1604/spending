import 'package:dani/core/app_route.dart';
import 'package:flutter/src/material/page.dart';

import 'businesses/models/spending.dart';
import 'presentations/spending_screen.dart';

class SpendingRoute extends FeatureRoute {
  @override
  MaterialPageRoute generateRoute(Object? arguments) {
    return MaterialPageRoute(builder: (context) {
      Spending? spending =
          arguments != null && arguments is Spending ? arguments : null;
      return SpendingScreen(
        spending: spending,
      );
    });
  }

  @override
  String get routeName => '/spendingScreen';
}
