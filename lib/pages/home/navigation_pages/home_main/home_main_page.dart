import 'package:etrick/constants.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/catalog_list_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({Key? key}) : super(key: key);

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  @override
  Widget build(BuildContext context) {
    var catalogModel = context.watch<CatalogModel>();
    Map<String, String> categories = Constants.categories;
    List<String> categoriesKeys = categories.keys.toList();
    List<String> categoriesValues = categories.values.toList();
    return SafeArea(
      child: ListView(
        children: [
          const SizedBox(height: 16),
          Center(
            child:
                Text("Новинки", style: Theme.of(context).textTheme.titleLarge),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (_, index) {
              String category = categoriesValues[index];
              List<CatalogItem> items =
                  catalogModel.getItemsByCategory(categoriesKeys[index]);
              if (items.isEmpty) return Container();
              return Column(
                children: [
                  const Divider(),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      shrinkWrap: true,
                      itemCount: items.length > 4 ? 4 : items.length,
                      itemBuilder: (_, index) => CatalogListItem(
                        id: items[index].id,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
