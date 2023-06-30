import 'dart:convert';

import 'package:dani/core/constants.dart';
import 'package:dani/core/repositories/local/local_repository.dart';
import 'package:dani/core/utils/string_util.dart';

import '../../features/login/domains/models/user.dart';

class LocalService {
  final LocalRepository localRepository;

  LocalService(
    this.localRepository,
  );

  Future<bool> saveUser(User user) async {
    return await localRepository.setString(
        JsonKeyConstants.user, jsonEncode(user.toJson()));
  }

  Future<User?> getUser() async {
    String str = await localRepository.getString(JsonKeyConstants.user);
    if (StringUtil.isNullOrEmpty(str)) return null;
    return User.fromJson(jsonDecode(str));
  }

  Future<bool> logout() async {
    final sharePref = await localRepository.getPref();
    return await sharePref.remove(JsonKeyConstants.user);
  }

  Future<bool> isConvertCreatedDate() async =>
      await localRepository.getBool(JsonKeyConstants.isConvertCreatedDate);

  Future<bool> checkConvertCreatedDate(bool value) async =>
      await localRepository.setBool(
          JsonKeyConstants.isConvertCreatedDate, value);
}
