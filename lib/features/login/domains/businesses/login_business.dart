import 'package:dani/core/services/local_service.dart';
import 'package:dani/features/login/services/login_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user.dart';

class LoginBusiness {
  final LoginService loginService;
  final LocalService localService;

  LoginBusiness({
    required this.localService,
    required this.loginService,
  });

  Future<bool> login() async {
    GoogleSignInAccount? googleSignInAcc = await loginService.loginWithGmail();
    if (googleSignInAcc == null) {
      return false;
    }
    GoogleSignInAuthentication authen = await googleSignInAcc.authentication;
    if (authen.accessToken == null || authen.accessToken!.isEmpty) {
      return false;
    }
    return localService.saveUser(
      User(
        displayName: googleSignInAcc.displayName,
        email: googleSignInAcc.email,
        accessToken: authen.accessToken!,
        photoUrl: googleSignInAcc.photoUrl,
      ),
    );
  }
}
