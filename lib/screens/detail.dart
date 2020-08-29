import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halal_app/functions/horspool.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:halal_app/models/imageData.dart';
import 'package:halal_app/services/dbservice.dart';
import 'package:stringmatcher/stringmatcher.dart';

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageData = Provider.of<ImageData>(context);
    final dbList = Provider.of<List<DBIngredient>>(context) ?? [];
    final database = Provider.of<DatabaseService>(context);

    matchDB() async {
      // List<String> stat = [];
      // int i = 0;

      var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
      print(sim.partialSimilarOne('Soybean', ['Soybean', 'Soybean Oil'], (a, b) => 
        a.ratio.compareTo(b.ratio),
        selector: (x) => x.percent,
      ).item1.toString());
      

      // for (var ingredient in imageData.ingredients) {
      //   for (var db in dbList) {
      //     if (Horspool(ingredient, db.name).search()) stat.add(db.status);
      //     else stat.add('unknown');
      //   }
      // }

      // for (var ingredient in imageData.ingredients) {
      //   stat.add(await database.find(ingredient) ?? 'unknown');
      // }

      // stat.forEach((el) {
      //   print('$i ${imageData.ingredients[i++]} $el');
      // });

      // database.ingredientCollection.snapshots().map((snapshot) {
      //   for (var doc in snapshot.docs) {
      //     if (Horspool('Sugar', doc.data()['name']).search()) stat.add(doc.data()['status']);
      //     else stat.add('unknown');
      //   }
      // });
    }

    matchDB();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(10),
              height: 300,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              // child: Center(
              //   child: Text('img here'),
              // ),
              child: Image.file(File(imageData.image)),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Status',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: imageData.ingredients.map((ingredient) {
                  return Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            ingredient,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            imageData.status[imageData.ingredients.indexOf(ingredient)],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}