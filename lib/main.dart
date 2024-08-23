import 'package:flutter/material.dart';
import 'screens/board_screen.dart';
import 'screens/login.dart';  // Importación de la pantalla de Login
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Importar FirebaseAuth

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
      home: AuthWrapper(), // Cambiado para usar AuthWrapper
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Indicador de carga centrado mientras se espera
        } else if (snapshot.hasData) {
          return BoardScreen(); // Usuario autenticado
        } else {
          return Login(); // Usuario no autenticado
        }
      },
    );
  }
}