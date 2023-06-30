part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeCurrentUserState extends HomeState {
  final User user;
  HomeCurrentUserState(this.user);
}

class HomeLogoutFailureState extends HomeState {}

class HomeLogoutSuccessState extends HomeState {}
