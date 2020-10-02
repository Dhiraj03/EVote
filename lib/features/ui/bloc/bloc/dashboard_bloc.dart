import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_vote/data/remote_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ElectionDataSource dataSource = ElectionDataSource();

  DashboardState get initialState => DashboardInitial();

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is GetCandidateCount) {
      String admin = await dataSource.getAdmin();
      yield CandidateCount(count: admin);
    }
  }
}
