import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:halal_app/models/imageData.dart';
import 'package:halal_app/services/database.dart';

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var imageData = Provider.of<ImageData>(context);
    imageData.setIngredients();

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
              child: Center(
                child: Text('img here'),
              ),
              // child: Image.file(File(imageData.image)),
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10),
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
                          padding: EdgeInsets.only(top: 5, bottom: 5),
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
                          padding: EdgeInsets.only(top: 5, bottom: 5),
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