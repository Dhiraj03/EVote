import 'package:e_vote/features/ui/bloc/voter_bloc/voter_bloc.dart';
import 'package:e_vote/features/ui/screens/admin_screens/election_results.dart';
import 'package:e_vote/features/ui/screens/voter_screens/delegate_voter.dart';
import 'package:e_vote/features/ui/screens/voter_screens/election_results_page.dart';
import 'package:e_vote/features/ui/screens/voter_screens/show_candidates.dart';
import 'package:e_vote/features/ui/screens/voter_screens/voter_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class VoterDashboard extends StatefulWidget {
  @override
  _VoterDashboardState createState() => _VoterDashboardState();
}

class _VoterDashboardState extends State<VoterDashboard>
    with SingleTickerProviderStateMixin {
  PageController pageController;
  TabController tabController;
  VoterBloc voterBloc;
  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    tabController = TabController(length: 4, vsync: this);
    voterBloc = VoterBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        allowImplicitScrolling: true,
        onPageChanged: (index) {
          tabController.index = index;
        },
        controller: pageController,
        children: <Widget>[
          ElectionResults(),
          ShowCandidates(),
          VoterDashboardPage(),
          DelegateVoterPage()
        ],
      
      ),
      bottomNavigationBar: TabBar(
    labelColor: Color(0xff373737),
    indicatorColor: Theme.of(context).primaryColor,
    unselectedLabelColor: Color(0xCC8e8e8e),
    controller: tabController,
    onTap: (index) {
      pageController.jumpToPage(index);
    },
    tabs: [
      Tab(icon: ImageIcon(AssetImage("assets/winning.png")),),
      Tab(icon: Icon(MaterialIcons.person_add)),
      Tab(icon: Icon(MaterialCommunityIcons.view_dashboard)),
      Tab(icon: ImageIcon(AssetImage("assets/voter.png"))),
    ]),
    );
  }
}
