import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:e_vote/features/auth/presentation/bloc/auth_bloc/auth_events.dart';
import 'package:e_vote/features/ui/bloc/admin_bloc/admin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

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
                            Image.asset(
                              "assets/404-error.png",
                              height: 100,
                              width: 100,
                            )
                          ]),
                    ),
                  );
                } else if (state is Results) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(right: 8.0, left: 8.0, top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 200,
                          width: 400,
                          child: Column(
                            children: <Widget>[
                              Image.asset("assets/trophy.png",
                                  height: 100, width: 100),
                              SizedBox(
                                height: 10,
                              ),
                              Card(
                                elevation: 0.3,
                                color: Color(0xFFFAFAFA),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color(0xFFDCDCDC), width: 0.5),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  state.winner.id.toString(),
                                                  style: TextStyle(
                                                      color: Color(0xff495057),
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w400)),
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
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Flexible(
                                               child: Text(
                                                  state.winner.name.toString(),
                                                  style: TextStyle(
                                                      color: Color(0xff2F2F2F),
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            )
                                          ],
                                        ),
                                      ]),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'RESULTS',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.all(8),
                            itemCount: state.results.length,
                            itemBuilder: (BuildContext context, int i) {
                              return Card(
                                elevation: 0.3,
                                color: Color(0xFFFAFAFA),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Color(0xFFDCDCDC), width: 0.5),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  state.results[i].id
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Color(0xff495057),
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w400)),
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
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Flexible(
                                              child: Text(
                                                  state.results[i].name
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Color(0xff2F2F2F),
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text('Vote Count:      ',
                                                style: TextStyle(
                                                    color: Color(0xff2F2F2F),
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Flexible(
                                              child: Text(
                                                  state.results[i].count
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Color(0xff2F2F2F),
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            )
                                          ],
                                        )
                                      ]),
                                ),
                              );
                            })
                      ],
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
