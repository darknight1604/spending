import 'dart:convert';

import 'package:dani/core/constants.dart';
import 'package:dani/core/services/local_service.dart';
import 'package:dani/core/utils/string_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import '../features/login/domains/models/user.dart';

import 'package:package_info_plus/package_info_plus.dart';

class AppConfig {
  late String? _token;

  AppConfig._internal() {
    _token = null;
  }
  late AppConfigData? appConfigData;
  static AppConfig? _instance;

  static AppConfig get instance => _instance ??= AppConfig._internal();

  final String _keyIsDevelop = 'isDevelop';
  final String _keyEnvironment = 'environment';
  final String _keyDevPath = 'devPath';
  final String _keyProdPath = 'prodPath';

  late bool _isConvertCreatedDate = false;
  late String _version = StringPool.empty;
  late String _buildNumber = StringPool.empty;

  Future<void> initial() async {
    LicenseRegistry.addLicense(() async* {
      final license = await rootBundle.loadString('google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });
    final localService = GetIt.I.get<LocalService>();
    _isConvertCreatedDate = await localService.isConvertCreatedDate();
    User? user = await localService.getUser();
    _token = user?.accessToken ?? StringPool.empty;

    final configStr = await rootBundle.loadString('assets/configs/config.json');
    Map<String, dynamic> jsonConfig = jsonDecode(configStr);
    appConfigData = AppConfigData(
      jsonConfig[_keyIsDevelop],
      _Environment(
        jsonConfig[_keyEnvironment][_keyDevPath],
        jsonConfig[_keyEnvironment][_keyProdPath],
      ),
    );

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    _version = packageInfo.version;
    _buildNumber = packageInfo.buildNumber;
  }

  bool get isLogged => StringUtil.isNotNullOrEmpty(_token);
  bool get isConvertCreatedDate => _isConvertCreatedDate;

  String get version {
    if (appConfigData?.isDevelop ?? true) {
      return '$_version${StringPool.plus}$buildNumber';
    }
    return _version;
  }

  String get buildNumber => _buildNumber;
}

class AppConfigData {
  final bool isDevelop;
  final _Environment environment;
  AppConfigData(this.isDevelop, this.environment);
}

class _Environment {
  final String? devPath;
  final String? prodPath;

  _Environment(this.devPath, this.prodPath);
}
