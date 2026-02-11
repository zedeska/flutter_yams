import 'package:flutter/material.dart';
import 'Modele/api.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Yams Search',
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

class MyAppBar extends StatefulWidget {
  
  const MyAppBar({super.key});

  @override
  State<MyAppBar> createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MySearchPage extends StatefulWidget {
  const MySearchPage({super.key});

  @override
  State<MySearchPage> createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  final Api api = Api();
  String query = '';
  Map<String, dynamic>? searchResults;

  void performSearch() async {
    try {
      final results = await api.search(query);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      // Handle error
      print('Error performing search: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}