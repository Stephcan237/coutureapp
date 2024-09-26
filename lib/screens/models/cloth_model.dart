class ClothModel {
  final String id;
  final String name;
  final String image;
  final String description;

  ClothModel({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
  });

  factory ClothModel.fromMap(Map<String, dynamic> map) {
    return ClothModel(
      id: map['id'],
      name: map['nom'],
      image: map['image'],
      description: map['description'],
    );
  }
}
