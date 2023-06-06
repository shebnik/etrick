import 'package:flutter/material.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({super.key});

  @override
  State<HomeMainPage> createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
          'HomeMainPage is working',
          style: TextStyle(fontSize: 20),
        ),
    );
  }
}
