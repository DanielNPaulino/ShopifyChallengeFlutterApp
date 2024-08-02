import 'package:flutter/material.dart';
import '../controllers/shopify_api.dart';
import '../models/product.dart';

class ProductsListPage extends StatefulWidget {
  final String tag;

  ProductsListPage({required this.tag});

  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  List<Product>? _products;
  List<Product>? _selectedTagProducts;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProductsByTag();
  }

  Future<void> _fetchProductsByTag() async {
    final shopifyApi = ShopifyApi();
    try {
      final products = await shopifyApi.fetchProductsByTag();
      setState(() {
        _products = products;
        _selectedTagProducts = _filteredProducts(widget.tag);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  // Returns filtered list by selected tag
  List<Product> _filteredProducts(String tag) {
    return _products!.where((product) => product.tags.contains(tag)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Products'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text('Error: $_error'),
                )
              : ListView.builder(
                  itemCount: _selectedTagProducts?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 107, 189, 233),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: _selectedTagProducts![index].productImage !=
                                  null
                              ? Image.network(
                                  _selectedTagProducts![index].productImage!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : null,
                          title: Text(
                            _selectedTagProducts![index].title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'Total availability: ${_selectedTagProducts![index].productAvailability}'),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
