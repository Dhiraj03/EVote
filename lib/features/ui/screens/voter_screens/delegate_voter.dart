import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:e_vote/features/ui/bloc/voter_bloc/voter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class DelegateVoterPage extends StatefulWidget {
  @override
  _DelegateVoterPageState createState() => _DelegateVoterPageState();
}

class _DelegateVoterPageState extends State<DelegateVoterPage> {
  VoterBloc voterBloc;
  TextEditingController delegateController;
  @override
  void initState() {
    voterBloc = VoterBloc();
    delegateController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => voterBloc,
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
                      voterBloc.add(GetVoterProfile());
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
                'Delegate Vote',
                style: TextStyle(color: Colors.black87),
              ),
            ),
            body: BlocConsumer(
                bloc: voterBloc..add(GetVoterProfile()),
                buildWhen: (previous, current) {
                  if (current is VoterError ||
                      current is Loading ||
                      current is ElectionTxHash) {
                    return false;
                  }
                  return true;
                },
                builder: (BuildContext context, VoterState state) {
                  if (state is VoterProfileState) {
                    if (BigInt.parse(
                            state.voterProfile.delegateAddress).toInt() ==
                        0) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, top: 12, bottom: 8, right: 20),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  controller: delegateController,
                                  maxLength: 42,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      labelText: "Address of the Delegate",
                                      icon: Icon(Icons.person)),
                                ),
                                FlatButton(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      voterBloc.add(DelegateVote(
                                          delegateAddress:
                                              delegateController.text));
                                    },
                                    child: Text(
                                      'DELEGATE',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    ))
                              ]),
                        ),
                      );
                    } else {
                      return Center(
                        
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            Flexible(
                              child: Text(
                                "You have already delegated your vote to ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            SizedBox(height: 17,),
                            Flexible(
                              child: Text(
                                state.voterProfile.delegateAddress,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context).accentColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ]),
                        ),
                      );
                    }
                  } else
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    );
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
                })),
      ),
    );
  }
}
