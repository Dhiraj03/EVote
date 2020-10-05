part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class StartElection extends AdminEvent {
  @override
  List<Object> get props => [];
}