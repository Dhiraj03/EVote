import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:e_vote/features/database/firestore_repository.dart';
import 'package:e_vote/features/ui/bloc/bloc/dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final UserRepository userRepository;
  HomeScreen({Key key, @required this.userRepository}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreRepository firestoreRepository = FirestoreRepository();
  final DashboardBloc bloc = DashboardBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder(
            bloc: bloc,
            builder: (BuildContext context, DashboardState state) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(onPressed: () {
                  bloc.add(GetCandidateCount());
                }),
                body: Center(
                  child: Text((state is CandidateCount) ? state.count : 'lmao'),
                ),
              );
            }));
  }
}
