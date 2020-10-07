part of 'user_bloc_bloc.dart';

abstract class UserBlocEvent extends Equatable {
  const UserBlocEvent();

  @override
  List<Object> get props => [];
}

class IdentifyUser extends UserBlocEvent {
  @override
  List<Object> get props => [];
}
