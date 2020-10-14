import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:e_vote/features/ui/bloc/admin_bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

class AddCandidateScreen extends StatefulWidget {
  @override
  _AddCandidateScreenState createState() => _AddCandidateScreenState();
}

class _AddCandidateScreenState extends State<AddCandidateScreen> {
  AdminBloc adminBloc = AdminBloc();
  TextEditingController nameController;
  TextEditingController proposalController;
  @override
  void initState() {
    nameController = TextEditingController();
    proposalController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => adminBloc,
      child: Container(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(
                Icons.add,
                color: Colors.black.withOpacity(0.75),
                size: 40,
              ),
              onPressed: () {
                showDialog(
                    builder: (context) {
                      return Dialog(
                        child: Container(
                          height: 300,
                          width: 300,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 15, left: 15, bottom: 10),
                                width: 300,
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  'Add a New Candidate',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 25),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 12, bottom: 8, right: 20),
                                child: TextFormField(
                                  controller: nameController,
                                  maxLength: 20,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      labelText: "Name of the Candidate",
                                      icon: Icon(Icons.person)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 12, bottom: 8, right: 20),
                                child: TextFormField(
                                  controller: proposalController,
                                  maxLength: 1000,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      labelText: "Proposal of the Candidate",
                                      icon: Icon(MaterialCommunityIcons
                                          .file_document)),
                                ),
                              ),
                              Center(
                                child: FlatButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      adminBloc.add(AddCandidate(
                                          name: nameController.text,
                                          proposal: proposalController.text));
                                    },
                                    child: Text('Add',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20))),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    context: context);
              }),
          appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.refresh, color: Colors.black,),
                  onPressed: () {
                    adminBloc.add(DisplayCandidates());
                  }),
              IconButton(
              icon: Icon(
                MaterialCommunityIcons.logout,
                color: Colors.black,
              ),
              onPressed: () {
                BlocProvider.of<AuthBloc>(context)..add(LoggedOut());
              })
            ],
            centerTitle: true,
            title: Text(
              'Candidates',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: BlocConsumer(
              listener: (BuildContext context, AdminState state) {
                if (state is AdminError) {
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
                            Flexible(
                              child: Text(
                                state.errorMessage.message,
                                style: TextStyle(color: Colors.white),
                              ),
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
              },
              buildWhen: (previous, current) {
                if (current is AdminError ||
                    current is Loading ||
                    current is ElectionTxHash) {
                  print('lol');
                  return false;
                }
                return true;
              },
              bloc: adminBloc..add(DisplayCandidates()),
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
              }),
        ),
      ),
    );
  }
}
