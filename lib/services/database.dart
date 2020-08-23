import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final CollectionReference ingredientCollection = FirebaseFirestore.instance.collection('ingredients');

  Stream<QuerySnapshot> get ingredients {
    return ingredientCollection.snapshots();
  }
}