import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_vote/backend/Candidate.dart';
import 'package:e_vote/backend/Election.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
part 'voter_event.dart';
part 'voter_state.dart';

class VoterBloc extends Bloc<VoterEvent, VoterState> {
  VoterBloc() : super();

  Election _election = Election();

  @override
  VoterState get initialState => VoterInitial();

  @override
  Stream<VoterState> mapEventToState(
    VoterEvent event,
  ) async* {
    // TODO: implement mapEventToState
    if (event is ViewCandidateClicked) {
      final listOfCandidates =
          await _election.displayCandidates(event.adminKey);
      yield ViewCandidate(listOfCandidates);
    }
    if (event is DelegateVoteClicked) {
      await _election.delegateVote(event.voterKey, event.delegateAddress);
      yield DelegateVote();
    }
    if (event is VoteClicked) {
      await _election.vote(event.voterKey, event.candidateID);
    }
  }
}
