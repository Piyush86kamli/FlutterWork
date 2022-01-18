part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class HomeStarted extends UserEvent {
  @override
  String toString() => 'HomeStarted';
}

class FetchUserEvent extends UserEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
