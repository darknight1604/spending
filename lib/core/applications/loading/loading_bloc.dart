import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loading_event.dart';
part 'loading_state.dart';

class LoadingBloc extends Bloc<LoadingEvent, LoadingState> {
  LoadingBloc() : super(LoadingInitial()) {
    on<LoadingShowEvent>((event, emit) {
      emit(LoadingShowState());
    });
    on<LoadingDismissEvent>((event, emit) {
      emit(LoadingDismissState());
    });
  }
}
