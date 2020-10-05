import 'package:e_vote/database/firestore_repository.dart';
import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:e_vote/features/ui/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/font_awesome_icons.dart';

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
        body: BlocConsumer(
      listener: (context, state) {},
      builder: (context, state) {
        if(state is Voter)
        {
          
        }
        else if(state is Admin)
        {

        }
      },
    ));
  }
}
