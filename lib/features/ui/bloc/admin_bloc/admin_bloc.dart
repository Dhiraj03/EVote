import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_vote/backend/remote_datasource.dart';
import 'package:equatable/equatable.dart';

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
    }
  }
}
