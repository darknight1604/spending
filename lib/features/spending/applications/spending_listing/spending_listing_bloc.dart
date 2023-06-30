import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dani/features/spending/businesses/spending_business.dart';
import 'package:equatable/equatable.dart';

import '../../businesses/models/group_spending_data.dart';
import '../../businesses/models/spending.dart';

part 'spending_listing_event.dart';
part 'spending_listing_state.dart';

class SpendingListingBloc
    extends Bloc<SpendingListingEvent, SpendingListingState> {
  final SpendingBusiness spendingBusiness;

  SpendingListingBloc(
    this.spendingBusiness,
  ) : super(SpendingListingInitial()) {
    on<FetchSpendingListingEvent>((event, emit) async {
      emit(SpendingListingLoading());
      final result = await spendingBusiness.getListSpending();
      emit(SpendingListingLoaded(result));
    });
    on<LoadMoreSpendingListingEvent>(
      transformer: restartable(),
      (event, emit) async {
        if (state is! SpendingListingLoaded) return;
        final result = await spendingBusiness.loadMoreListSpending();
        if (result == null) {
          emit(
            (state as SpendingListingLoaded).copyWith(isFinishLoadMore: true),
          );
          return;
        }
        emit(SpendingListingLoaded(result));
      },
    );
    on<DeleteSpendingListingEvent>((event, emit) async {
      final result = await spendingBusiness.deleteSpending(
        event.spending.copyWith(isDeleted: true),
      );
      if (result) {
        emit(DeleteSpendingListingSuccess());
        add(FetchSpendingListingEvent());
        return;
      }
      emit(DeleteSpendingListingFailure());
    });
  }
}
