import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:halal_app/models/imageData.dart';

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var imageData = Provider.of<ImageData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          //Image.file(File(imageData.image)),
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          Row(
            children: [
              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),
              ),
              Container(
                height: 300,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}