part of 'spending_dashboard_bloc.dart';

abstract class SpendingDashboardState extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  const SpendingDashboardState({
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        startDate,
        endDate,
      ];
}

class SpendingDashboardInitial extends SpendingDashboardState {
  SpendingDashboardInitial({super.startDate, super.endDate});
}

class SpendingDashboardLoading extends SpendingDashboardState {
  SpendingDashboardLoading() : super(startDate: null, endDate: null);
}

class SpendingPieChartDashboardState extends SpendingDashboardState {
  final SpendingPieChartData spendingPieChartData;

  SpendingPieChartDashboardState(
    this.spendingPieChartData, {
    super.startDate,
    super.endDate,
  });
  @override
  List<Object> get props => [spendingPieChartData];
}
