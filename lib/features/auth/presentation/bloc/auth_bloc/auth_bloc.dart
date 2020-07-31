import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthenticationEvent, AuthState> {
  AuthBloc({@required this.repository}) : super();
  final UserRepository repository;

  @override
  AuthState get initialState => Uninitialized();

  @override
  Stream<AuthState> mapEventToState(AuthenticationEvent event) async* {
    if (event is AppStarted)
      yield* mapAppStarted();
    else if (event is LoggedIn)
      yield* mapLoggedIn();
    else if (event is LoggedOut) yield* mapLoggedOut();
  }

  Stream<AuthState> mapAppStarted() async* {
    try {
      final isSignedIn = await repository.isSignedIn();
      if (isSignedIn) {
        final name = await repository.getUser();
        yield Authenticated(name);
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> mapLoggedIn() async* {
    yield Authenticated(await repository.getUser());
  }

  Stream<AuthState> mapLoggedOut() async* {
    yield Unauthenticated();
    repository.signOut();
  }
}
