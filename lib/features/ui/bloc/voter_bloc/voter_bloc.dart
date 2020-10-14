import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_vote/backend/errors.dart';
import 'package:e_vote/backend/remote_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'voter_event.dart';
part 'voter_state.dart';

class VoterBloc extends Bloc<VoterEvent, VoterState> {
  VoterState get initialState => VoterInitial();
  final ElectionDataSource dataSource = ElectionDataSource();
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
    }
  }
}
