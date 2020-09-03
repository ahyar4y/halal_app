import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ImageData {
  String temp = '';
  String image;
  List<String> ingredients = [];

  Image preProcess() {
    Image img = decodeImage(File(this.image).readAsBytesSync());
    double factor = max(1, 1024.0/img.width);
    int newHeight = factor.toInt() * img.height;
    img = copyResize(img, height: newHeight);
    img = contrast(img, 150);
    img = grayscale(img);

    return img;
  }

  Future readImage() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(File(this.image));
    final TextRecognizer ocr = FirebaseVision.instance.textRecognizer();
    final VisionText imageText = await ocr.processImage(visionImage);
    RegExp regex = RegExp(r"ingredients?:?\s*([^\r\n]*)", caseSensitive: false);
    String str = '';

    for (TextBlock block in imageText.blocks) {
      for (TextLine line in block.lines) {
        str += line.text;
      }
    }
    ocr.close();

    Iterable<RegExpMatch> matches = regex.allMatches(str);
    matches.forEach((match) { 
      str = match.group(1);
    });
    
    regex = RegExp(r"\b[^,]+?[\s\w\d]+(\([^)]+\))?", caseSensitive: false);
    matches = regex.allMatches(str);
    matches.forEach((match) {
      ingredients.add(str.substring(match.start, match.end));
    });

    printIngredients();
  }

  void printIngredients() {
    for(String ingredient in ingredients) {
      print(ingredient);
    }
  }
}