import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:e_vote/features/ui/bloc/voter_bloc/voter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class VoterDashboardPage extends StatefulWidget {
  @override
  _VoterDashboardPageState createState() => _VoterDashboardPageState();
}

class _VoterDashboardPageState extends State<VoterDashboardPage> {
  VoterBloc voterBloc;

  @override
  void initState() {
    voterBloc = VoterBloc();
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
                    voterBloc.add(ShowElectionDetails());
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
              'Dashboard',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: BlocConsumer<VoterBloc, VoterState>(
              bloc: voterBloc..add(ShowElectionDetails()),
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
              },
              buildWhen: (previous, current) {
                if (current is VoterError ||
                    current is Loading ||
                    current is ElectionTxHash) {
                  print('lol');
                  return false;
                }
                return true;
              },
              builder: (BuildContext context, VoterState state) {
                if (state is ElectionDetailsState) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: Text('ADMIN  ADDRESS',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12),
                          child: Center(
                            child: Text(state.adminAddress,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).accentColor)),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text('DESCRIPTION',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12),
                          child: Center(
                              child: Text(state.description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).accentColor))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text('ELECTION STATE',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12),
                          child: Center(
                              child: Text(state.electionState,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).accentColor))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]);
                } else {
                  BlocProvider.of<VoterBloc>(context)
                    ..add(ShowElectionDetails());
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
