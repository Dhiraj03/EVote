import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Voter extends Equatable {
  final String name;
  final String address;
  final bool hasVoted;
  final int weight;
  final int voteTowards;
  String delegateAddress;
  Voter(
      {
      this.delegateAddress,
      @required this.address,
      @required this.hasVoted,
      @required this.name,
      @required this.voteTowards,
      @required this.weight});

  List<Object> get props =>
      [address, hasVoted, name, voteTowards, delegateAddress, weight];
}
