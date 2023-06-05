import 'package:etrick/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        children: Constants.categories.keys.map((String category) {
          return Card(
            child: InkWell(
              onTap: () {
                context.push('/$category');
              },
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Image.asset(
                      Constants.getCategoryAsset(category),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(Constants.categories[category]!),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
