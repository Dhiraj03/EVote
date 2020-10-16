import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:e_vote/features/ui/bloc/voter_bloc/voter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ShowCandidates extends StatefulWidget {
  @override
  _ShowCandidatesState createState() => _ShowCandidatesState();
}

class _ShowCandidatesState extends State<ShowCandidates> {
  VoterBloc voterBloc;
  @override
  void initState() {
    voterBloc = VoterBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => voterBloc..add(DisplayCandidates()),
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    voterBloc.add(DisplayCandidates());
                  }),
              IconButton(
                  icon: Icon(
                    MaterialCommunityIcons.logout,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context)..add(LoggedOut());
                  }),
            ],
            centerTitle: true,
            title: Text(
              'Candidates',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: BlocConsumer<VoterBloc, VoterState>(
              bloc: voterBloc..add(DisplayCandidates()),
              buildWhen: (previous, current) {
                if (current is VoterError ||
                    current is Loading ||
                    current is ElectionTxHash) {
                  return false;
                }
                return true;
              },
              builder: (BuildContext context, VoterState state) {
                if (state is CandidatesList) {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: RaisedButton(
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        color: Theme.of(context).primaryColor,
                                        child: Text(
                                          'VOTE',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              child: Dialog(
                                                elevation: 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7)),
                                                  height: 180,
                                                  width: 300,
                                                  child: Column(
                                                      children: <Widget>[
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  left: 15,
                                                                  bottom: 10),
                                                          width: 300,
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          child: Text(
                                                            'E-Vote',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 25),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 15,
                                                                    left: 15,
                                                                    bottom: 10),
                                                            child: Text(
                                                              'Are you sure you want to vote for Candidate ${state.candidates[i].id}?',
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: <Widget>[
                                                            FlatButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  voterBloc
                                                                    ..add(Vote(
                                                                        candidateID: state
                                                                            .candidates[i]
                                                                            .id));
                                                                },
                                                                child: Text(
                                                                    'YES',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            17,
                                                                        color: Theme.of(context)
                                                                            .primaryColor
                                                                            .withOpacity(0.9)))),
                                                            FlatButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text('NO',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          17,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                          .withOpacity(
                                                                              0.9))),
                                                            )
                                                          ],
                                                        )
                                                      ]),
                                                ),
                                              ),
                                              context: context);
                                        }),
                                  )
                                ]),
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }
              },
              listener: (BuildContext context, VoterState state) {
                if (state is VoterError) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.red[700],
                      content: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.error),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              state.errorMessage.message,
                              style: TextStyle(color: Colors.white),
                            ),
                          ])));
                } else if (state is ElectionTxHash) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                'TxHash:  ' + state.txHash,
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                              ),
                            ),
                          ])));
                } else if (state is Loading) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Theme.of(context).primaryColorDark,
                      content: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 35,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                'Loading',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                                maxLines: 3,
                              ),
                            ),
                          ])));
                }
              }),
        ),
      ),
    );
  }
}
