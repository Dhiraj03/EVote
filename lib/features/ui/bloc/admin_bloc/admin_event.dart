part of 'admin_bloc.dart';

abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object> get props => [];
}

class StartElection extends AdminEvent {
  @override
  List<Object> get props => [];
}

class EndElection extends AdminEvent {
  @override
  List<Object> get props => [];
}

class DisplayCandidates extends AdminEvent {
  @override
  List<Object> get props => [];
}

class AddCandidate extends AdminEvent {
  final String name;
  final String proposal;
  AddCandidate({@required this.name, @required this.proposal});
  @override
  List<Object> get props => [name, proposal];
}

class DisplayVoters extends AdminEvent {
  @override
  List<Object> get props => [];
}

class AddVoter extends AdminEvent {
  final String voterAddress;
  AddVoter({@required this.voterAddress});
  @override
  List<Object> get props => [voterAddress];
}



class ShowResults extends AdminEvent {
  @override
  List<Object> get props => [];
}

class GetElectionDetails extends AdminEvent {
  @override
  List<Object> get props => [];
}
