part of 'login_bloc.dart';

class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginFailState extends LoginState {}

class LoginSuccessState extends LoginState {}
