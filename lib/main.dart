import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'backend/Election.dart';
import 'features/auth/presentation/bloc/auth_bloc/auth_states.dart';
import 'features/auth/presentation/screens/Login_Screen.dart';
import 'home_screen.dart';
import 'features/auth/presentation/screens/splash_screen.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final UserRepository _userRepository = UserRepository();
  AuthBloc _authBloc;
 final Election election = Election();
  //An instance of user_Repository and AuthBloc is created
  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(repository: _userRepository);
    _authBloc.add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ChangeNotifierProvider(
        create: (_) => election,
        child: BlocProvider(
        create: (BuildContext context) => _authBloc,
        child: MaterialApp(
          home: BlocBuilder<AuthBloc, AuthState>(
              builder: (BuildContext context, AuthState state) {
            if (state is AppStarted) return SplashScreen();
            if (state is Authenticated)
              return HomeScreen(userRepository: _userRepository,);
            if (state is Unauthenticated)
              return LoginScreen(userRepository: _userRepository);
            return Container();
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
}
