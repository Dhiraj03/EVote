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

class ElectionDetailsState extends AdminState {
  final String description;
  final String adminAddress;
  final String electionState;
  ElectionDetailsState(
      {@required this.adminAddress,
      @required this.description,
      @required this.electionState});
  @override
  List<Object> get props => [adminAddress, description, electionState];
}
