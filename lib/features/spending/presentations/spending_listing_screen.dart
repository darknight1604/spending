import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/extensions/date_time_extension.dart';
import 'package:dani/core/utils/extensions/text_style_extension.dart';
import 'package:dani/core/utils/string_util.dart';
import 'package:dani/core/utils/text_theme_util.dart';
import 'package:dani/features/spending/businesses/models/spending.dart';
import 'package:dani/features/spending/spending_route.dart';
import 'package:dani/gen/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core/applications/loading/loading_bloc.dart';
import '../../../core/widgets/base_stateful.dart';
import '../../../core/widgets/empty_widget.dart';
import '../../../core/widgets/total_row_widget.dart';
import '../applications/spending_listing/spending_listing_bloc.dart';
import '../businesses/models/group_spending_data.dart';

part './spending_item.dart';

class SpendingListingScreen extends StatefulWidget {
  const SpendingListingScreen({super.key});

  @override
  State<SpendingListingScreen> createState() => _SpendingListingScreenState();
}

class _SpendingListingScreenState extends State<SpendingListingScreen>
    with AutomaticKeepAliveClientMixin {
  late SpendingListingBloc spendingListingBloc;
  @override
  void initState() {
    super.initState();
    spendingListingBloc = GetIt.I.get<SpendingListingBloc>()
      ..add(
        FetchSpendingListingEvent(),
      );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => spendingListingBloc,
      child: Scaffold(
        backgroundColor: Constants.scaffoldBackgroundColor,
        body: _ScreenBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.pushNamed(context, GetIt.I.get<SpendingRoute>().routeName)
                .then(
              (value) {
                if (value == null) return;
                spendingListingBloc.add(FetchSpendingListingEvent());
              },
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ScreenBody extends BaseStateful {
  @override
  BaseStatefulState createState() => _ScreenBodyState();
}

class _ScreenBodyState extends BaseStatefulState {
  @override
  Widget buildChild(BuildContext context) {
    return BlocConsumer<SpendingListingBloc, SpendingListingState>(
      listener: (context, state) {
        if (state is SpendingListingLoading) {
          loadingBloc.add(LoadingShowEvent());
          return;
        }
      },
      buildWhen: (previous, current) => current is! DeleteSpendingListingState,
      builder: (context, state) {
        if (state is! SpendingListingLoaded) {
          return EmptyWidget();
        }
        if (loadingBloc.state is LoadingShowState) {
          loadingBloc.add(LoadingDismissEvent());
        }

        if (state.listGroupSpendingData.isEmpty) {
          return EmptyWidget();
        }
        List<GroupSpendingData> listGroupSpendingData =
            state.listGroupSpendingData;
        return RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 100));
            BlocProvider.of<SpendingListingBloc>(context)
                .add(FetchSpendingListingEvent());
          },
          child: ListView.builder(
            itemCount: listGroupSpendingData.length + 1,
            itemBuilder: (_, index) {
              if (index == listGroupSpendingData.length &&
                  state.isFinishLoadMore) {
                return SizedBox.shrink();
              }
              if (index == listGroupSpendingData.length) {
                BlocProvider.of<SpendingListingBloc>(context)
                    .add(LoadMoreSpendingListingEvent());
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              GroupSpendingData entry = listGroupSpendingData[index];
              List<Spending> _listSpending = entry.listSpending ?? [];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _TitleGroupListSpendingWidget(
                    title:
                        entry.createdData?.formatDDMMYYYY() ?? StringPool.empty,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      Constants.padding,
                      0,
                      Constants.padding,
                      8.0,
                    ),
                    child: TotalRowWidget(
                      title: '${tr(LocaleKeys.spendingScreen_totalPerDay)}: ',
                      content:
                          '${Constants.nf.format(entry.totalPerDay)} ${Constants.currencySymbol}',
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.fromLTRB(
                      Constants.padding,
                      0,
                      Constants.padding,
                      Constants.padding,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _listSpending.length,
                    separatorBuilder: (_, __) => SizedBox(
                      height: Constants.spacingBetweenWidget,
                    ),
                    itemBuilder: (context, index) => SpendingItem(
                      spending: _listSpending[index],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _TitleGroupListSpendingWidget extends StatelessWidget {
  final String title;
  const _TitleGroupListSpendingWidget({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.black,
            ),
          ),
          Text(
            title,
            style: TextThemeUtil.instance.bodyMedium?.semiBold,
          ),
          Expanded(
            child: Divider(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
