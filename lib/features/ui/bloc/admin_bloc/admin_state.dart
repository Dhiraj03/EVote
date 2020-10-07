part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object> get props => [];
}

class AdminInitial extends AdminState {}

class CandidatesList extends AdminState {
  final List<Candidate> candidates;
  CandidatesList({@required this.candidates});
}
