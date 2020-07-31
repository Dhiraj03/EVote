
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreRepository {
  static final firestoreRepository = Firestore.instance;
  final CollectionReference ref = firestoreRepository.collection('users');
  void getUsers() async {
    final snapshot =
        await ref.where('name', isEqualTo: 'Dhiraj').getDocuments();
    for (int i = 0; i < snapshot.documents.length; i++) {
      print(snapshot.documents[i]['isAdmin']);
    }
  }
}
