import 'package:e_vote/features/ui/bloc/admin_bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ElectionResultsPage extends StatefulWidget {
  @override
  _ElectionResultsPageState createState() => _ElectionResultsPageState();
}

class _ElectionResultsPageState extends State<ElectionResultsPage> {
  AdminBloc adminBloc;
  @override
  void initState() {
    adminBloc = AdminBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => adminBloc,
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
                    adminBloc.add(ShowResults());
                  })
            ],
            centerTitle: true,
            title: Text(
              'Election Results',
              style: TextStyle(color: Colors.black87),
            ),
          ),
          body: BlocConsumer<AdminBloc, AdminState>(
              bloc: adminBloc..add(ShowResults()),
              buildWhen: (AdminState prev, AdminState curr) {
                if (curr is Loading) return false;
                return true;
              },
              builder: (BuildContext context, AdminState state) {
                if (state is AdminError) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        Flexible(
                          child: Text(
                            state.errorMessage.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Image.asset("assets/404-error.png", height: 100,width: 100,)
                      ]),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  );
                }
              },
              listener: (BuildContext context, AdminState state) {}),
        ),
      ),
    );
  }
}
