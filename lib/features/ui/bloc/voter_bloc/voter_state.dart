part of 'voter_bloc.dart';

abstract class VoterState extends Equatable {
  const VoterState();
  
  @override
  List<Object> get props => [];
}

class VoterInitial extends VoterState {}
