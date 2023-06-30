part of 'spending_bloc.dart';

class SpendingState extends Equatable {
  const SpendingState();

  @override
  List<Object> get props => [];
}

class SpendingInitial extends SpendingState {}

class SpendingLoaded extends SpendingState {
  final List<SpendingCategory> spendingCategories;
  SpendingLoaded({
    required this.spendingCategories,
  });
  @override
  List<Object> get props => [spendingCategories];
}

class CreateSpendingRequestSuccess extends SpendingState {}

class CreateSpendingRequestFailure extends SpendingState {}
