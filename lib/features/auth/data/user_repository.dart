import 'package:e_vote/database/firestore_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

/* if FirebaseAuth/ GoogleSignIn are not injected into an instance of UserRepository,
then we instantiate them internally - allows us to inject mock instances so that we can easily test the 
UserRepository
*/
class UserRepository {
  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  final FirestoreRepository firestoreRepository = FirestoreRepository();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) {
    // final AuthResult res = await _firebaseAuth.signInWithEmailAndPassword(
    //     email: email, password: password);
    // final FirebaseUser user = res.user;
    // return
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    firestoreRepository.createNewUser(email);
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return Future.wait<dynamic>(
        [_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser();
    return currentUser != null;
  }

  // use this to get the UID instead
  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future<String> getUserEmail() async {
    print('lol');
    return (await _firebaseAuth.currentUser()).email;
  }
}
