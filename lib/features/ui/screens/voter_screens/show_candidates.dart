import 'package:e_vote/features/ui/bloc/voter_bloc/voter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowCandidates extends StatefulWidget {
  @override
  _ShowCandidatesState createState() => _ShowCandidatesState();
}

class _ShowCandidatesState extends State<ShowCandidates> {
  VoterBloc voterBloc = VoterBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => voterBloc..add(DisplayCandidates()),
      child: Container(
        child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.refresh, color: Colors.black,),
                onPressed: () {
                  voterBloc.add(DisplayCandidates());
                }),
            IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              voterBloc.add((DisplayCandidates()));
            }),
          ],
          centerTitle: true,
          title: Text(
            'Candidates',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        ),
      ),
    );
  }
}
