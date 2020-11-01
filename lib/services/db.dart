import 'package:halal_app/models/imageModel.dart';
import 'package:stringmatcher/stringmatcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halal_app/models/ingredientModel.dart';

class DatabaseService {
  final String ingredientId;
  DatabaseService({this.ingredientId});

  final CollectionReference _ingredientCollection =
      FirebaseFirestore.instance.collection('ingredients');

  final _lev = StringMatcher(term: Term.char, algorithm: Levenshtein());

  Stream<List<IngredientModel>> get ingredients {
    return _ingredientCollection.snapshots().map(_toDB);
  }

  Stream<IngredientModel> get ingredient {
    return _ingredientCollection.doc(ingredientId).snapshots().map(_toModel);
  }

  List<IngredientModel> _toDB(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return IngredientModel(
          id: doc.id,
          name: doc.data()['name'],
          status: doc.data()['status'],
          comment: doc.data()['comment']);
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  IngredientModel _toModel(DocumentSnapshot snapshot) {
    return IngredientModel(
      id: ingredientId,
      name: snapshot.data()['name'],
      status: snapshot.data()['status'],
      comment: snapshot.data()['comment']
    );
  }

  List<String> matchDB(
      ImageModel img, String ingredient, List<IngredientModel> dbList) {
    final _result = _lev.partialSimilarOne(
        ingredient.toLowerCase(),
        dbList.map((list) => list.name).toList(),
        (a, b) => a.ratio.compareTo(b.ratio),
        selector: (x) => x.percent);

    if (_result.item2 > 35.0)
      return [
        dbList[dbList.indexWhere((element) => element.name == _result.item1)]
            .status,
        dbList[dbList.indexWhere((element) => element.name == _result.item1)]
            .comment
      ];
    else
      return ['unknown', 'data not available'];
  }

  Future<void> addDB(String name, String status, String comment) async {
    return await _ingredientCollection.add({
      'name': name,
      'status': status,
      'comment': comment,
    });
  }

  Future<void> updateDB(String name, String status, String comment) async {
    return await _ingredientCollection.doc(ingredientId).set({
      'name': name,
      'status': status,
      'comment': comment,
    });
  }

  Future<void> deleteDB() async {
    return await _ingredientCollection.doc(ingredientId).delete();
  }
}
