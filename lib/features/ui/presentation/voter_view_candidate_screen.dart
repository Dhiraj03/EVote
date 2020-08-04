import 'package:e_vote/backend/Candidate.dart';
import 'package:flutter/material.dart';

class ViewCandidateScreen extends StatelessWidget {
  List<Candidate> listOfCandidates;

  ViewCandidateScreen(this.listOfCandidates);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
          itemCount: listOfCandidates.length,
          itemBuilder: (BuildContext context, int index) {
            return  Text(
              '${listOfCandidates[index].id}: ${listOfCandidates[index].name} proposes, ${listOfCandidates[index].proposal}',
            );
          }),
    );
  }
}
