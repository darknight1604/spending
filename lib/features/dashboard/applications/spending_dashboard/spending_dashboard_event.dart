part of 'spending_dashboard_bloc.dart';

abstract class SpendingDashboardEvent extends Equatable {
  const SpendingDashboardEvent();

  @override
  List<Object> get props => [];
}

class GenerateDataDashboardEvent extends SpendingDashboardEvent {
  final DateTime? startDate;
  final DateTime? endDate;

  GenerateDataDashboardEvent({
    this.startDate,
    this.endDate,
  });
}
