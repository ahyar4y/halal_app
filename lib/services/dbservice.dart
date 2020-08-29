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

  Future<String> find(String data) async {
    QuerySnapshot qs = await ingredientCollection.where("name", isEqualTo: data).get();
    String result;

    for (var doc in qs.docs) {
      result = doc.data()['status'];
    }

    return result;
  }

  Stream<List<DBIngredient>> get ingredients {
    return ingredientCollection.snapshots().map(toDB);
  }
}