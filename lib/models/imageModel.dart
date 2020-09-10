import 'package:flutter/material.dart';
import 'package:halal_app/models/ingredientModel.dart';

class ImageModel extends ChangeNotifier {
  String _image;
  List<IngredientModel> _ingredients;

  void setImage(String img) {
    _image = img;
    _ingredients = [];
  }

  String get image => _image;

  int get ingredientsLength => _ingredients.length;

  String getIngredient(int index) => _ingredients[index].name;

  String getStatus(int index) => _ingredients[index].status;

  String getComment(int index) => _ingredients[index].comment;

  bool isCommentEmpty(int index) {
    if (_ingredients[index].comment == '')
      return true;
    else
      return false;
  }

  void setIngredients(List<IngredientModel> list) {
    _ingredients = list;
  }

  void setStatus(int index, IngredientModel val) {
    _ingredients[index].status = val.status;
    _ingredients[index].comment = val.comment;
  }

  void editIngredient(int index, String ingredient) {
    _ingredients[index].name = ingredient;

    // notifyListeners();
  }

  void editStatus(int index, IngredientModel val) {
    _ingredients[index].status = val.status;
    _ingredients[index].comment = val.comment;

    notifyListeners();
  }

  void printIngredients() {
    print(ingredientsLength);
    for (int i = 0; i < ingredientsLength; i++) {
      print(_ingredients[i].name);
      print(_ingredients[i].status);
      print(_ingredients[i].comment);
    }
  }
}
