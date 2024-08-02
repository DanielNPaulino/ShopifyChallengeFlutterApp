import 'package:flutter/material.dart';
import 'package:shopify_challenge_flutter_app/controllers/shopify_api.dart';
import 'package:shopify_challenge_flutter_app/pages/products_list_page.dart';

import '../models/tag.dart';

class TagsListPage extends StatefulWidget {
  @override
  _TagsListPageState createState() => _TagsListPageState();
}

class _TagsListPageState extends State<TagsListPage> {
  List<Tag>? _tags;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchTags();
  }

  Future<void> _fetchTags() async {
    final shopifyApi = ShopifyApi();
    try {
      final tags = await shopifyApi.fetchTags();
      setState(() {
        _tags = tags;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tags'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Text('Error: $_error'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'Available Tags',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _tags?.length ?? 0,
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
                                title: Text(_tags![index].name),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductsListPage(
                                        tag: _tags![index].name,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
