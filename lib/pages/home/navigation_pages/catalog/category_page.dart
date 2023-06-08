import 'package:etrick/constants.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/pages/home/home_app_bar.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/catalog_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    super.key,
    required this.category,
  });

  final String category;

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late final String _category;

  @override
  void initState() {
    _category = widget.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var items = context.watch<CatalogModel>().getItemsByCategory(_category);
    return Scaffold(
      appBar: HomeAppBar(
        title: Constants.categories[_category] ?? Constants.appName,
      ),
      body: SingleChildScrollView(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
          ),
          shrinkWrap: true,
          itemCount: items.length,
          itemBuilder: (_, index) => CatalogListItem(
            id: items[index].id,
          ),
        ),
      ),
    );
  }
}
