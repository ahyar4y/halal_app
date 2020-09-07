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

    Color statColor(String str) {
      if (str == 'halal')
        return Colors.green;
      else if (str == 'haram')
        return Colors.red;
      else if (str == 'doubtful')
        return Colors.yellow[700];
      else
        return Colors.black;
    }

    return FutureBuilder(
        future: ocr,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Loading();

          return Scaffold(
            appBar: AppBar(
              title: Text('Detail'),
              elevation: 0,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 300,
                      child: Image.file(File(img.image)),
                    ),
                    Divider(
                      height: 20.0,
                      color: Colors.black,
                    ),
                    Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 26.0,
                      ),
                    ),
                    Divider(
                      height: 10.0,
                      color: Colors.black,
                    ),
                    StreamBuilder<List<IngredientModel>>(
                        stream: DatabaseService().ingredients,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Loading();

                          for (var i = 0; i < img.ingredientsLength; i++) {
                            img.setStatus(DatabaseService()
                                .matchDB(img, img.getIngredient(i), dbList));
                          }

                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: img.ingredientsLength,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 0.0,
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 3.0),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        iconSize: 16.0,
                                        onPressed: () {
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 20.0,
                                                      horizontal: 60.0),
                                                  child: EditIngredient(
                                                    img.getIngredient(index),
                                                    index,
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          img.getIngredient(index),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          img.getStatus(index),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color:
                                                statColor(img.getStatus(index)),
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class EditIngredient extends StatefulWidget {
  final String ingredient;
  final int index;

  EditIngredient(this.ingredient, this.index);

  @override
  _EditIngredientState createState() => _EditIngredientState();
}

class _EditIngredientState extends State<EditIngredient> {
  String newIngredient;

  @override
  Widget build(BuildContext context) {
    final img = Provider.of<ImageModel>(context);
    final dbList = Provider.of<List<IngredientModel>>(context);

    return Column(
      children: [
        Text('Edit ingredient:'),
        TextFormField(
          initialValue: this.widget.ingredient,
          onChanged: (value) => setState(() => newIngredient = value),
        ),
        FlatButton(
          color: Theme.of(context).primaryColor,
          child: Text('OK'),
          onPressed: () {
            img.editIngredient(this.widget.index, newIngredient);
            img.editStatus(
                this.widget.index,
                DatabaseService().matchDB(
                    img, img.getIngredient(this.widget.index), dbList));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
