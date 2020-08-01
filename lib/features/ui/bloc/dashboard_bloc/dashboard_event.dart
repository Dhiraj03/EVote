part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class CheckIfUserIsRegistered extends DashboardEvent {
  @override
  List<Object> get props => [];
}

class RegisterUser extends DashboardEvent {
  final String privateKey;
  final String address;
  RegisterUser({this.address, this.privateKey});

  @override
  List get props => <dynamic>[address, privateKey];
}
