import '../../../../core/utils/iterable_util.dart';
import '../../../spending/businesses/models/spending.dart';

/// Purpose of this class is group list spending by CategoryId
class GroupSpendingDataByCategoryId implements Comparable {
  String? categoryId;
  String? categoryName;
  List<Spending>? listSpending;
  double? percent;

  GroupSpendingDataByCategoryId({
    this.categoryId,
    this.categoryName,
    this.listSpending,
    this.percent = 0,
  });

  GroupSpendingDataByCategoryId.init();

  int get total {
    if (IterableUtil.isNullOrEmpty(listSpending)) return 0;
    return listSpending!
        .map(
          (e) => e.cost ?? 0,
        )
        .reduce((value, element) => value + element);
  }

  @override
  String toString() {
    return 'categoryId: $categoryId, categoryName: $categoryName, listSpending: $listSpending\n';
  }

  @override
  int compareTo(other) {
    if (other is! GroupSpendingDataByCategoryId) return -1;
    double otherPercent = other.percent ?? 0;
    double currentPercent = percent ?? 0;
    if (otherPercent > currentPercent) return -1;
    if (otherPercent < currentPercent) return 1;
    return 0;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GroupSpendingDataByCategoryId &&
        other.categoryId == categoryId &&
        other.categoryId == categoryName;
  }
}
