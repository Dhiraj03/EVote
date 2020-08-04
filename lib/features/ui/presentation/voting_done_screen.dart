import 'package:e_vote/backend/Candidate.dart';
import 'package:e_vote/backend/Election.dart';
import 'package:flutter/material.dart';

class VotingDoneScreen extends StatelessWidget {
  final Election _election = Election();
  String winner = '';
  final String privateKey;
  List<Candidate> list;

  VotingDoneScreen(this.privateKey) {}

  void showWinner() async {
    winner = await _election.showWinner(this.privateKey);
  }

  void showResults() async {
    list = await _election.showResults();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                showWinner();
              },
              child: Text(
                'Show Winner',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(winner),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed: () {
                showWinner();
              },
              child: Text(
                'Show Results',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Text(
                      'Candidate ${list[index].id} named ${list[index].name}');
                }),
          ],
        ),
      ),
    );
  }
}
