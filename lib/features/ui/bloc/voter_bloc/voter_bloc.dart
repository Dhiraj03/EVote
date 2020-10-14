import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_vote/backend/errors.dart';
import 'package:e_vote/backend/remote_datasource.dart';
import 'package:e_vote/database/firestore_repository.dart';
import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/ui/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:e_vote/models/candidate_model.dart';
import 'package:e_vote/models/voter_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'voter_event.dart';
part 'voter_state.dart';

class VoterBloc extends Bloc<VoterEvent, VoterState> {
  VoterState get initialState => VoterInitial();
  final ElectionDataSource dataSource = ElectionDataSource();
  final FirestoreRepository repo = FirestoreRepository();
  final UserRepository userRepository = UserRepository();
  @override
  Stream<VoterState> mapEventToState(
    VoterEvent event,
  ) async* {
    if (event is ShowElectionDetails) {
      final String description = await dataSource.getDescription();
      final String adminAddress = await dataSource.adminAddress;
      final String electionsState = await dataSource.getElectionState();
      print(electionsState);
      yield ElectionDetailsState(
          adminAddress: adminAddress,
          description: description,
          electionState: electionsState);
    } else if (event is DisplayCandidates) {
      List<Candidate> candidates = await dataSource.getAllCandidates();
      yield CandidatesList(candidates: candidates);
    } else if (event is GetVoterProfile) {
      String email = await userRepository.getUserEmail();
      String address =  await repo.getVoterAddress(email);
      Voter voterProfile = await dataSource.getVoterProfile(address);
      yield VoterProfileState(voterProfile: voterProfile);
    }
  }
}
