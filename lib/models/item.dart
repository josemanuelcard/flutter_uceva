class Item {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  Item({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  String toString() => 'Item(id: $id, title: $title)';
}
