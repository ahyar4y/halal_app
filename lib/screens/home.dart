import 'dart:io';
import 'package:flutter/material.dart';
import 'package:halal_app/screens/loading.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/services/db.dart';
import 'package:halal_app/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:halal_app/shared/infoAlert.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
                        'ACCESS DATABASE',
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

class SearchIngredient extends SearchDelegate {
  final List<IngredientModel> list;

  SearchIngredient({@required this.list});

  @override
  List<Widget> buildActions(BuildContext context) {
    final admin = Provider.of<User>(context);

    try {
      return [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
        admin == null
            ? Container()
            : IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog(title: 'Add DB', child: AddDBForm());
                    },
                  );
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
      return StreamBuilder(
        stream: DatabaseService().ingredients,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Loading();
          else {
            List<IngredientModel> list = snapshot.data;
            Iterable<IngredientModel> results = list.where((item) =>
                item.name.toLowerCase().contains(query.toLowerCase()));
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
          }
        },
      );
    } catch (e) {
      print(e.toString());
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
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(results.elementAt(index).id),
          background: Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            alignment: AlignmentDirectional.centerStart,
            child: Icon(Icons.edit, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            alignment: AlignmentDirectional.centerEnd,
            child: Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {},
          confirmDismiss: (direction) async {
            String action;
            if (direction == DismissDirection.startToEnd)
              action = 'update';
            else
              action = 'delete';

            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return action == 'update'
                    ? CustomDialog(
                        title: 'Update DB',
                        child: UpdateDBForm(id: results.elementAt(index).id))
                    : AlertDialog(
                        title: Text('Confirmation'),
                        content:
                            Text('Are you sure you want to $action this item?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              DatabaseService(
                                      ingredientId: results.elementAt(index).id)
                                  .deleteDB();

                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      );
              },
            );
          },
          child: ListTile(
            title: Text(results.elementAt(index).name),
            subtitle: Text(
              results.elementAt(index).status,
              style: TextStyle(
                color: statusColor(results.elementAt(index).status),
              ),
            ),
            trailing: results.elementAt(index).comment == ''
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
                        builder: (BuildContext context) {
                          return InfoAlert(
                              alert: results.elementAt(index).comment);
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}

class CustomDialog extends StatefulWidget {
  final String title;
  final Widget child;
  const CustomDialog({Key key, @required this.title, @required this.child})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Builder(builder: (context) {
        return Container(
          height: 300.0,
          child: widget.child,
        );
      }),
    );
  }
}

class SecretForm extends StatefulWidget {
  const SecretForm({Key key}) : super(key: key);

  @override
  _SecretFormState createState() => _SecretFormState();
}

class _SecretFormState extends State<SecretForm> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();

  String _pass = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autofocus: true,
            obscureText: true,
            validator: (val) => val.isEmpty ? '' : null,
            onChanged: (val) => setState(() => _pass = val),
          ),
          SizedBox(height: 10.0),
          FlatButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                dynamic result = await _auth.adminLogin(_pass);
                if (result == null)
                  setState(() => _error = 'ERROR');
                else {
                  //print(result);
                  Navigator.pop(context);
                }
              }
            },
            color: Theme.of(context).primaryColor,
            child: Text('OK'),
          ),
          Text(
            _error,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class AddDBForm extends StatefulWidget {
  const AddDBForm({
    Key key,
  }) : super(key: key);

  @override
  _AddDBFormState createState() => _AddDBFormState();
}

class _AddDBFormState extends State<AddDBForm> {
  final _dbService = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();

  String _name = '';
  String _status = '';
  String _comment = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _controller1,
            validator: (val) => val.isEmpty ? '' : null,
            onChanged: (val) => setState(() => _name = val),
            decoration: InputDecoration(
              hintText: 'Name',
            ),
          ),
          TextFormField(
            controller: _controller2,
            validator: (val) {
              switch (val.toLowerCase()) {
                case 'halal':
                case 'haram':
                case 'doubtful':
                  return null;
                  break;
                default:
                  return '';
                  break;
              }
            },
            onChanged: (val) => setState(() => _status = val),
            decoration: InputDecoration(
              hintText: 'Status',
            ),
          ),
          TextFormField(
            controller: _controller3,
            validator: (val) => null,
            onChanged: (val) => setState(() => _comment = val),
            decoration: InputDecoration(
              hintText: 'Comment',
            ),
          ),
          SizedBox(height: 30.0),
          FlatButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await _dbService
                    .addDB(_name, _status, _comment)
                    .catchError((onError) => print(onError));

                setState(() {
                  _controller1.clear();
                  _controller2.clear();
                  if (_controller3 != null) _controller3.clear();
                });
              }
            },
            color: Theme.of(context).primaryColor,
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}

class UpdateDBForm extends StatefulWidget {
  final String id;
  const UpdateDBForm({Key key, @required this.id}) : super(key: key);

  @override
  _UpdateDBFormState createState() => _UpdateDBFormState();
}

class _UpdateDBFormState extends State<UpdateDBForm> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _status;
  String _comment;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: DatabaseService(ingredientId: widget.id).ingredient,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            IngredientModel ingredient = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    initialValue: ingredient.name ?? _name,
                    validator: (val) => val.isEmpty ? '' : null,
                    onChanged: (val) => setState(() => _name = val),
                  ),
                  TextFormField(
                    initialValue: ingredient.status ?? _status,
                    validator: (val) {
                      switch (val.toLowerCase()) {
                        case 'halal':
                        case 'haram':
                        case 'doubtful':
                          return null;
                          break;
                        default:
                          return '';
                          break;
                      }
                    },
                    onChanged: (val) => setState(() => _status = val),
                  ),
                  TextFormField(
                    initialValue: ingredient.comment ?? _comment,
                    validator: (val) => null,
                    onChanged: (val) => setState(() => _comment = val),
                  ),
                  SizedBox(height: 30.0),
                  FlatButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(ingredientId: ingredient.id)
                            .updateDB(
                                _name ?? ingredient.name,
                                _status ?? ingredient.status,
                                _comment ?? ingredient.comment)
                            .catchError((onError) => print(onError));
                        //Navigator.pop(context);
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else
            return Loading();
        });
  }
}
