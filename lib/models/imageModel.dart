import 'package:flutter/material.dart';

class ImageModel extends ChangeNotifier {
  String _image;
  List<String> _ingredients;
  List<String> _status;

  void setImage(String img) {
    _image = img;
    _ingredients = [];
    _status = [];
  }

  String get image => _image;

  int get ingredientsLength => _ingredients.length;

  String getIngredient(int index) => _ingredients[index];

  String getStatus(int index) => _status[index];

  void setIngredients(List<String> list) {
    _ingredients = list;
  }

  void editIngredient(int index, String ingredient) {
    _ingredients[index] = ingredient;

    notifyListeners();
  }

  void setStatus(String stat) {
    _status.add(stat);
  }

  void editStatus(int index, String stat) {
    _status[index] = stat;

    notifyListeners();
  }

  void printIngredients() {
    print(_status.length);
    for (int i = 0; i < _status.length; i++) {
      print(_status[i]);
    }
  }
}
