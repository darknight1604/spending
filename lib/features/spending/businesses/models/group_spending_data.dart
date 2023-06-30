import 'package:dani/core/utils/iterable_util.dart';
import 'package:equatable/equatable.dart';

import 'spending.dart';

class GroupSpendingData extends Equatable {
  final DateTime? createdData;
  final List<Spending>? listSpending;

  GroupSpendingData({
    this.createdData,
    this.listSpending,
  });

  int get totalPerDay {
    if (IterableUtil.isNullOrEmpty(listSpending)) return 0;
    return listSpending!
        .map((element) => element.cost ?? 0)
        .reduce((value, element) => value + element);
  }

  GroupSpendingData copyWith({
    DateTime? createdData,
    List<Spending>? listSpending,
  }) {
    return GroupSpendingData(
      createdData: createdData ?? this.createdData,
      listSpending: listSpending ?? this.listSpending,
    );
  }

  @override
  List<Object?> get props => [
        createdData,
        listSpending,
      ];
}
