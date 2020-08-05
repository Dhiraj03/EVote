part of 'admin_bloc.dart';

@immutable
abstract class AdminEvent extends Equatable {
  AdminEvent([List props = const <dynamic>[]]) : super();
}

class AddCandidateClicked extends AdminEvent {
  final String privateKey;
  final String nameOfCandidate;
  final String proposal;

  AddCandidateClicked(this.nameOfCandidate, this.proposal, this.privateKey) {}

  @override
  List<Object> get props => [];
}

class AddVoterClicked extends AdminEvent {
  final String privateKey;
  final String voterAddress;

  AddVoterClicked(this.voterAddress, this.privateKey) {}

  @override
  List<Object> get props => [];
}

class HandleElectionStatusClicked extends AdminEvent {
  final String privateKey;
  final String status;

  HandleElectionStatusClicked(this.status, this.privateKey) {}

  @override
  List<Object> get props => [];
}