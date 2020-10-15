part of 'voter_bloc.dart';

abstract class VoterState extends Equatable {
  const VoterState();

  @override
  List<Object> get props => [];
}

class VoterInitial extends VoterState {}

class Loading extends VoterState {
  @override
  List<Object> get props => [];
}

class ElectionDetailsState extends VoterState {
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

class ElectionTxHash extends VoterState {
  final String txHash;
  ElectionTxHash({@required this.txHash});
  @override
  List<Object> get props => [txHash];
}

class VoterError extends VoterState {
  final ErrorMessage errorMessage;
  VoterError({@required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}

class CandidatesList extends VoterState {
  final List<Candidate> candidates;
  CandidatesList({@required this.candidates});
  @override
  List<Object> get props => [];
}

class VoterProfileState extends VoterState {
  final Voter voterProfile;
  final String address;
  VoterProfileState({@required this.voterProfile, @required this.address});
  @override
  List<Object> get props => [voterProfile, address];
}

class Results extends VoterState {
  final List<Candidate> results;
  final Candidate winner;
  Results({@required this.results, @required this.winner});
  @override
  List<Object> get props => [results, winner];
}