import 'package:flutter/material.dart';
import 'my_app_bar.dart';
import 'my_search_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _handleSearch(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MySearchPage(initialQuery: query),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(onSearch: _handleSearch),
      body: const Center(child: Text('Welcome to Yams Search!')),
    );
  }
}
