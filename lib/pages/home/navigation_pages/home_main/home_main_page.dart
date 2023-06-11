import 'package:etrick/constants.dart';
import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/catalog_list_item.dart';
import 'package:etrick/providers/search_provider.dart';
import 'package:etrick/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({Key? key}) : super(key: key);

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _showSearchBar = true;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _showSearchBar = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var catalogModel = context.watch<CatalogModel>();
    Map<String, String> categories = Constants.categories;
    List<String> categoriesKeys = categories.keys.toList();
    List<String> categoriesValues = categories.values.toList();
    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: _showSearchBar ? 56.0 : 0.0,
            floating: true,
            snap: true,
            elevation: 0,
            flexibleSpace: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: AppSearchBar(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    "Новинки",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Consumer<SearchProvider>(
            builder: (context, value, child) => value.searchValue != ''
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        List<CatalogItem> items =
                            catalogModel.getItemsBySearch(value);
                        if (items.isEmpty) return Container();
                        return Column(
                          children: [
                            const Divider(),
                            Text(
                              'Результаты поиска',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.35,
                              ),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 0.7 * 2.5,
                                ),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: items.length > 4 ? 4 : items.length,
                                itemBuilder: (_, index) => CatalogListItem(
                                  key: UniqueKey(),
                                  id: items[index].id,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: 1,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        List<CatalogItem> items = catalogModel
                            .getItemsByCategory(categoriesKeys[index]);
                        if (items.isEmpty) return Container();
                        return Column(
                          children: [
                            const Divider(),
                            Text(
                              categoriesValues[index],
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.35,
                              ),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 0.7 * 2.5,
                                ),
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: items.length > 4 ? 4 : items.length,
                                itemBuilder: (_, index) => CatalogListItem(
                                  key: UniqueKey(),
                                  id: items[index].id,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      childCount: categories.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
