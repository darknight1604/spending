import 'package:dani/core/app_route.dart';
import 'package:flutter/src/material/page.dart';

import 'presentations/dashboard_screen.dart';

class DashboardRoute extends FeatureRoute {
  @override
  MaterialPageRoute generateRoute(Object? arguments) {
    return MaterialPageRoute(builder: (context) {
      return DashboardScreen();
    });
  }

  @override
  String get routeName => '/dashboardScreen';
}
