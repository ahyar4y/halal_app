import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:halal_app/shared/circleButton.dart';
import 'package:halal_app/models/ingredientModel.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          MainTopSection(
            size: size,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MainTopSection extends StatefulWidget {
  const MainTopSection({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _MainTopSectionState createState() => _MainTopSectionState();
}

class _MainTopSectionState extends State<MainTopSection> {
  File _imgFile;
  String _imgPath;

  Future<void> _getImage(ImageSource source) async {
    final _picker = ImagePicker();
    PickedFile _image = await _picker.getImage(source: source);

    if (_image != null) setState(() => _imgFile = File(_image.path));
  }

  Future<void> _cropImage(File img) async {
    final _croppedFile = await ImageCropper.cropImage(sourcePath: img.path);

    if (_croppedFile != null) setState(() => _imgPath = _croppedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    final img = Provider.of<ImageModel>(context);
    final dbList = Provider.of<List<IngredientModel>>(context) ?? [];

    return Container(
      height: widget.size.height * 0.40,
      child: Stack(
        children: <Widget>[
          Container(
            height: widget.size.height * 0.4,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45.0),
                  bottomRight: Radius.circular(45.0)),
            ),
          ),
          Positioned(
            left: widget.size.width * 0.2,
            bottom: widget.size.height * 0.3,
            child: Stack(
              children: <Widget>[
                Text(
                  'HalCheck',
                  style: TextStyle(
                      fontFamily: 'Dosis',
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.white),
                ),
                Text(
                  'HalCheck',
                  style: TextStyle(
                      fontFamily: 'Dosis',
                      fontSize: 60.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.orange),
                )
              ],
            ),
          ),
          Positioned(
            left: widget.size.width * 0.26,
            bottom: widget.size.height * 0.1,
            child: Row(
              children: <Widget>[
                CircleButton(
                  text: 'Camera',
                  textColor: Colors.white,
                  icon: Icons.add_a_photo,
                  iconColor: Colors.white,
                  fillColor: Colors.pink,
                  callback: () async {
                    await _getImage(ImageSource.camera);

                    if (_imgFile != null) {
                      await _cropImage(_imgFile);

                      if (_imgPath != null) {
                        img.setImage(_imgPath);

                        setState(() => _imgPath = null);

                        Navigator.pushNamed(context, '/detail');
                      }
                      setState(() => _imgFile = null);
                    }
                  },
                ),
                SizedBox(width: 30),
                CircleButton(
                  text: 'Gallery',
                  textColor: Colors.white,
                  icon: Icons.add_photo_alternate,
                  iconColor: Colors.white,
                  fillColor: Colors.pink,
                  callback: () async {
                    await _getImage(ImageSource.gallery);

                    if (_imgFile != null) {
                      await _cropImage(_imgFile);

                      if (_imgPath != null) {
                        img.setImage(_imgPath);

                        setState(() => _imgPath = null);

                        Navigator.pushNamed(context, '/detail');
                      }
                      setState(() => _imgFile = null);
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: widget.size.width * 0.12,
            bottom: widget.size.height * 0.01,
            child: FlatButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchIngredient(dbList));
              },
              child: Text(
                'Tap here to search ingredient manually',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 16.0,
                    //decoration: TextDecoration.underline,
                    color: Colors.white,
                    letterSpacing: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchIngredient extends SearchDelegate {
  final List<IngredientModel> dbList;

  SearchIngredient(this.dbList);

  @override
  List<Widget> buildActions(BuildContext context) {
    try {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
      ];
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    try {
      return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        },
      );
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    try {
      final results =
          dbList.where((item) => item.name.toLowerCase().contains(query));
      return ListView(
        children: results
            .map((result) => ListTile(
                  isThreeLine: true,
                  title: Text(result.name),
                  subtitle: Text(result.status),
                ))
            .toList(),
      );
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    try {
      final results =
          dbList.where((item) => item.name.toLowerCase().contains(query));
      return ListView(
        children: results
            .map((result) => ListTile(
                  title: Text(result.name),
                  subtitle: Text(result.status),
                ))
            .toList(),
      );
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }
}
