
import 'package:e_vote/features/ui/bloc/user_bloc/user_bloc_bloc.dart';
import 'package:e_vote/models/candidate_model.dart';
import 'package:e_vote/models/voter_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ElectionModel extends Equatable {
  final String adminAddress;
  final String description;
  final int candidateCount;
  List<Candidate> candidates;
  List<Voter> voters;
  Candidate winner;
  ElectionModel(
      {@required this.adminAddress,
      this.candidateCount,
      this.candidates,
      @required this.description,
      this.voters,
      this.winner});
  List<Object> get props =>
      [adminAddress, description, candidateCount, candidates, voters, winner];
}
