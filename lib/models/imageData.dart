import 'dart:io';
// import 'dart:math';
// import 'package:image/image.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class ImageData {
  String temp = '';
  String image;
  List<String> ingredients = [];

  // Image preProcess() {
  //   Image img = decodeImage(File(this.image).readAsBytesSync());
  //   double factor = max(1, 1024.0/img.width);
  //   int newHeight = factor.toInt() * img.height;
  //   img = copyResize(img, height: newHeight);
  //   img = contrast(img, 150);
  //   img = grayscale(img);

  //   return img;
  // }

  Future readImage() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(File(this.image));
    final TextRecognizer ocr = FirebaseVision.instance.textRecognizer();
    final VisionText imageText = await ocr.processImage(visionImage);
    RegExp regex = RegExp(r".*?(\(([^)]+)\))?,");
    String str = '';

    for (TextBlock block in imageText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          str+=element.text;
        }
      }
    }
    print(str);

    ocr.close();

    // printIngredients();
  }

  void setIngredients() {
    ingredients.add('Milk Chocolate (Sugar, Cocoa Butter, Chocolate, Lactose, Skim Milk, Milkfat, Soy Lecithin, Artificial Flavor)');
    ingredients.add('Peanuts');
    ingredients.add('Corn Syrup');
    ingredients.add('Sugar');
    ingredients.add('Skim Milk');
    ingredients.add('Butter');
    ingredients.add('Milkfat');
    ingredients.add('Partially Hidrogenated Soybean Oil');
    ingredients.add('Lactose');
    ingredients.add('Salt');
    ingredients.add('Egg Whites');
    ingredients.add('Artificial Flavor');
  }

  void printIngredients() {
    for(String ingredient in ingredients) {
      print(ingredient);
    }
  }
}