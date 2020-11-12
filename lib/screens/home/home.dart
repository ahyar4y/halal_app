import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:halal_app/screens/home/search.dart';
import 'package:halal_app/shared/circleButton.dart';
import 'package:halal_app/shared/customDialog.dart';
import 'package:halal_app/models/ingredientModel.dart';
import 'package:halal_app/screens/home/secretForm.dart';
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
    final admin = Provider.of<User>(context);

    final AuthService _auth = AuthService();

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
            left: admin == null
                ? widget.size.width * 0.08
                : widget.size.width * 0.26,
            bottom: widget.size.height * 0.4,
            child: FlatButton(
                onPressed: () {
                  showSearch(
                      context: context,
                      delegate: SearchIngredient(list: dbList));
                },
                child: admin == null
                    ? Text(
                        'Tap here to search ingredient manually',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 16.0,
                            //decoration: TextDecoration.underline,
                            color: Colors.white,
                            letterSpacing: 0.5),
                      )
                    : Text(
                        'MANAGE DATABASE',
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 16.0,
                            //decoration: TextDecoration.underline,
                            color: Colors.white,
                            letterSpacing: 0.5),
                      )),
          ),
          Positioned(
            left: widget.size.width * 0.47,
            bottom: widget.size.height * 0.03,
            child: GestureDetector(
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(title: 'Sshhh!', child: SecretForm());
                  },
                );
              },
              child: Icon(
                Icons.vpn_key,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          admin == null
              ? Container()
              : Positioned(
                  left: widget.size.width * 0.38,
                  bottom: widget.size.height * 0.05,
                  child: FlatButton(
                    onPressed: () async {
                      _auth.signOut();
                    },
                    color: Colors.white,
                    child: Text(
                      'Sign out',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 16.0,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 0.5),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
