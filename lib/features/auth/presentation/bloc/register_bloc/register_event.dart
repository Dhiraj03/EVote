part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

class EmailChanged extends RegisterEvent {
  final String email;
  EmailChanged({@required this.email});
  @override
  List get props => <dynamic>[email];

  @override
  String toString() => 'Email Changed : {email : $email}';
}

class PasswordChanged extends RegisterEvent {
  final String password;
  PasswordChanged({@required this.password});
  @override
  String toString() => 'Password Changed : {password : $password}';
  @override
  List get props => <dynamic>[password];
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;

  Submitted({@required this.email, @required this.password})
      : super();

  @override
  String toString() {
    return 'Submitted { email: $email, password: $password }';
  }

  @override
  List get props => <dynamic>[email, password];
}

