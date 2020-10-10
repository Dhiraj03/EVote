import 'package:e_vote/features/ui/bloc/admin_bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Dashboard',
                style: TextStyle(color: Colors.black87),
              ),
            ),
            body: BlocBuilder(
              bloc: BlocProvider.of<AdminBloc>(context)
                ..add(GetElectionDetails()),
              builder: (BuildContext context, AdminState state) {
                if (state is ElectionDetailsState) {
                  return Container();
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }
              },
            )));
  }
}
