import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:e_vote/backend/errors.dart';
import 'package:e_vote/backend/remote_datasource.dart';
import 'package:e_vote/database/firestore_repository.dart';
import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/ui/bloc/admin_bloc/admin_bloc.dart';
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
      String address = await repo.getVoterAddress(email);
      Voter voterProfile = await dataSource.getVoterProfile(address);
      print(voterProfile.delegateAddress);
      yield VoterProfileState(voterProfile: voterProfile, address: address);
    } else if (event is ShowResults) {
      final results = await dataSource.showResults();
      yield* results.fold((e) async* {
        print('Error');
        yield VoterError(errorMessage: e);
      }, (results) async* {
        results.sort((a, b) => b.count.compareTo(a.count));
        yield Results(results: results, winner: results[0]);
      });
    } else if (event is DelegateVote) {
      String email = await userRepository.getUserEmail();
      String ownerAddress = await repo.getVoterAddress(email);
      final results =
          await dataSource.delegateVoter(event.delegateAddress, ownerAddress);
      yield* results.fold((e) async* {
        yield Loading();
        yield VoterError(errorMessage: e);
      }, (response) async* {
        yield Loading();
        yield ElectionTxHash(txHash: response);
      });
    } else if (event is Vote) {
      String email = await userRepository.getUserEmail();
      String ownerAddress = await repo.getVoterAddress(email);
      final result = await dataSource.vote(event.candidateID, ownerAddress);
      yield* result.fold((e) async* {
        yield Loading();
        yield VoterError(errorMessage: e);
      }, (response) async* {
        yield Loading();
        yield ElectionTxHash(txHash: response);
      });
    }
  }
}
