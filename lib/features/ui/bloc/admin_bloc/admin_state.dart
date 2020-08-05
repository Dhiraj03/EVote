part of 'admin_bloc.dart';

abstract class AdminState extends Equatable {
  const AdminState();
}

class AdminInitial extends AdminState {
  @override
  List<Object> get props => [];
}

class AddCandidateOrVoter extends AdminState {
  @override
  List<Object> get props => [];
}

class HandleElectionStatus extends AdminState {
  final String status;

  HandleElectionStatus(this.status);

  @override
  List<Object> get props => [];
}

class ProcessingState extends AdminState {
  @override
  List<Object> get props => [];
}
