class ImageData {
  String temp = '';
  String image;
  List<String> ingredients = [];
  List<String> status = [];

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

    for (int i = 0; i < ingredients.length; i++) {
      status.add('unknown');
    }
  }

  void printIngredients() {
    for(String ingredient in ingredients) {
      print(ingredient);
    }
  }
}