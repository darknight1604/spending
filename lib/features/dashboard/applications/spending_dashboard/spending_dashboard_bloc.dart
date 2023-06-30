import 'package:bloc/bloc.dart';
import 'package:dani/features/dashboard/businesses/dashboard_business.dart';
import 'package:equatable/equatable.dart';

import '../../businesses/models/spending_pie_chart_data.dart';

part 'spending_dashboard_event.dart';
part 'spending_dashboard_state.dart';

class SpendingDashboardBloc
    extends Bloc<SpendingDashboardEvent, SpendingDashboardState> {
  final DashboardBusiness dashboardBusiness;
  SpendingDashboardBloc(
    this.dashboardBusiness,
  ) : super(SpendingDashboardInitial()) {
    on<GenerateDataDashboardEvent>((event, emit) async {
      emit(SpendingDashboardLoading());
      SpendingPieChartData data = await dashboardBusiness.initData(
        event.startDate ?? DateTime.now(),
        event.endDate ?? DateTime.now(),
      );
      emit(SpendingPieChartDashboardState(
        data,
        startDate: event.startDate,
        endDate: event.endDate,
      ));
    });
  }
}
