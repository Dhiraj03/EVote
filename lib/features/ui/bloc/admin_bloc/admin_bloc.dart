import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_vote/backend/Election.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super();

  @override
  AdminState get initialState => AdminInitial();

  final Election _election = Election();

  @override
  Stream<AdminState> mapEventToState(
    AdminEvent event,
  ) async* {
    if (event is AddCandidateClicked) {
      yield ProcessingState();
      await _election.addCandidate(
          event.nameOfCandidate, event.proposal, event.privateKey);
      yield AddCandidateOrVoter();
    }
   else if (event is AddVoterClicked) {
      yield ProcessingState();
      await _election.addVoter(event.voterAddress, event.privateKey);
      yield AddCandidateOrVoter();
    }
   else if (event is HandleElectionStatusClicked) {
      if (event.status == 'START') {
        yield ProcessingState();
        await _election.startElection(event.privateKey);
        yield HandleElectionStatus(event.status);
      } else if (event.status == 'STOP') {
        yield ProcessingState();
        await _election.endElection(event.privateKey);
        yield HandleElectionStatus(event.status);
      }
    }
  }
}
