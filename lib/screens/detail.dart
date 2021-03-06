import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/services/db.dart';
import 'package:halal_app/services/ocr.dart';
import 'package:halal_app/screens/loading.dart';
import 'package:halal_app/shared/infoAlert.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:halal_app/shared/statusColor.dart';
import 'package:halal_app/shared/customDialog.dart';
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

    final ImageModel img = Provider.of<ImageModel>(context, listen: false);
    ocr = OCRService(img).readImage();
  }

  @override
  Widget build(BuildContext context) {
    final ImageModel img = Provider.of<ImageModel>(context);
    final List<IngredientModel> dbList =
        Provider.of<List<IngredientModel>>(context) ?? <IngredientModel>[];

    return FutureBuilder<dynamic>(
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
                          if (img.ingredients.isEmpty)
                            return Text(
                              'No ingredients found, please try again',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20.0,
                              ),
                            );

                          return ResultList(img: img, list: dbList);
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class ResultList extends StatelessWidget {
  final ImageModel img;
  final List<IngredientModel> list;

  const ResultList({
    Key key,
    @required this.img,
    @required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: img.ingredients.length,
      itemBuilder: (context, index) {
        img.setStatus(
            index,
            DatabaseService()
                .matchDB(img, img.getIngredient(index).name, list));

        return Card(
          elevation: 0.0,
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  iconSize: 16.0,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialog(
                            title: 'Edit Ingredient',
                            child: EditIngredient(
                                ingredient: img.getIngredient(index).name,
                                index: index),
                          );
                        });
                  },
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    img.getIngredient(index).name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        img.getIngredient(index).status,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: statusColor(img.getIngredient(index).status),
                          fontSize: 20.0,
                        ),
                      ),
                      img.isCommentEmpty(index)
                          ? Container()
                          : IconButton(
                              icon: Icon(Icons.info_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return InfoAlert(
                                        alert:
                                            img.getIngredient(index).comment);
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EditIngredient extends StatefulWidget {
  final String ingredient;
  final int index;

  EditIngredient({@required this.ingredient, @required this.index});

  @override
  _EditIngredientState createState() => _EditIngredientState();
}

class _EditIngredientState extends State<EditIngredient> {
  String _newIngredient;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final img = Provider.of<ImageModel>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: this.widget.ingredient,
            autofocus: true,
            validator: (val) => val.isEmpty ? '' : null,
            onChanged: (value) => setState(() => _newIngredient = value),
          ),
          SizedBox(height: 30.0),
          FlatButton(
            color: Theme.of(context).primaryColor,
            child: Text('OK'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                img.updateIngredient(this.widget.index,
                    _newIngredient ?? this.widget.ingredient);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
