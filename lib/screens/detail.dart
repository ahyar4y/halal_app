import 'package:flutter/material.dart';
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

    matchDB() {
      var sim = StringMatcher(term: Term.char, algorithm: Levenshtein());
      var result;

      for (var ingredient in imageData.ingredients) {
        result = sim.partialSimilarOne(
          ingredient,
          dbList.map((list) => list.name).toList(),
          (a, b) => a.ratio.compareTo(b.ratio),
          selector: (x) => x.percent,
        );

        if (result.item2 > 30.0)
          imageData.status.add(dbList[dbList.indexWhere((element) => element.name == result.item1)].status);
        else imageData.status.add('unknown');          
      }
    }

    return StreamBuilder<List<DBIngredient>>(
        stream: DatabaseService().ingredients,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
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
                                    imageData.status[imageData.ingredients
                                        .indexOf(ingredient)],
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
          else
            return Text('loading');
        });
  }
}
