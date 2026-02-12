import 'package:flutter/material.dart';
import 'Vue/my_home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Yams Search',
      // The HomePage is where we connect the AppBar and the Search Body
      home: MyHomePage(),
    );
  }
}
