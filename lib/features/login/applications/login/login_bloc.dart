import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domains/businesses/login_business.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginBusiness loginBusiness;

  LoginBloc(this.loginBusiness) : super(LoginInitial()) {
    on<LoginWithGmailEvent>((event, emit) async {
      emit(LoginLoadingState());
      final result = await loginBusiness.login();
      if (!result) {
        emit(LoginFailState());
        return;
      }
      emit(LoginSuccessState());
    });
  }
}
