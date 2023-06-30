import 'package:dani/core/app_config.dart';
import 'package:dani/core/services/background_service.dart';

import '../../../core/services/local_service.dart';
import '../businesses/models/spending.dart';
import 'spending_service.dart';

class SpendingBackgroundService extends BackgroundService {
  final SpendingService spendingService;
  final LocalService localService;

  SpendingBackgroundService(
    this.spendingService,
    this.localService,
  );

  @override
  Future<void> perform() async {
    if (AppConfig.instance.isConvertCreatedDate) {
      return;
    }
    List<Spending> listSpending = await spendingService.getListSpending();
    if (listSpending.isEmpty) return;
    listSpending.forEach((element) {
      spendingService.updateByRawJson(element.toJson());
    });
    localService.checkConvertCreatedDate(true);
  }
}
