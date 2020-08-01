import 'package:e_vote/features/database/firestore_repository.dart';
import 'package:e_vote/features/ui/bloc/dashboard_bloc/dashboard_bloc.dart';
import 'package:e_vote/features/ui/presentation/dashboard_screen.dart';
import 'package:e_vote/features/ui/presentation/intro_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DashboardBloc dashboardBloc = DashboardBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<DashboardBloc>(
      create: (BuildContext context) =>
          dashboardBloc..add(CheckIfUserIsRegistered()),
      child: BlocBuilder<DashboardBloc, DashboardState>(
          // ignore: missing_return
          builder: (BuildContext context, DashboardState state) {
        if (state is DashboardInitial)
          return const Center(child: CircularProgressIndicator());
        else if (state is Registered) {
          return DashboardScreen();
        } else if (state is Unregistered) {
          return IntroForm(firestoreRepository: FirestoreRepository());
        }
      }),
    ));
  }
}
