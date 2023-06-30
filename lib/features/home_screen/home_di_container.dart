import 'package:dani/dependency_container.dart';
import 'package:get_it/get_it.dart';

import '../../core/app_route.dart';
import 'home_route.dart';

class HomeDiContainer extends DiContainer {
  @override
  void setup(GetIt instance) {
    /// Route
    instance.registerLazySingleton<HomeRoute>(
      () => HomeRoute(),
    );
    instance.get<FeatureRouteFactory>().register(instance.get<HomeRoute>());
  }
}
