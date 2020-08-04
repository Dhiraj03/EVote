part of 'voter_bloc.dart';

abstract class VoterState extends Equatable {
  VoterState([List props = const <dynamic>[]]) : super();
}

class VoterInitial extends VoterState {
  @override
  List<Object> get props => [];
}

class ViewCandidate extends VoterState {
  final List<Candidate> listOfCandidates;
  ViewCandidate(this.listOfCandidates) {}

  @override
  List<Object> get props => [];
}

class DelegateVote extends VoterState {
  @override
  List<Object> get props => [];
}

class Vote extends VoterState {
  @override
  List<Object> get props => [];
}
