import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_vote/features/auth/data/UserModel.dart';
import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/database/firestore_repository.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserState get initialState => Loading();
  final UserRepository userRepository = UserRepository();
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    if (event is CheckWhetherAdmin) {
      final uid = await userRepository.getUser();
      final isAdmin = await firestoreRepository.isAdmin(uid);
      if (isAdmin)
        yield Admin();
      else
        yield Voter();
    } else
      yield Loading();
  }
}
