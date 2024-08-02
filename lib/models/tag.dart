class Tag {
  final String name;

  Tag({required this.name});

  static Tag fromJson(String jsonTag) {
    return Tag(name: jsonTag);
  }
}
