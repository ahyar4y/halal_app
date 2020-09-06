import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:halal_app/models/ingredientModel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

class MainTopSection extends StatelessWidget {
  const MainTopSection({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  Future _getImage(String method) async {
    final picker = ImagePicker();
    final image = await picker.getImage(
        source: method == 'camera' ? ImageSource.camera : ImageSource.gallery);

    return image.path;
  }

  @override
  Widget build(BuildContext context) {
    final img = Provider.of<ImageModel>(context);
    final dbList = Provider.of<List<IngredientModel>>(context) ?? [];

    return Container(
      height: size.height * 0.40,
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.4,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45.0),
                  bottomRight: Radius.circular(45.0)),
            ),
          ),
          Positioned(
            left: size.width * 0.21,
            bottom: size.height * 0.29,
            child: Text(
              'HalCheck',
              style: TextStyle(
                  fontFamily: 'Dosis',
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.orange),
            ),
          ),
          Positioned(
            left: size.width * 0.28,
            bottom: size.height * 0.1,
            child: Row(
              children: <Widget>[
                CircleButton(
                  text: 'Camera',
                  icon: Icons.add_a_photo,
                  iconColor: Colors.white,
                  fillColor: Colors.pink,
                  callback: () async {
                    img.setImage(await _getImage('camera'));

                    Navigator.pushNamed(context, '/detail');
                  },
                ),
                SizedBox(width: 20),
                CircleButton(
                  text: 'Gallery',
                  icon: Icons.add_photo_alternate,
                  iconColor: Colors.white,
                  fillColor: Colors.pink,
                  callback: () async {
                    img.setImage(await _getImage('gallery'));

                    Navigator.pushNamed(context, '/detail');
                  },
                ),
              ],
            ),
          ),
          Positioned(
            left: size.width * 0.19,
            bottom: size.height * 0.01,
            child: FlatButton(
              onPressed: () {
                showSearch(
                    context: context, delegate: SearchIngredient(dbList));
              },
              child: Text(
                'Or search ingredient manually',
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 16.0,
                    decoration: TextDecoration.underline,
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

class CircleButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final Color fillColor;
  final dynamic callback;

  const CircleButton(
      {Key key,
      @required this.text,
      @required this.icon,
      @required this.iconColor,
      @required this.fillColor,
      @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          child: RawMaterialButton(
            onPressed: this.callback,
            shape: CircleBorder(),
            elevation: 0,
            fillColor: this.fillColor,
            child: Icon(
              this.icon,
              color: this.iconColor,
              size: 50,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          this.text,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
