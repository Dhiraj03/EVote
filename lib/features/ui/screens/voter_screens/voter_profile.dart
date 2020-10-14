import 'package:e_vote/features/ui/bloc/voter_bloc/voter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      create: (_) => voterBloc..add(GetVoterProfile()),
      child: BlocConsumer<VoterBloc, VoterState>(
          builder: (BuildContext context, VoterState state) {
            if (state is VoterProfileState) {
              return Container(
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Text(state.voterProfile.address)
                    ],
                  ),    
                      );
            }
            else  {
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
          listener: (BuildContext context, VoterState state) {}),
    );
  }
}
