import 'package:e_vote/database/firestore_repository.dart';
import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:e_vote/features/ui/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:e_vote/features/ui/screens/admin_screens/admin_dashboard.dart';
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
  final UserBlocBloc userBloc = UserBlocBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<UserBlocBloc, UserBlocState>(
      bloc: userBloc..add(IdentifyUser()),
      listener: (context, state) {},
      builder: (context, state) {
        if (state is Voter) {
          return Container(
            child: Center(child: Text('VOTER')),
          );
        } else if (state is Admin) {
          return AdminDashboard();
        }
        return CircularProgressIndicator();
      },
    ));
  }
}
