import 'package:cloud_firestore/cloud_firestore.dart';

class DBIngredient {
  final String name;
  final String status;
  final String comment;

  DBIngredient({this.name, this.status, this.comment});
}

class DatabaseService {
  final CollectionReference ingredientCollection = FirebaseFirestore.instance.collection('ingredients');

  List<DBIngredient> toDB(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return DBIngredient(
        name: doc.data()['name'],
        status: doc.data()['status'],
        comment: doc.data()['comment']
      );
    }).toList();
  }

  Stream<List<DBIngredient>> get ingredients {
    return ingredientCollection.snapshots().map(toDB);
  }
}