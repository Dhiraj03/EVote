import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Voter extends Equatable {
  final int id;
  final String name;
  final String address;
  final bool hasVoted;
  final int weight;
  final int voteTowards;
  String delegateAddress;
  Voter(
      {this.id,
      this.delegateAddress,
      @required this.address,
      this.hasVoted,
      this.name,
      this.voteTowards,
      @required this.weight});

  List<Object> get props =>
      [address, hasVoted, name, voteTowards, delegateAddress, weight];

  factory Voter.fromJson(Map<String, dynamic> json) {
    return Voter(
        id: json["id"],
        delegateAddress: json["delegate"],
        weight: json["weight"],
        address: json["voterAddress"]);
  }

  factory Voter.profileJson(Map<String, dynamic> json, String voterAddress) {
    return Voter(
      address: voterAddress, 
      weight: json["weight"],
      delegateAddress: json["delegate"],
      name: json["name"],
      voteTowards: json["votedTowards"],
      id: json["id"]
      );
  }
}
