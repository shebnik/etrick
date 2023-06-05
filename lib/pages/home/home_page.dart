import 'package:etrick/models/catalog_model.dart';
import 'package:etrick/pages/home/navigation_pages/catalog/catalog_page.dart';
import 'package:etrick/pages/home/navigation_pages/home_main_page.dart';
import 'package:etrick/pages/home/navigation_pages/profile_page.dart';
import 'package:etrick/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = [
    HomeMainPage(),
    CatalogPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Головна',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Каталог',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профіль',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: _widgetOptions.elementAt(_selectedIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<CatalogModel>().items = await FirestoreService.getCatalog();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
