import 'package:halal_app/models/imageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:halal_app/models/ingredientModel.dart';
import 'package:string_similarity/string_similarity.dart';
// import 'package:stringmatcher/stringmatcher.dart';

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

  IngredientModel searchDB(String str, List<IngredientModel> dbList) {
    final result = str.bestMatch(dbList.map((list) => list.name).toList());
    
    if (result.bestMatch.rating > 0.4)
      return dbList[dbList.indexWhere((element) => element.name == result.bestMatch.target)];
    else
      return null;
  }

  void matchDB(ImageModel img, List<IngredientModel> dbList) {
    var result;
    
    for (var ingredient in img.ingredients) {
      result = ingredient.bestMatch(dbList.map((list) => list.name).toList());

      if (result.bestMatch.rating > 0.4)
        img.status.add(dbList[dbList.indexWhere((element) => element.name == result.bestMatch.target)].status);
      else
        img.status.add('unknown');
    }

    // var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
    // for (var ingredient in img.ingredients) {
    //   result = sim.partialSimilarOne(
    //     ingredient,
    //     dbList.map((list) => list.name).toList(),
    //     (a, b) => a.ratio.compareTo(b.ratio),
    //     selector: (x) => x.percent,
    //   );
    //   print(result);

    //   if (result.item2 > 30.0)
    //     img.status.add(dbList[dbList.indexWhere((element) => element.name == result.item1)].status);
    //   else img.status.add('unknown');          
    // }
  }
}