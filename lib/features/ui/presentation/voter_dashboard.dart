import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vote/backend/Candidate.dart';
import 'package:e_vote/backend/Election.dart';
import 'package:e_vote/features/ui/bloc/voter_bloc/voter_bloc.dart';
import 'package:e_vote/features/ui/presentation/voter_view_candidate_screen.dart';
import 'package:e_vote/features/ui/presentation/voting_done_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class VoterDashboard extends StatelessWidget {
  final TextEditingController _delegateAddController = TextEditingController();
  final TextEditingController _candidateIDController = TextEditingController();
  final VoterBloc _voterBloc = VoterBloc();

  final Firestore _firestore = Firestore.instance;
  var firebaseUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasError) {
            if (Provider.of<Election>(context).state == "CREATED" ||
                Provider.of<Election>(context).state == "ONGOING") {
              print('inside this');
              return FutureBuilder(
                  future: _firestore
                      .collection("users")
                      .where('uid', isEqualTo: firebaseUser.uid)
                      .getDocuments(),
                  builder: (BuildContext context, AsyncSnapshot value) {
                     
                    if (value.connectionState == ConnectionState.none ||
                        value.connectionState == ConnectionState.waiting ||
                        value.hasError) {
                      return CircularProgressIndicator();
                    } else if (value.connectionState == ConnectionState.done) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RaisedButton(
                                    color: Colors.blue,
                                    child: Text(
                                      'View Candidates',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      viewCandidatesPressed(value
                                          .data.documents[0]['privateKey']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.home),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                controller: _delegateAddController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.transform),
                                    labelText: 'Delegate Address'),
                                obscureText: true,
                                autocorrect: false,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                color: Colors.blue,
                                child: Text(
                                  'Delegate Vote',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  delegateCandidatePressed(
                                      value.data.documents[0]["adminKey"],
                                      _delegateAddController.text);
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                controller: _candidateIDController,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.person),
                                    labelText: 'Candidate ID'),
                                obscureText: true,
                                autocorrect: false,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                color: Colors.blue,
                                child: Text(
                                  'Vote!',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () {
                                  final cid =
                                      int.parse(_candidateIDController.text);
                                  votePressed(
                                      value.data.documents[0]["privateKey"],
                                      cid);
                                },
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              BlocBuilder<VoterBloc, VoterState>(
                                  bloc: _voterBloc,
                                  builder:
                                      (BuildContext context, VoterState state) {
                                    if (state is VoterInitial) {
                                      return Container();
                                    }
                                    if (state is ViewCandidate) {
                                      return ViewCandidateScreen(
                                          state.listOfCandidates);
                                    }
                                    if (state is DelegateVote) {
                                      return Text('Delegated Successfully!');
                                    }
                                    if (state is Vote) {
                                      return Text(
                                          'Voted Successfully! Please wait till Election get over for the results!');
                                    }
                                  }),
                            ],
                          ),
                        ),
                      );
                    }
                  });
            } else {
              // print('inside else');
              // _firestore
              //     .collection("admin") 
              //     .where('uid', isEqualTo: firebaseUser.uid)
              //     .getDocuments()
              //     .then((value) =>
              //         VotingDoneScreen(value.documents[0]["privateKey"]));
              return Container(); 
            }
          } else
            return Container();
        });
  }

  void viewCandidatesPressed(String adminKey) {
    _voterBloc.add(ViewCandidateClicked(adminKey));
  }

  void delegateCandidatePressed(String voterKey, String delegateAddress) {
    _voterBloc.add(DelegateVoteClicked(voterKey, delegateAddress));
  }

  void votePressed(String voterKey, int cid) {
    _voterBloc.add(VoteClicked(voterKey, cid));
  }

  Future<void> getCurrentUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
    print(firebaseUser.uid);
  }
}
