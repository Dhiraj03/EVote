import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_barrel_bloc.dart';
import 'package:e_vote/features/ui/bloc/voter_bloc/voter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class VoterProfile extends StatefulWidget {
  @override
  _VoterProfileState createState() => _VoterProfileState();
}

class _VoterProfileState extends State<VoterProfile> {
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
              'My Profile',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: BlocConsumer<VoterBloc, VoterState>(
                  bloc: voterBloc..add(GetVoterProfile()),
                  builder: (BuildContext context, VoterState state) {
                    if (state is VoterProfileState) {
                      print('lol');
                      return Card(
                        elevation: 0.3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView(children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 1.5)),
                                child: Center(
                                  child: Icon(Icons.person,
                                      size: 170,
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text('VOTER ID',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12),
                                child: Center(
                                    child: Text(
                                        state.voterProfile.id == 0
                                            ? "Unregistered"
                                            : state.voterProfile.id.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .accentColor))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text('VOTER ADDRESS',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12),
                                child: Center(
                                    child: SelectableText(
                                        
                                        state.voterProfile.address.toString(),
                                        toolbarOptions: ToolbarOptions(
                                          copy: true
                                        ),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .accentColor))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text('VOTER DELEGATE ADDRESS',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12),
                                child: Center(
                                    child: Text(
                                        BigInt.parse(state.voterProfile
                                                        .delegateAddress)
                                                    .toInt() ==
                                                0
                                            ? "Not Delegated"
                                            : state.voterProfile.delegateAddress
                                                .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .accentColor))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text('VOTER WEIGHT',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12),
                                child: Center(
                                    child: Text(
                                        state.voterProfile.weight == 0
                                            ? ( BigInt.parse(state.voterProfile
                                                    .delegateAddress)
                                                .toInt() ==
                                            0 ? "Unregistered" : "Vote delegated")
                                            : state.voterProfile.weight
                                                .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .accentColor))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Center(
                                child: Text('VOTED TOWARDS',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: Theme.of(context).primaryColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12),
                                child: Center(
                                    child: Text(
                                        state.voterProfile.voteTowards == 0
                                            ? ( BigInt.parse(state.voterProfile
                                                    .delegateAddress)
                                                .toInt() ==
                                            0 ? "Not voted yet" : "Vote delegated")
                                            : state.voterProfile.voteTowards
                                                .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .accentColor))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ])),
                      );
                    } else {
                      BlocProvider.of<VoterBloc>(context)
                        ..add(GetVoterProfile());
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      );
                    }
                  },
                  listener: (BuildContext context, VoterState state) {})),
        )));
  }
}
