import 'package:flutter/material.dart';
import 'screens/board_screen.dart';

void main() {
  runApp(ListItApp());
}

class ListItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List-It',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
        ),
      ),
      home: BoardScreen(),
    );
  }
}
