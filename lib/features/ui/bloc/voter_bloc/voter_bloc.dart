import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'voter_event.dart';
part 'voter_state.dart';

class VoterBloc extends Bloc<VoterEvent, VoterState> {
  VoterState get initialState => VoterInitial();

  @override
  Stream<VoterState> mapEventToState(
    VoterEvent event,
  ) async* {
    
  }
}
