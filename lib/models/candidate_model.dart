import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Candidate extends Equatable {
  final String address;
  final int id;
  final int count;
  final String name;
  final String proposal;
  Candidate({this.count, this.address, this.name, this.id, this.proposal});
  List<Object> get props => [address, count, name, id, proposal];

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
        id: json["id"], name: json["name"], proposal: json["proposal"]);
  }

  factory Candidate.result(Map<String, dynamic> json) {
    return Candidate(id: json["id"], name: json["name"], count: json["count"]);
  }

  factory Candidate.winner(Map<String, dynamic> json) {
    return Candidate(id: json["id"], name: json["name"], count: json["votes"]);
  }
}
