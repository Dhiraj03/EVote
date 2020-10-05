import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:e_vote/database/firestore_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

class UserBlocBloc extends Bloc<UserBlocEvent, UserBlocState> {
  UserBlocState get initialState => UserBlocInitial();
  final FirestoreRepository repo = FirestoreRepository();
  @override
  Stream<UserBlocState> mapEventToState(
    UserBlocEvent event,
  ) async* {
    if (event is IdentifyUser) {
      if (await repo.isVoter(event.email) == true)
        yield Voter();
      else
        yield Admin();
    }
  }
}
