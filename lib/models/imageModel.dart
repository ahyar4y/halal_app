import 'package:flutter/material.dart';
import 'package:halal_app/models/ingredientModel.dart';

class ImageModel extends ChangeNotifier {
  String _image;
  List<IngredientModel> _ingredients;

  void setImage(String img) {
    _image = img;
    _ingredients = <IngredientModel>[];
  }

  String get image => _image;

  List<IngredientModel> get ingredients => _ingredients;

  IngredientModel getIngredient(int index) => _ingredients[index];

  bool isCommentEmpty(int index) =>
      (_ingredients[index].comment == '') ? true : false;

  void setIngredients(List<IngredientModel> list) => _ingredients = list;

  void setStatus(int index, List<String> val) {
    _ingredients[index].status = val[0];
    _ingredients[index].comment = val[1];
  }

  void updateIngredient(int index, String ingredient) {
    _ingredients[index].name = ingredient;

    notifyListeners();
  }

  void printIngredients() {
    print(ingredients.length);
    for (int i = 0; i < ingredients.length; i++) {
      print(_ingredients[i].name);
      print(_ingredients[i].status);
      print(_ingredients[i].comment);
    }
  }
}
