import 'package:dani/core/utils/iterable_util.dart';
import 'package:dani/core/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'app_config.dart';

class AppRoute {
  AppRoute._();
  static const String loginScreen = "/loginScreen";

  static const String homeScreen = "/homeScreen";

  static String initialRoute(AppConfig appConfig) {
    if (appConfig.isLogged) {
      return homeScreen;
    }
    return loginScreen;
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    String? routeName = settings.name;
    Object? arguments = settings.arguments;
    if (StringUtil.isNullOrEmpty(routeName)) return null;
    return GetIt.I.get<FeatureRouteFactory>().generateRoute(
          routeName!,
          arguments,
        );
  }

  static pushReplacement(BuildContext context, final String name,
      {final Object? arguments}) {
    Navigator.of(context).popUntil((route) => route.isFirst);

    final Route<dynamic>? newRoute = onGenerateRoute(
      RouteSettings(
        name: name,
        arguments: arguments,
      ),
    );
    if (newRoute != null) {
      Navigator.pushReplacement(
        context,
        newRoute,
      );
    }
  }
}

class FeatureRouteFactory {
  final List<FeatureRoute> listFeatureRoute = [];

  void register(FeatureRoute featureRoute) {
    listFeatureRoute.add(featureRoute);
  }

  Route<dynamic>? generateRoute(String routeName, Object? arguments) {
    if (IterableUtil.isNullOrEmpty(listFeatureRoute)) return null;
    final listTemp = listFeatureRoute.where(
      (element) => element.routeName == routeName,
    );
    if (IterableUtil.isNullOrEmpty(listTemp)) return null;
    return listTemp.first.generateRoute(arguments);
  }
}

abstract class FeatureRoute {
  FeatureRoute();
  MaterialPageRoute<dynamic> generateRoute(Object? arguments);

  @mustCallSuper
  String get routeName;
}
