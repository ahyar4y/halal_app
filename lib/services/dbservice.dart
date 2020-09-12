import 'package:halal_app/models/imageModel.dart';
import 'package:stringmatcher/stringmatcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halal_app/models/ingredientModel.dart';

class DatabaseService {
  final CollectionReference _ingredientCollection =
      FirebaseFirestore.instance.collection('ingredients');

  final _lev = StringMatcher(term: Term.char, algorithm: Levenshtein());

  Stream<List<IngredientModel>> get ingredients {
    return _ingredientCollection.snapshots().map(_toDB);
  }

  List<IngredientModel> _toDB(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return IngredientModel(
          name: doc.data()['name'],
          status: doc.data()['status'],
          comment: doc.data()['comment']);
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
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
}
