import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_vote/backend/remote_datasource.dart';
import 'package:e_vote/features/ui/bloc/voter_bloc/voter_bloc.dart';
import 'package:e_vote/models/candidate_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminState get initialState => AdminInitial();
  final ElectionDataSource dataSource = ElectionDataSource();
  @override
  Stream<AdminState> mapEventToState(
    AdminEvent event,
  ) async* {
    if (event is StartElection) {
      await dataSource.startElection();
    } else if (event is DisplayCandidates) {
      List<Candidate> candidates = await dataSource.getAllCandidates();
      yield CandidatesList(candidates: candidates);
    } else if (event is GetElectionDetails) {
      final String description = await dataSource.getDescription();
      final String adminAddress = await dataSource.adminAddress;
      final String electionsState = await dataSource.getElectionState();

    }
  }
}
