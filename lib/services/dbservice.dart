import 'package:halal_app/models/ingredientModel.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:stringmatcher/stringmatcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:string_similarity/string_similarity.dart';

class DatabaseService {
  final CollectionReference ingredientCollection = FirebaseFirestore.instance.collection('ingredients');

  Stream<List<IngredientModel>> get ingredients {
    return ingredientCollection.snapshots().map(_toDB);
  }

  List<IngredientModel> _toDB(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return IngredientModel(
        name: doc.data()['name'],
        status: doc.data()['status'],
        comment: doc.data()['comment']
      );
    }).toList();
  }

  void matchDB(ImageModel img, List<IngredientModel> dbList) {
      var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
      var result;
      
      // for (var ingredient in img.ingredients) {
      //   result = StringSimilarity.findBestMatch(ingredient, dbList.map((list) => list.name).toList());
      //   print(result);
      // }

      for (var ingredient in img.ingredients) {
        result = sim.partialSimilarOne(
          ingredient,
          dbList.map((list) => list.name).toList(),
          (a, b) => a.ratio.compareTo(b.ratio),
          selector: (x) => x.percent,
        );

        if (result.item2 > 30.0)
          img.status.add(dbList[dbList.indexWhere((element) => element.name == result.item1)].status);
        else img.status.add('unknown');          
      }
    }
}