import 'package:e_vote/features/ui/bloc/user_bloc/user_bloc.dart';
import 'package:e_vote/features/ui/presentation/admin_dashboard.dart';
import 'package:e_vote/features/ui/presentation/voter_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final UserBloc userBloc = UserBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (BuildContext context) => userBloc..add(CheckWhetherAdmin()),
      child: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
        if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Voter)
          return VoterDashboard();
        else if (state is Admin) return AdminDashboard();
      }),
    );
  }
}
