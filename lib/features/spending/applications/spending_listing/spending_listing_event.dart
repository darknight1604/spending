part of 'spending_listing_bloc.dart';

abstract class SpendingListingEvent extends Equatable {
  const SpendingListingEvent();

  @override
  List<Object> get props => [];
}

class FetchSpendingListingEvent extends SpendingListingEvent {}

class LoadMoreSpendingListingEvent extends SpendingListingEvent {}

class DeleteSpendingListingEvent extends SpendingListingEvent {
  final Spending spending;

  DeleteSpendingListingEvent(this.spending);
}
