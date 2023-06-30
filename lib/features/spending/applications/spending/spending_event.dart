part of 'spending_bloc.dart';

class SpendingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSpendingCategoryEvent extends SpendingEvent {}

class CreateSpendingEvent extends SpendingEvent {
  final SpendingRequest request;

  CreateSpendingEvent(this.request);
}
