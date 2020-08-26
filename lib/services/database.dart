import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final CollectionReference ingredientCollection = FirebaseFirestore.instance.collection('ingredients');

  Future<String> find(String data) async {
    String result;
    QuerySnapshot qs = await ingredientCollection.where("name", isEqualTo: data).get();
    qs.docs.forEach((doc) {
      result = doc.data()['status'];
    });

    return result;
  }

  Stream<QuerySnapshot> get ingredients {
    return ingredientCollection.snapshots();
  }
}