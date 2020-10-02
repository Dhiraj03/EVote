part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class CandidateCount extends DashboardState {
  final String count;
  CandidateCount({@required this.count});
}
