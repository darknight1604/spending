import 'package:dani/core/app_config.dart';
import 'package:dani/core/app_route.dart';
import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/extensions/text_style_extension.dart';
import 'package:dani/core/widgets/my_btn.dart';
import 'package:dani/features/login/domains/models/user.dart';
import 'package:dani/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/utils/text_theme_util.dart';
import '../../../core/widgets/my_cache_image.dart';
import '../../dashboard/presentations/dashboard_screen.dart';
import '../../spending/presentations/spending_listing_screen.dart';
import '../applications/cubit/home_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(GetIt.I.get())..fetchUser(),
        ),
      ],
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeLogoutSuccessState) {
            AppRoute.pushReplacement(context, AppRoute.loginScreen);
            return;
          }
        },
        child: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                tr(LocaleKeys.common_appName),
                style: TextThemeUtil.instance.titleMedium?.semiBold
                    .copyWith(color: Colors.white),
              ),
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.trending_up_outlined),
                  ),
                  Tab(
                    icon: Icon(Icons.receipt_outlined),
                  ),
                ],
              ),
            ),
            drawer: _MyDrawer(),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                DashboardScreen(),
                SpendingListingScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    color: Theme.of(context).primaryColor,
                    child: BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        User? user;
                        if (state is HomeCurrentUserState) {
                          user = state.user;
                        }
                        double avtSize = 30;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Constants.padding,
                          ),
                          child: Row(
                            children: [
                              MyCacheImage(
                                imageUrl: user?.photoUrl ?? StringPool.empty,
                                imageBuilder: (context, imageProvider) {
                                  return CircleAvatar(
                                    radius: avtSize,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: imageProvider,
                                  );
                                },
                              ),
                              SizedBox(
                                width: Constants.padding,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tr(LocaleKeys.common_welcomeTitle),
                                      style: TextThemeUtil
                                          .instance.bodyMedium?.regular
                                          .copyWith(color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: Constants.padding,
                                    ),
                                    Text(
                                      user?.displayName ?? StringPool.empty,
                                      style: TextThemeUtil
                                          .instance.titleMedium?.semiBold
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        tr(LocaleKeys.common_featureWorkInProgress),
                        style: TextThemeUtil.instance.titleMedium?.regular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MyFilledWithChildBtn(
              onTap: () {
                BlocProvider.of<HomeCubit>(context).logout();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: Colors.white,
                    size: Constants.iconSize,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    tr(LocaleKeys.common_logout),
                    style: TextThemeUtil.instance.bodyMedium?.semiBold
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Constants.padding,
            ),
            Text(
              tr(
                LocaleKeys.common_version,
                args: [
                  AppConfig.instance.version,
                ],
              ),
              style: TextThemeUtil.instance.bodyMedium?.copyWith(color: Constants.disableColor,),
            ),
            SizedBox(
              height: Constants.padding,
            ),
          ],
        ),
      ),
    );
  }
}
