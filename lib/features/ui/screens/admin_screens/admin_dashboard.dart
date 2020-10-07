import 'package:e_vote/features/ui/bloc/admin_bloc/admin_bloc.dart';
import 'package:e_vote/features/ui/screens/admin_screens/add_candidate.dart';
import 'package:e_vote/features/ui/screens/admin_screens/add_voter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  PageController pageController;
  TabController tabController;
  @override
  void initState() {
    pageController = PageController();
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdminBloc>(
          create: (_) => AdminBloc(),
          child: Scaffold(
          body: PageView(
            allowImplicitScrolling: true,
            onPageChanged: (index) {
              tabController.index = index;
            },
            controller: pageController,
            children: <Widget>[AddCandidateScreen(), AddVoterScreen()],
          ),
          bottomNavigationBar: TabBar(
              labelColor: Theme.of(context).accentColor,
              unselectedLabelColor: Colors.white54,
              controller: tabController,
              onTap: (index) {
                pageController.jumpToPage(index);
              },
              tabs: [
                Tab(icon: Icon(MaterialIcons.person_add)),
                Tab(icon: Icon(FlutterIcons.vote_mco)),
              ])),
    );
  }
}
