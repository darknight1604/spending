import 'package:dani/dependency_container.dart';
import 'package:get_it/get_it.dart';

import '../../core/app_route.dart';
import 'applications/spending_dashboard/spending_dashboard_bloc.dart';
import 'businesses/dashboard_business.dart';
import 'dashboard_route.dart';

class DashboardDiContainer extends DiContainer {
  @override
  void setup(GetIt instance) {
    /// Services

    /// Businesses
    ///
    instance.registerLazySingleton<DashboardBusiness>(
      () => DashboardBusiness(instance.get()),
    );

    /// Blocs

    instance.registerFactory<SpendingDashboardBloc>(
      () => SpendingDashboardBloc(instance.get()),
    );

    /// Route
    instance.registerLazySingleton<DashboardRoute>(
      () => DashboardRoute(),
    );
    instance
        .get<FeatureRouteFactory>()
        .register(instance.get<DashboardRoute>());
  }
}
