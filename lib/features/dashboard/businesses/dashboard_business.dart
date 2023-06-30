import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/extensions/date_time_extension.dart';
import 'package:dani/core/utils/firestore/firestore_query.dart';
import 'package:dani/core/utils/iterable_util.dart';
import 'package:dani/features/spending/businesses/models/spending.dart';
import 'package:dani/features/spending/services/spending_service.dart';

import 'models/group_spending_data_by_category_id.dart';
import 'models/spending_pie_chart_data.dart';

class DashboardBusiness {
  final SpendingService spendingService;

  DashboardBusiness(this.spendingService);

  Future<SpendingPieChartData> initData(
    DateTime startDate,
    DateTime endDate,
  ) async {
    List<Spending> listSpendingInMonth = await spendingService.getListSpending(
      queries: [
        FirestoreQueryGreaterThanOrEqualTo(
          JsonKeyConstants.createdDate,
          [startDate.beginOfDate],
        ),
        FirestoreQueryLessThanOrEqualTo(
          JsonKeyConstants.createdDate,
          [endDate.endOfDate],
        ),
      ],
    );
    int total = 0;
    List<GroupSpendingDataByCategoryId> listData = [];
    var biggest = GroupSpendingDataByCategoryId.init();
    var smallest = GroupSpendingDataByCategoryId.init();
    int maximumCost = 0;
    int minimumCost = -1;

    // Group list spending by categoryId
    for (var spending in listSpendingInMonth) {
      int cost = spending.cost ?? 0;
      total += cost;
      final listTemp = listData.where(
        (element) => element.categoryId == spending.categoryId,
      );
      if (IterableUtil.isNullOrEmpty(listTemp)) {
        GroupSpendingDataByCategoryId group = GroupSpendingDataByCategoryId(
          categoryId: spending.categoryId,
          categoryName: spending.categoryName,
          listSpending: [spending],
        );
        listData.add(group);
        continue;
      }
      GroupSpendingDataByCategoryId group = listTemp.first;
      group.listSpending?.add(spending);
    }

    // Calculate percent of each group category & find biggest spending group
    double tempPercent = 0;
    for (var groupData in listData) {
      int totalEachGroupData = groupData.total;
      //Find the biggest
      if (totalEachGroupData > maximumCost) {
        maximumCost = totalEachGroupData;
        biggest = groupData;
      }
      // Find the smallest
      if (minimumCost == -1) {
        minimumCost = totalEachGroupData;
        smallest = groupData;
      }
      if (minimumCost > totalEachGroupData) {
        minimumCost = totalEachGroupData;
        smallest = groupData;
      }
      
      // Calculate percent
      double percent = double.tryParse(
            (totalEachGroupData * 100 / total).toDouble().toStringAsFixed(2),
          ) ??
          0;
      if (listData.last == groupData) {
        groupData.percent = double.tryParse(
                (100 - tempPercent).toDouble().toStringAsFixed(2)) ??
            0;
        continue;
      }
      tempPercent += percent;
      groupData.percent = percent;
    }
    listData.sort((a, b) => a.compareTo(b));

    return SpendingPieChartData(
      total,
      listData,
      biggest,
      smallest,
    );
  }
}
