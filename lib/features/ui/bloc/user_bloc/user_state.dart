part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class Loading extends UserState {
  @override
  List<Object> get props => [];
}

class Voter extends UserState {
  @override
  List<Object> get props => [];
}
class Admin extends UserState {
  @override
  List<Object> get props => [];
}