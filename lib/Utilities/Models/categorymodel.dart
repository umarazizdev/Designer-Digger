class CategoryModel {
  final String image, name, price;
  CategoryModel(this.image, this.name, this.price);
}

List categoryModel = [
  CategoryModel("assets/beefburgeer.png", "Beef Burger", "\$20"),
  CategoryModel("assets/chesepizza.png", "Cheese Pizza", "\$15"),
  CategoryModel("assets/containericecream.png", "Ice Cream", "\$14"),
];
