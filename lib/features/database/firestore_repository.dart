import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  static final firestoreRepository = Firestore.instance;
  /*The collection that will hold all the data of the users is called 'users'.
   Each document under the 'users' collection will reference a user.
  */
  final CollectionReference ref = firestoreRepository.collection('users');
  void storeBasicInfo(String uid, bool isAdmin, String privateKey,
      bool hasVoted, String address) {
    ref.add(<String, dynamic>{
      'uid': uid,
      'isAdmin': isAdmin,
      'privateKey': privateKey,
      'address': address,
      'delegated': false,
      'hasVoted': hasVoted
    });
  }

  Future<bool> checkIfUserExists(String uid) async{
    final querySnapshot = await ref.where('uid', isEqualTo: uid).getDocuments();
    if (querySnapshot.documents.length == 0) return false;
    return true;
  }

  Future<bool> isAdmin(String uid) async {
    final querySnapshot = await ref.where('uid', isEqualTo: uid).getDocuments();
    print(querySnapshot.documents.length);
    return querySnapshot.documents[0]['isAdmin'];
  }

  Future<String> getPrivateKey(String uid) async {
    final querySnapshot = await ref.where('uid', isEqualTo: uid).getDocuments();
    print(querySnapshot.documents.length);
    return querySnapshot.documents[0]['privateKey'];
  }

  Future<bool> hasVoted(String uid) async {
    final querySnapshot = await ref.where('uid', isEqualTo: uid).getDocuments();
    print(querySnapshot.documents.length);
    return querySnapshot.documents[0]['hasVoted'];
  }

  Future<bool> hasDelegate(String uid) async {
    final querySnapshot = await ref.where('uid', isEqualTo: uid).getDocuments();
    print(querySnapshot.documents.length);
    return querySnapshot.documents[0]['delegated'];
  }

  Future<bool> checkIfAddressExists(String address) async {
    final querySnapshot =
        await ref.where('address', isEqualTo: address).getDocuments();
    if (querySnapshot.documents.length == 0) return true;
    return false;
  }

  void delegateVote(String uid, String delegateAddress) async {
    final querySnapshot = await ref.where('uid', isEqualTo: uid).getDocuments();
    print(querySnapshot.documents.length);
    querySnapshot.documents[0].data['delegated'] = true;
    querySnapshot.documents[0].data['delegateAddress'] = delegateAddress;
  }

  Future<String> getAddress(String uid) async {
    final querySnapshot = await ref.where('uid', isEqualTo: uid).getDocuments();
    print(querySnapshot.documents.length);
    return querySnapshot.documents[0]['address'];
  }
}
