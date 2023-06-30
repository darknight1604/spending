import 'package:dani/features/spending/businesses/spending_business.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../businesses/models/spending_category.dart';
import '../../businesses/models/spending_request.dart';

part 'spending_event.dart';
part 'spending_state.dart';

class SpendingBloc extends Bloc<SpendingEvent, SpendingState> {
  final SpendingBusiness _spendingBusiness = GetIt.I.get();
  SpendingBloc() : super(SpendingInitial()) {
    on<FetchSpendingCategoryEvent>((event, emit) async {
      List<SpendingCategory> spendingCategories =
          await _spendingBusiness.getListSpendingCategory();
      emit(
        SpendingLoaded(spendingCategories: spendingCategories),
      );
    });
    on<CreateSpendingEvent>((event, emit) async {
      final result = await _spendingBusiness.addSpendingRequest(event.request);
      if (result) {
        emit(CreateSpendingRequestSuccess());
        return;
      }
      emit(CreateSpendingRequestFailure());
    });
  }
}
