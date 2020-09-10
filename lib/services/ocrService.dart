import 'dart:io';
import 'dart:math';
import 'package:halal_app/models/ingredientModel.dart';
import 'package:image/image.dart';
import 'package:halal_app/models/imageModel.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class OCRService {
  Image preProcess(String img) {
    Image _image = decodeImage(File(img).readAsBytesSync());
    double _factor = max(1, 1024.0 / _image.width);
    int _newHeight = _factor.toInt() * _image.height;
    _image = copyResize(_image, height: _newHeight);
    _image = contrast(_image, 150);
    _image = grayscale(_image);

    return _image;
  }

  Future readImage(ImageModel img) async {
    final FirebaseVisionImage _visionImage =
        FirebaseVisionImage.fromFile(File(img.image));
    final TextRecognizer _textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText _visionText =
        await _textRecognizer.processImage(_visionImage);
    List<IngredientModel> _list = [];
    String _str = '';

    for (TextBlock block in _visionText.blocks) {
      for (TextLine line in block.lines) {
        _str += line.text;
      }
    }
    _textRecognizer.close();

    RegExp _regex =
        RegExp(r"ingredients?:?\s*([^\r\n]*)", caseSensitive: false);
    Iterable<RegExpMatch> _matches = _regex.allMatches(_str);

    // if (_matches.isEmpty) return [];

    _matches.forEach((match) {
      _str = match.group(1);
    });

    _regex = RegExp(r"\.+\s*[A-Z]+.+", caseSensitive: false);
    _matches = _regex.allMatches(_str);
    _matches.forEach((match) {
      _str = _str.substring(0, match.start - 1);
    });

    _regex = RegExp(r"\b[\w\d\s!@#$%^&*_+\-=`~{}\[\]:;'<>\\.]+(\([^)]+\))?",
        caseSensitive: false);
    _matches = _regex.allMatches(_str);

    if (_matches.isEmpty) return [];

    _matches.forEach((match) {
      _list.add(IngredientModel(
          name: _str.substring(match.start, match.end),
          status: null,
          comment: null));
    });

    img.setIngredients(_list);

    return _list;
  }
}
