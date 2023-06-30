part of 'spending_listing_bloc.dart';

abstract class SpendingListingState extends Equatable {
  const SpendingListingState();

  @override
  List<Object> get props => [];
}

class SpendingListingInitial extends SpendingListingState {}

class SpendingListingLoading extends SpendingListingState {}

class SpendingListingLoaded extends SpendingListingState {
  final List<GroupSpendingData> listGroupSpendingData;
  final bool isFinishLoadMore;
  SpendingListingLoaded(this.listGroupSpendingData,
      {this.isFinishLoadMore = false});
  @override
  List<Object> get props => [
        listGroupSpendingData,
        isFinishLoadMore,
      ];

  SpendingListingLoaded copyWith({bool? isFinishLoadMore}) {
    return SpendingListingLoaded(
      listGroupSpendingData,
      isFinishLoadMore: isFinishLoadMore ?? this.isFinishLoadMore,
    );
  }
}


class DeleteSpendingListingState extends SpendingListingState {}

class DeleteSpendingListingSuccess extends DeleteSpendingListingState {}

class DeleteSpendingListingFailure extends DeleteSpendingListingState {}