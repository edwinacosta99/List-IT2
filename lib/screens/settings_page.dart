import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Settings Page'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Change Theme'),
            onTap: () {
              // Lógica para cambiar el tema
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Change Language'),
            onTap: () {
              // Lógica para cambiar el idioma
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy Settings'),
            onTap: () {
              // Lógica para abrir configuraciones de privacidad
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              // Lógica para cerrar sesión
            },
          ),
          // Agrega más opciones de configuración según sea necesario
        ],
      ),
    );
  }
}
