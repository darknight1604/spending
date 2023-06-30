import 'package:equatable/equatable.dart';

import 'group_spending_data_by_category_id.dart';

/// This class contain total cost in a month and a
/// list of Spending Category
class SpendingPieChartData extends Equatable {
  final int total;
  final List<GroupSpendingDataByCategoryId> listCategoryData;
  final GroupSpendingDataByCategoryId biggest;
  final GroupSpendingDataByCategoryId smallest;

  SpendingPieChartData(
    this.total,
    this.listCategoryData,
    this.biggest,
    this.smallest,
  );

  @override
  List<Object?> get props => [total, listCategoryData];
}
