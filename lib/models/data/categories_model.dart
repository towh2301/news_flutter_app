class Category {
  final String id;
  final String name;
  final String description;

  Category(this.id, this.name, this.description);

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'];
}
