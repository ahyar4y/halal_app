import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:halal_app/models/imageData.dart';
// import 'package:halal_app/googleapis.dart';

class Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var imageData = Provider.of<ImageData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Image.file(File(imageData.image)),
              FlatButton(
                // onPressed: () {
                //   VisionAPI vision = VisionAPI();

                //   vision.ocr(imageData.image);
                // },
                onPressed: imageData.setIngredients,
                child: Text('read image'),
              ),
            ],
          ),
        ),
    );
  }
}