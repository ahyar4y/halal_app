class ImageData {
  String _image;
  List<String> ingredients = [
    'Milk Chocolate (Sugar, Cocoa Butter, Chocolate, Lactose, Skim Milk, Milkfat, Soy Lecithin, Artificial Flavor)',
    'Peanuts',
    'Corn Syrup',
    'Sugar',
    'Skim Milk',
    'Butter',
    'Milkfat',
    'Partially Hidrogenated Soybean Oil',
    'Lactose',
    'Salt',
    'Egg Whites',
    'Artificial Flavor'
  ];
  List<String> status = [
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
    'unknown',
  ];

  void setImage(String img) => _image = img;

  String get image => _image;

  void printIngredients() {
    for(String ingredient in ingredients) {
      print(ingredient);
    }
  }
}