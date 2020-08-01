import 'package:e_vote/features/auth/data/user_repository.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:e_vote/features/database/firestore_repository.dart';
import 'package:e_vote/features/ui/presentation/dashboard.dart';
import 'package:e_vote/features/ui/presentation/intro_form.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('E-Vote'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(LoggedOut());
              },
            )
          ],
        ),
        body: Dashboard());
  }
}
