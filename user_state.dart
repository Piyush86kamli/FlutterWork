part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoadingState extends UserState {
  @override
  List<Object> get props => [];
}

class UserLoadedState extends UserState {
  List<UserModel> users;

  UserLoadedState({required this.users});

  @override
  List<Object> get props => [users];
}

class UserErrorState extends UserState {
  String message;

  UserErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
