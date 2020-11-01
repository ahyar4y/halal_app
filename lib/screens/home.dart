import 'dart:io';
import 'package:flutter/material.dart';
import 'package:halal_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:halal_app/shared/infoAlert.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:halal_app/shared/statusColor.dart';
import 'package:halal_app/shared/circleButton.dart';
import 'package:halal_app/models/ingredientModel.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        resizeToAvoidBottomInset: false,
        body: MainSection(
          size: size,
        ));
  }
}

class MainSection extends StatefulWidget {
  const MainSection({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _MainSectionState createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> {
  File _imgFile;
  String _imgPath;

  Future<bool> _checkPermission(Permission permission) async {
    //print(await permission.status);
    if (await permission.isPermanentlyDenied)
      await openAppSettings();
    else if (!await permission.isGranted) {
      if (await permission.request().isGranted) return true;
    } else if (await permission.isGranted) return true;
    return false;
  }

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
    final ImageModel img = Provider.of<ImageModel>(context);
    final List<IngredientModel> dbList =
        Provider.of<List<IngredientModel>>(context) ?? [];

    return Container(
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: widget.size.width * 0.2,
            bottom: widget.size.height * 0.7,
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
            bottom: widget.size.height * 0.5,
            child: Row(
              children: <Widget>[
                CircleButton(
                  text: 'Camera',
                  textColor: Colors.white,
                  icon: Icons.add_a_photo,
                  iconColor: Colors.white,
                  fillColor: Colors.pink,
                  callback: () async {
                    if (await _checkPermission(Permission.camera)) {
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
                    if (await _checkPermission(Permission.storage)) {
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
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: widget.size.width * 0.08,
            bottom: widget.size.height * 0.4,
            child: FlatButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchIngredient(list: dbList));
              },
              child: Text(
                'Tap here to search ingredient manually',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 16.0,
                    //decoration: TextDecoration.underline,
                    color: Colors.white,
                    letterSpacing: 0.5),
              ),
            ),
          ),
          Positioned(
            left: widget.size.width * 0.47,
            bottom: widget.size.height * 0.03,
            child: GestureDetector(
              onLongPress: () {
                showModalBottomSheet<void>(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return SecretForm();
                    });
              },
              child: Icon(
                Icons.vpn_key,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecretForm extends StatefulWidget {
  const SecretForm({
    Key key,
  }) : super(key: key);

  @override
  _SecretFormState createState() => _SecretFormState();
}

class _SecretFormState extends State<SecretForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 100),
      child: Container(
        height: 150,
        padding: EdgeInsets.symmetric(horizontal: 70.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                obscureText: true,
                validator: (val) => val.isEmpty ? '???' : null,
                onChanged: (val) => setState(() => pass = val),
              ),
              SizedBox(height: 10.0),
              FlatButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic result = await _auth.adminLogin(pass);
                    if (result == null) setState(() => error = 'ERROR');
                    else {
                      print(result);
                      Navigator.pop(context);
                    }
                  }
                },
                color: Theme.of(context).primaryColor,
                child: Text('OK'),
              ),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchIngredient extends SearchDelegate {
  final List<IngredientModel> list;

  SearchIngredient({@required this.list});

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
      final Iterable<IngredientModel> results = list.where(
          (item) => item.name.toLowerCase().contains(query.toLowerCase()));
      return results.isEmpty
          ? Center(
              child: Text(
                'not found',
                style: TextStyle(
                  fontSize: 24.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            )
          : SearchList(results: results);
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    try {
      final Iterable<IngredientModel> results = list.where(
          (item) => item.name.toLowerCase().contains(query.toLowerCase()));
      return results.isEmpty
          ? Center(
              child: Text(
                'not found',
                style: TextStyle(
                  fontSize: 24.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            )
          : SearchList(results: results);
    } catch (e) {
      print(e);
    }
    throw UnimplementedError();
  }
}

class SearchList extends StatelessWidget {
  const SearchList({
    Key key,
    @required this.results,
  }) : super(key: key);

  final Iterable<IngredientModel> results;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: results
          .map((result) => ListTile(
                isThreeLine: true,
                title: Text(result.name),
                subtitle: Text(
                  result.status,
                  style: TextStyle(
                    color: statusColor(result.status),
                  ),
                ),
                trailing: result.comment == ''
                    ? Container(
                        width: 0.0,
                        height: 0.0,
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          size: 30.0,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return InfoAlert(alert: result.comment);
                            },
                          );
                        },
                      ),
              ))
          .toList(),
    );
  }
}
