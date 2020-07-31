import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class User extends Equatable {
  // Creates an instance of the the auth class corresponding to this project
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  @override
  List<Object> get props => [];

  
}
