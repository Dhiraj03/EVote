part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class GetCandidateCount extends DashboardEvent {
  @override
  List<Object> get props => [];
}