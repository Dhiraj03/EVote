import 'package:e_vote/features/ui/bloc/admin_bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
          title: Text(
            'Candidates',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        body: BlocBuilder(
            bloc: BlocProvider.of<AdminBloc>(context)..add(DisplayCandidates()),
            builder: (BuildContext context, AdminState state) {
              if (state is CandidatesList) {
                print(state.candidates.length);
                return ListView.builder(
                    padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                    itemCount: state.candidates.length,
                    itemBuilder: (BuildContext context, int i) {
                      print(state.candidates.length);
                      return Card(
                        color: Color(0xFFFAFAFA),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color(0xFFDCDCDC), width: 0.5),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Candidate ID:   ',
                                      style: TextStyle(
                                          color: Color(0xff2F2F2F),
                                          fontSize: 19,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Flexible(
                                      child: Text(
                                          state.candidates[i].id.toString(),
                                          style: TextStyle(
                                              color: Color(0xff495057),
                                              fontSize: 19,
                                              fontWeight: FontWeight.w400)),
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('Name:               ',
                                        style: TextStyle(
                                            color: Color(0xff2F2F2F),
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600)),
                                    Flexible(
                                      child: Text(
                                          state.candidates[i].name.toString(),
                                          style: TextStyle(
                                              color: Color(0xff2F2F2F),
                                              fontSize: 19,
                                              fontWeight: FontWeight.w400)),
                                    )
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Proposal:          ",
                                        style: TextStyle(
                                            color: Color(0xff2F2F2F),
                                            fontSize: 19,
                                            fontWeight: FontWeight.w600)),
                                    Flexible(
                                      child: Text(
                                          state.candidates[i].proposal
                                              .toString(),
                                          style: TextStyle(
                                              color: Color(0xff2F2F2F),
                                              fontSize: 19,
                                              fontWeight: FontWeight.w400)),
                                    )
                                  ],
                                )
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
