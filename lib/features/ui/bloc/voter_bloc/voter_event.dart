part of 'voter_bloc.dart';

@immutable
abstract class VoterEvent extends Equatable {
  VoterEvent([List props = const <dynamic>[]]) : super();
}

class ViewCandidateClicked extends VoterEvent {
  final String adminKey;
  ViewCandidateClicked(this.adminKey) {}

  @override
  List<Object> get props => [];
}

class VoteClicked extends VoterEvent {
  final String voterKey;
  final int candidateID;

  VoteClicked(this.voterKey, this.candidateID) {}

  @override
  List<Object> get props => [];
}

class DelegateVoteClicked extends VoterEvent {
  final String voterKey;
  final String delegateAddress;

  DelegateVoteClicked(this.voterKey, this.delegateAddress) {}

  @override
  List<Object> get props => [];
}
