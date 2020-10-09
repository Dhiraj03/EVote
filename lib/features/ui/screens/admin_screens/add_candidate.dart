import 'package:e_vote/features/ui/bloc/admin_bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCandidateScreen extends StatefulWidget {
  @override
  _AddCandidateScreenState createState() => _AddCandidateScreenState();
}

class _AddCandidateScreenState extends State<AddCandidateScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Candidates', style: TextStyle(color: Colors.black87),),
        ),
        body: BlocBuilder(
            bloc: BlocProvider.of<AdminBloc>(context)..add(DisplayCandidates()),
            builder: (BuildContext context, AdminState state) {
              if (state is CandidatesList) {
                print(state.candidates.length);
                return ListView.builder(
                    padding: EdgeInsets.only(left: 10, top: 10),
                    itemCount: state.candidates.length,
                    itemBuilder: (BuildContext context, int i) {
                      print(state.candidates.length);
                      return Card(
                        color: Colors.white10,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 0.5),
                            borderRadius: BorderRadius.circular(2)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                            Text(
                              'Candidate ID : ' + state.candidates[i].id.toString(),
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Candidate Name : ' + state.candidates[i].name,
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Candidate Proposal : ' + state.candidates[i].proposal,
                              style: TextStyle(fontSize: 20),
                            ),
                          ]),
                        ),
                      );
                    });
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
