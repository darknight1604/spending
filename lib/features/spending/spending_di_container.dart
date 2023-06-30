import 'package:dani/dependency_container.dart';
import 'package:dani/features/spending/spending_route.dart';
import 'package:get_it/get_it.dart';

import '../../core/app_route.dart';
import '../../core/services/background_service.dart';
import 'applications/spending_listing/spending_listing_bloc.dart';
import 'businesses/spending_business.dart';
import 'services/background_service.dart';
import 'services/spending_service.dart';

class SpendingDiContainer extends DiContainer {
  @override
  void setup(GetIt instance) {
    /// Services
    instance.registerLazySingleton<SpendingService>(
      () => SpendingService(instance.get()),
    );
    instance.registerLazySingleton<SpendingBackgroundService>(
      () => SpendingBackgroundService(instance.get(), instance.get()),
    );

    /// Businesses
    ///
    instance.registerLazySingleton<SpendingBusiness>(
      () => SpendingBusiness(instance.get()),
    );

    /// Blocs
    instance.registerFactory<SpendingListingBloc>(
      () => SpendingListingBloc(instance.get()),
    );

    /// Route
    instance.registerLazySingleton<SpendingRoute>(
      () => SpendingRoute(),
    );
    instance.get<FeatureRouteFactory>().register(instance.get<SpendingRoute>());

    ///
    instance.get<DaniBackgroundService>().register(instance.get<SpendingBackgroundService>());
  }
}
