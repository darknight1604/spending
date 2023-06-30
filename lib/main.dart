import 'package:dani/core/app_config.dart';
import 'package:dani/core/app_route.dart';
import 'package:dani/core/services/background_service.dart';
import 'package:dani/core/utils/text_theme_util.dart';
import 'package:dani/dependency_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'core/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  DependencyContainer.setup(GetIt.instance);
  await AppConfig.instance.initial();

  await GetIt.I.get<DaniBackgroundService>().perform();

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('vi'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextThemeUtil.instance.initial(context);
    return MaterialApp(
      title: 'Flutter Demo',
      supportedLocales: [
        Locale('en'),
        Locale('vi'),
      ],
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      initialRoute: AppRoute.initialRoute(AppConfig.instance),
      onGenerateRoute: AppRoute.onGenerateRoute,
      theme: ThemeData(
        fontFamily: 'NotoSans',
        primaryColor: Colors.blue,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: Constants.defaultTextColor,
            fontSize: 28,
          ),
          titleMedium: TextStyle(
            color: Constants.defaultTextColor,
            fontSize: 24,
          ),
          titleSmall: TextStyle(
            color: Constants.defaultTextColor,
            fontSize: 20,
          ),
          bodySmall: TextStyle(
            color: Constants.defaultTextColor,
            fontSize: 12,
          ),
          bodyMedium: TextStyle(
            color: Constants.defaultTextColor,
            fontSize: 14,
          ),
          bodyLarge: TextStyle(
            color: Constants.defaultTextColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
