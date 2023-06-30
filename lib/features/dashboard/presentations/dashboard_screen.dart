import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/extensions/date_time_extension.dart';
import 'package:dani/core/utils/text_theme_util.dart';
import 'package:dani/features/dashboard/presentations/widgets/pie_chart.dart';
import 'package:dani/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/widgets/total_row_widget.dart';
import '../applications/spending_dashboard/spending_dashboard_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  final DateTime _now = DateTime.now();
  late SpendingDashboardBloc _spendingDashboardBloc;

  late DateTime _initStartDate;
  late DateTime _initEndDate;
  late DateTime _firstDate;
  late DateTime _lastDate;

  late DateTime _startDate;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _spendingDashboardBloc = GetIt.I.get<SpendingDashboardBloc>();

    _initStartDate = DateTime(_now.year, _now.month, 1);
    _initEndDate = DateTime(
      _now.year,
      _now.month,
      DateTime(_now.year, _now.month + 1, 0).day,
    );
    _startDate = _initStartDate;
    _endDate = _initEndDate;
    _firstDate = DateTime(_now.year, DateTime.january, 1);
    _lastDate = DateTime(_now.year, DateTime.december, 31);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<SpendingDashboardBloc>(
      create: (context) => _spendingDashboardBloc
        ..add(
          GenerateDataDashboardEvent(
            startDate: _startDate,
            endDate: _endDate,
          ),
        ),
      child: BlocListener<SpendingDashboardBloc, SpendingDashboardState>(
        listener: (context, state) {
          if (state is! SpendingPieChartDashboardState) return;

          _startDate = state.startDate ?? _startDate;
          _endDate = state.endDate ?? _endDate;
        },
        child: Scaffold(
          backgroundColor: Constants.scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(Constants.padding),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Constants.radius,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Constants.padding),
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: _pickRangeDate,
                            child: BlocBuilder<SpendingDashboardBloc,
                                SpendingDashboardState>(
                              builder: (context, state) {
                                return Text(
                                  tr(
                                    LocaleKeys
                                        .dashboardScreen_statisticFromDayToDay,
                                    args: [
                                      state.startDate?.formatDDMMYYYY() ??
                                          StringPool.empty,
                                      state.endDate?.formatDDMMYYYY() ??
                                          StringPool.empty,
                                    ],
                                  ),
                                  style: TextThemeUtil.instance.titleMedium,
                                );
                              },
                            ),
                          ),
                          InkWell(
                            onTap: _pickRangeDate,
                            child: Icon(
                              Icons.expand_more,
                              size: Constants.iconSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<SpendingDashboardBloc, SpendingDashboardState>(
                      builder: (context, state) {
                        return TotalRowWidget(
                          title: tr(LocaleKeys.common_total),
                          content: state is! SpendingPieChartDashboardState
                              ? Constants.empty
                              : '${Constants.nf.format(state.spendingPieChartData.total)} ${Constants.currencySymbol}',
                        );
                      },
                    ),
                    Expanded(child: PieChartSample()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;

  Future _pickRangeDate() async {
    DateTimeRange? dateTimeRange = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: _firstDate,
      lastDate: _lastDate,
      initialDateRange: DateTimeRange(
        start: _startDate,
        end: _endDate,
      ),
    );
    if (dateTimeRange == null) {
      return;
    }

    _spendingDashboardBloc.add(
      GenerateDataDashboardEvent(
        startDate: dateTimeRange.start,
        endDate: dateTimeRange.end,
      ),
    );
  }
}
