import 'dart:io';
import 'dart:math';
import 'package:image/image.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class OCRService {
  Image preProcess(String img) {
    Image image = decodeImage(File(img).readAsBytesSync());
    double factor = max(1, 1024.0/image.width);
    int newHeight = factor.toInt() * image.height;
    image = copyResize(image, height: newHeight);
    image = contrast(image, 150);
    image = grayscale(image);

    return image;
  }

  Future readImage(ImageModel img) async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(File(img.image));
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String str = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        str += line.text;
      }
    }
    textRecognizer.close();

    RegExp regex = RegExp(r"ingredients?:?\s*([^\r\n]*)", caseSensitive: false);
    Iterable<RegExpMatch> matches = regex.allMatches(str);

    matches.forEach((match) { 
      str = match.group(1);
    });

    regex = RegExp(r"\b[^,]+?[\w\d\s]+(\([^)]+\))?", caseSensitive: false);
    matches = regex.allMatches(str);

    matches.forEach((match) {
      img.ingredients.add(str.substring(match.start, match.end));
    });

    img.printIngredients();
    return img.ingredients;
  }
}