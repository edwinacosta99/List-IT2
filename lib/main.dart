import 'package:flutter/material.dart';
import 'screens/board_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
