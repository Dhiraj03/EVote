part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

class Registered extends DashboardState {
  @override
  List<Object> get props => [];
  
}

class Unregistered extends DashboardState {
  @override
  List<Object> get props => [];
}
