import 'package:flutter/material.dart';
import 'boards_screen.dart';
import 'settings.dart';

class HomeScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('List-it Home'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BoardsScreen()),
                );
              },
              child: Text('Go to Boards'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );                // Navegar a otra funcionalidad, por ejemplo, Configuración
              },
              child: Text('Settings'),
            ),
            // Agrega más botones para otras funcionalidades
          ],
        ),
      ),
    );
  }
}
