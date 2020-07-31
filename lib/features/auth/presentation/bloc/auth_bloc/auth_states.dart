import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthState extends Equatable {
  AuthState([List props = const <dynamic>[]]) : super();
}

class Uninitialized extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthState {
  @override
  List<Object> get props => [displayName];

  final String displayName;
  Authenticated(this.displayName);

  @override
  String toString() => 'Authenticated {display name : $displayName}';

}

class Unauthenticated extends AuthState {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Unauthenticated';
}




