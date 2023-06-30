import 'package:dani/core/app_route.dart';
import 'package:dani/core/constants.dart';
import 'package:dani/gen/assets.gen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dani/core/utils/extensions/text_style_extension.dart';
import '../../../core/utils/text_theme_util.dart';
import '../../../core/widgets/my_btn.dart';
import '../../../gen/locale_keys.g.dart';
import '../applications/login/login_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(GetIt.I.get()),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailState) {
              print('LoginFailState');
            }
            if (state is LoginSuccessState) {
              Navigator.pushReplacementNamed(context, AppRoute.homeScreen);
            }
          },
          child: _BodyScreen(),
        ),
      ),
    );
  }
}

class _BodyScreen extends StatelessWidget {
  const _BodyScreen();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.blue),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double marginTop = constraints.maxHeight / 6;
                    return SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: EdgeInsets.only(top: marginTop),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                Assets.images.icLauncher.provider(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white),
                child: SizedBox(
                  width: double.infinity,
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 200, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.radius),
            boxShadow: Constants.shadow,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  tr(LocaleKeys.common_welcomeTitle),
                  style: TextThemeUtil.instance.titleLarge?.semiBold,
                ),
                MyOutlineWithChildBtn(
                  onTap: () {
                    BlocProvider.of<LoginBloc>(context).add(
                      LoginWithGmailEvent(),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Assets.images.icGmail.image(width: Constants.iconSize),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(
                        tr(LocaleKeys.loginScreen_continueWithGmail),
                        style: TextThemeUtil.instance.bodyMedium?.regular,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
