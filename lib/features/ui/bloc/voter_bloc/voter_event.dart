part of 'voter_bloc.dart';

abstract class VoterEvent extends Equatable {
  const VoterEvent();

  @override
  List<Object> get props => [];
}

class ShowElectionDetails extends VoterEvent {
  @override
  List<Object> get props => [];
}

class DisplayCandidates extends VoterEvent {
  @override
  List<Object> get props => [];
}

class Vote extends VoterEvent {
  final int candidateID;
  Vote({@required this.candidateID});
  @override
  List<Object> get props => [candidateID];
}

class DelegateVote extends VoterEvent {
  final String delegateAddress;
  DelegateVote({@required this.delegateAddress});
  @override
  List<Object> get props => [delegateAddress];
}

class ShowWinner extends VoterEvent {
  @override
  List<Object> get props => [];
}

class ShowResults extends VoterEvent {
  @override
  List<Object> get props => [];
}

class ElectionDetails extends VoterEvent {
  @override
  List<Object> get props => [];
}

class GetVoterProfile extends VoterEvent {
  @override
  List<Object> get props => [];
}
