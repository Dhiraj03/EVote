import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Candidate extends Equatable {
  final String address;
  final int id;
  final int count;
  final String name;
  final String proposal;
  Candidate(
      {this.count,
      @required this.address,
      @required this.name,
      @required this.id,
      @required this.proposal});
  List<Object> get props => [address, count, name, id, proposal];
}
