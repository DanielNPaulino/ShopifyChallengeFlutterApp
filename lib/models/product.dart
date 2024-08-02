class Product {
  final String title;
  final int productAvailability;
  final String tags;
  final String? productImage;

  Product(
      {required this.title,
      required this.productAvailability,
      required this.tags,
      required this.productImage});

  static Product fromJson(Map<String, dynamic> json) {
    String? productImage;
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      productImage = json['images'][0]['src'];
    }

    return Product(
      title: json['title'],
      productAvailability: json['variants'].fold<int>(0,
          (sum, variant) => sum + (variant['inventory_quantity'] ?? 0) as int),
      tags: json['tags'],
      productImage: productImage,
    );
  }
}
