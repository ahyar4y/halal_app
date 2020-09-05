class ImageModel {
  String _image;
  List<String> ingredients;
  List<String> status;

  void setImage(String img) {
    _image = img;
    ingredients = [];
    status = [];
  }

  String get image => _image;

  void printIngredients() {
    print(ingredients.length);
    for(String ingredient in ingredients) {
      print(ingredient);
    }
  }
}