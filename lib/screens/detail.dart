import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/screens/loading.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:halal_app/services/dbService.dart';
import 'package:halal_app/services/ocrService.dart';
import 'package:halal_app/models/ingredientModel.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  Future ocr;

  @override
  void initState() {
    super.initState();

    final img = Provider.of<ImageModel>(context, listen: false);
    ocr = OCRService().readImage(img);
  }

  @override
  Widget build(BuildContext context) {
    final img = Provider.of<ImageModel>(context);
    final dbList = Provider.of<List<IngredientModel>>(context) ?? [];

    return FutureBuilder(
      future: ocr,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                    child: Image.file(File(img.image)),
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
                  StreamBuilder<List<IngredientModel>>(
                    stream: DatabaseService().ingredients,
                    builder: (context, snapshot) {
                      if (snapshot.hasData){
                        DatabaseService().matchDB(img, dbList);

                        return Container(
                          margin: EdgeInsets.all(10),
                          child: Column(
                            children: img.ingredients.map((ingredient) {
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
                                        img.status[img.ingredients.indexOf(ingredient)],
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
                        );
                      }
                      else return Loading();
                    }
                  ),
                ],
              ),
            ),
          );
        }
        else return Loading();
      }
    );
  }
}
