import 'package:flutter/material.dart';
import 'screens/boards_page.dart';
import 'screens/settings_page.dart';
import 'auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  // Agregado `key`

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List-it',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const AuthHandler(),  // Cambio aquí
    );
  }
}

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});  // Agregado `key`

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();  // Añadido const
        } else if (snapshot.hasData) {
          return HomePage();  // Removido const
        } else {
          return LoginScreen();  // Removido const
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});  // Agregado `key`

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),  // Añadido const
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BoardsPage()),  // Removido const
                );
              },
              child: const Text('Go to Boards'),  // Añadido const
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),  // Removido const
                );
              },
              child: const Text('Go to Settings'),  // Añadido const
            ),
          ],
        ),
      ),
    );
  }
}
