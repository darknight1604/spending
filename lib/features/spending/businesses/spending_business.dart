import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/extensions/date_time_extension.dart';
import 'package:dani/core/utils/iterable_util.dart';
import 'package:dani/core/utils/string_util.dart';
import 'package:dani/features/spending/services/spending_service.dart';

import '../businesses/models/group_spending_data.dart';
import '../businesses/models/spending.dart';
import '../businesses/models/spending_category.dart';
import '../businesses/models/spending_request.dart';

class SpendingBusiness {
  final SpendingService spendingService;

  late List<SpendingCategory> _listSpendingCategory = [];
  late List<Spending> _listSpending = [];

  SpendingBusiness(
    this.spendingService,
  );

  Future<List<GroupSpendingData>?> loadMoreListSpending() async {
    List<Spending> newList = await spendingService.loadMoreListSpending();
    if (IterableUtil.isNullOrEmpty(newList)) {
      return null;
    }
    _listSpending.addAll(newList);
    return _groupListSpendingByDate(_listSpending);
  }

  Future<List<GroupSpendingData>> getListSpending() async {
    _listSpending = await spendingService.getListSpending(
      limit: Constants.limitNumberOfItem,
    );
    return _groupListSpendingByDate(_listSpending);
  }

  List<GroupSpendingData> _groupListSpendingByDate(
    List<Spending> listSpending,
  ) {
    List<GroupSpendingData> result = [];
    GroupSpendingData groupSpendingData = GroupSpendingData();
    DateTime? base = null;
    for (var spending in listSpending) {
      if ((base != null && !base.isEqualByYYYYMMDD(spending.createdDate)) ||
          base == null) {
        base = spending.createdDate;
        groupSpendingData = GroupSpendingData(
          createdData: base,
          listSpending: [],
        );
        result.add(groupSpendingData);
      }
      if (base?.isEqualByYYYYMMDD(spending.createdDate) ?? false) {
        groupSpendingData.listSpending?.add(spending);
      }
    }
    return result;
  }

  Future<List<SpendingCategory>> getListSpendingCategory() async {
    if (_listSpendingCategory.isNotEmpty) return _listSpendingCategory;
    _listSpendingCategory = await spendingService.getListSpendingCategory();
    return _listSpendingCategory;
  }

  Future<bool> addSpendingRequest(SpendingRequest spendingRequest) async {
    if (StringUtil.isNullOrEmpty(spendingRequest.id)) {
      return spendingService.addSpendingRequest(spendingRequest);
    }
    return spendingService.updateSpendingRequest(spendingRequest);
  }

  Future<bool> deleteSpending(Spending spending) async {
    return spendingService.updateByRawJson(spending.toJson());
  }
}
