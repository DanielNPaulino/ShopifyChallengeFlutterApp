import 'package:shopify_challenge_flutter_app/models/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopify_challenge_flutter_app/models/tag.dart';

class ShopifyApi {
  static const String apiUrl =
      "https://shopicruit.myshopify.com/admin/products.json";
  String accessToken = 'c32313df0d0ef512ca64d5b336a0d7c6';

  // Get Tags
  Future<List<Tag>> fetchTags({int limit = 20}) async {
    final response = await http.get(
      Uri.parse('$apiUrl?limit=$limit'),
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Access-Token': accessToken,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = jsonDecode(response.body)['products'];
      Set<String> tags = {};

      for (var product in productsJson) {
        List<String> productTags = product['tags'].split(', ');
        tags.addAll(productTags);
      }

      return tags.map((tag) => Tag.fromJson(tag)).toList();
    } else {
      throw Exception('fetchTags failled');
    }
  }

  // Get Products
  Future<List<Product>> fetchProductsByTag({int limit = 20}) async {
    final response = await http.get(
      Uri.parse('$apiUrl?limit=$limit'),
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Access-Token': accessToken,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> productsJson = jsonDecode(response.body)['products'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('fetchProducts failled');
    }
  }
}
