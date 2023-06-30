import 'package:dani/core/app_route.dart';
import 'package:flutter/src/material/page.dart';

import 'presentations/login_screen.dart';

class LoginRoute extends FeatureRoute {
  @override
  MaterialPageRoute generateRoute(Object? arguments) {
    return MaterialPageRoute(builder: (context) => const LoginScreen());
  }

  @override
  String get routeName => '/loginScreen';
}
