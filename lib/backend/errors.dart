import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends Equatable {
  final String message;
  ErrorMessage({@required this.message});
  @override
  List<Object> get props => [message];
}
