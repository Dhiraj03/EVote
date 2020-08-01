import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/database/firestore_repository.dart';
import 'package:equatable/equatable.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserRepository userRepository = UserRepository();
  final FirestoreRepository firestoreRepository = FirestoreRepository();

  @override
  DashboardState get initialState => DashboardInitial();

  @override
  Stream<DashboardState> mapEventToState(
    DashboardEvent event,
  ) async* {
    if (event is CheckIfUserIsRegistered) {
      final uid = await userRepository.getUser();
      bool res = await firestoreRepository.checkIfUserExists(uid);
      if (res == true)
        yield Registered();
      else
        yield Unregistered();
    } else if (event is RegisterUser) {
      final uid = await userRepository.getUser();
      firestoreRepository.storeBasicInfo(
          uid, false, event.privateKey, false, event.address);
      yield Registered();
    }
  }
}
