import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_vote/features/ui/bloc/admin_bloc/admin_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  AdminBloc _adminBloc;

  final Firestore _firestore = Firestore.instance;
  var firebaseUser;
  String privateKey;

  final List<String> voterAddresses = [];
  final List<String> candidateNames = [];
  final List<String> candidateProposals = [];

  TextEditingController _candidateNameController = TextEditingController();
  TextEditingController _candidateProposalController = TextEditingController();
  TextEditingController _voterAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          _firestore
              .collection("users")
              .where('uid', isEqualTo: firebaseUser.uid)
              .getDocuments()
              .then((value) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text('Admin Dashboard'),
                centerTitle: true,
                backgroundColor: Colors.deepPurpleAccent,
                automaticallyImplyLeading: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Add Candidate Section:"),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _candidateNameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'CANDIDATE NAME',
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _candidateProposalController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'CANDIDATE PROPOSAL',
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              RaisedButton(
                                child: Text('Add Candidate'),
                                onPressed: () async {
                                  privateKey =
                                      value.documents[0]['privateKey'];
                                  addCandidatePressed(
                                      _candidateNameController.text,
                                      _candidateProposalController.text,
                                      privateKey);
                                  _candidateNameController.clear();
                                  _candidateProposalController.clear();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Add Voter Section:"),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                controller: _voterAddressController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'VOTER ADDRESS',
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              RaisedButton(
                                child: Text('Add Voter'),
                                onPressed: () async {
                                  privateKey =
                                      value.documents[0]['privateKey'];
                                  addVoterPressed(
                                      _voterAddressController.text, privateKey);
                                  _voterAddressController.clear();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                child: Text('Start Elections'),
                                onPressed: () async {
                                  privateKey =
                                      value.documents[0]['privateKey'];
                                  electionStatusChanged("START", privateKey);
                                },
                              ),
                              RaisedButton(
                                child: Text('End Elections'),
                                onPressed: () async {
                                  privateKey =
                                      value.documents[0]['privateKey'];
                                  electionStatusChanged("STOP", privateKey);
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        BlocBuilder(
                            bloc: _adminBloc,
                            builder: (BuildContext context, AdminState state) {
                              if (state is ProcessingState) {
                                return CircularProgressIndicator();
                              }
                              if (state is AddCandidateOrVoter) {
                                return Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text('List of Candidates:'),
                                                ListView.builder(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    itemCount:
                                                        candidateNames.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        height: 70.0,
                                                        margin:
                                                            EdgeInsets.all(2),
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        child: Center(
                                                          child: Text(
                                                            ' Candidate ${candidateNames[index]} proposes ${candidateProposals[index]}',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                ListView.builder(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    itemCount:
                                                        voterAddresses.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return Container(
                                                        height: 70.0,
                                                        margin:
                                                            EdgeInsets.all(2),
                                                        color: Colors
                                                            .deepPurpleAccent,
                                                        child: Center(
                                                          child: Text(
                                                            ' Voter ${index + 1} address ${voterAddresses[index]}',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                              if (state is HandleElectionStatus) {
                                return Text(
                                    "The Elections have ${state.status}ED");
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  void electionStatusChanged(String status, String privateKey) {
    _adminBloc.add(HandleElectionStatusClicked(status, privateKey));
  }

  void addCandidatePressed(
      String nameOfCandidate, String proposal, String privateKey) {
    candidateNames.add(nameOfCandidate);
    candidateProposals.add(proposal);
    _adminBloc.add(AddCandidateClicked(nameOfCandidate, proposal, privateKey));
  }

  void addVoterPressed(String voterAddress, String privateKey) {
    voterAddresses.add(voterAddress);
    _adminBloc.add(AddVoterClicked(voterAddress, privateKey));
  }

  Future<void> getCurrentUser() async {
    firebaseUser = await FirebaseAuth.instance.currentUser();
  }
}
