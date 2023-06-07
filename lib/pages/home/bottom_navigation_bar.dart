import 'package:etrick/models/tab_item.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/catalog_page.dart';
import 'package:etrick/pages/home/navigation_pages/home_main/home_main_page.dart';
import 'package:etrick/pages/home/navigation_pages/profile/profile_page.dart';
import 'package:etrick/providers/bottom_navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<TabItem> tabBar = [
  TabItem(
    index: 0,
    title: 'Головна',
    icon: const Icon(Icons.home),
    page: const HomeMainPage(),
  ),
  TabItem(
    index: 1,
    title: 'Каталог',
    icon: const Icon(Icons.list),
    page: const CatalogPage(),
  ),
  TabItem(
    index: 2,
    title: 'Профіль',
    icon: const Icon(Icons.person),
    page: const ProfilePage(),
  ),
];

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  State<AppBottomNavigationBar> createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    _tabController = TabController(
      length: tabBar.length,
      vsync: this,
      initialIndex: _selectedIndex.value,
    );
    _tabController.addListener(() {
      _selectedIndex.value = _tabController.index;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (_, provider, __) => BottomNavigationBar(
        currentIndex: provider.currentIndex,
        onTap: (index) {
          _tabController.animateTo(index);
          _selectedIndex.value = index;
        },
        items: tabBar
            .map(
              (e) => BottomNavigationBarItem(
                icon: e.icon,
                label: e.title,
              ),
            )
            .toList(),
      ),
    );
  }
}
