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

class ElectionTxHash extends AdminState {
  final String txHash;
  ElectionTxHash({@required this.txHash});
  @override
  List<Object> get props => [txHash];
}

class AdminError extends AdminState {
  final ErrorMessage errorMessage;
  AdminError({@required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class Loading extends AdminState {
  @override
  List<Object> get props => [];
}
