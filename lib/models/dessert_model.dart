class Dessert {
  final int id;
  final String image;
  final String title;
  final String description;
  final double price;
  final String category;

  Dessert({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
    };
  }

  factory Dessert.fromJson(Map<String, dynamic> json) {
    return Dessert(
      id: json['id'],
      image: json['image'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      category: json['category'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dessert &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}