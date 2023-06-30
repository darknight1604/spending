import 'package:dani/features/spending/spending_di_container.dart';
import 'package:get_it/get_it.dart';

import 'core/core_dependency_container.dart';
import 'features/dashboard/dashboard_di_container.dart';
import 'features/home_screen/home_di_container.dart';
import 'features/login/login_di_container.dart';

abstract class DiContainer {
  void setup(GetIt instance);
}

class DependencyContainer {
  static void setup(GetIt instance) {
    CoreDependencyContainer.setup(instance);

    /// Features
    HomeDiContainer().setup(instance);
    SpendingDiContainer().setup(instance);
    LoginDiContainer().setup(instance);
    DashboardDiContainer().setup(instance);
  }
}
