import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/models/imageData.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
      ),
      body: Column(
        children: <Widget>[
          MainTopSection(size: size),
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
      source: method == 'camera' ? ImageSource.camera : ImageSource.gallery
    );
    
    return image.path;
  }

  @override
  Widget build(BuildContext context) {
    var imageData = Provider.of<ImageData>(context);

    return Container(
      height: size.height * 0.40,
      child: Stack(
        children: <Widget>[
          Container(
            height: size.height * 0.40 - 24,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(45),
                  bottomRight: Radius.circular(45)),
            ),
          ),
          Positioned(
            left: size.width * 0.27,
            bottom: size.height * 0.08,
            child: Text(
              'Or search food item manually:',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 50,
                    color:
                        Theme.of(context).primaryColor.withOpacity(0.25),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      onFieldSubmitted: (String value) {
                        print('$value');
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.5),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.search,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: size.width * 0.27,
            bottom: size.height * 0.30,
            child: Text(
              'HalCheck',
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Positioned(
            left: size.width * 0.28,
            bottom: size.height * 0.3 - 115,
            child: Row(
              children: <Widget>[
                CircleButton(
                  text: 'Camera',
                  icon: Icons.add_a_photo,
                  iconColor: Colors.white,
                  fillColor: Colors.red[400],
                  callback: () async {
                    imageData.image = await _getImage('camera');

                    Navigator.pushNamed(context, '/detail');
                  },
                ),
                SizedBox(width: 20),
                CircleButton(
                  text: 'Gallery',
                  icon: Icons.add_photo_alternate,
                  iconColor: Colors.white,
                  fillColor: Colors.red[400],
                  callback: () async {
                    imageData.image = await _getImage('gallery');
                    print(imageData.image);
                    Navigator.pushNamed(context, '/detail');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
