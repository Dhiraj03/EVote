import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
    return BlocProvider(
      create: (BuildContext context) => _authBloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme
          ),
            colorScheme: ColorScheme(
                primary: Color(0xFFf4511e),
                primaryVariant: Color(0xffb91400),
                secondary: Color(0xFF616161),
                secondaryVariant: Color(0xFF373737),
                surface: Color(0xFFF2F2F2),
                background: Color(0xFFF2F2F2),
                error: Color(0xffad1457),
                onPrimary: Colors.black54,
                onSecondary: Colors.black87,
                onSurface: Colors.black54,
                onBackground: Colors.black87,
                onError: Colors.black87,
                brightness: Brightness.light)),
        home: BlocBuilder<AuthBloc, AuthState>(
            bloc: _authBloc,
            builder: (BuildContext context, AuthState state) {
              if (state is AppStarted) return SplashScreen();
              if (state is Authenticated)
                return HomeScreen(
                  userRepository: _userRepository,
                );
              if (state is Unauthenticated)
                return LoginScreen(userRepository: _userRepository);
              return Container();
            }),
      ),
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
}
