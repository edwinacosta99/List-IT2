import 'package:flutter/material.dart';

class CardScreen extends StatelessWidget {
  final String listName;
  final String cardName;

  CardScreen({required this.listName, required this.cardName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cardName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cardName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Descripción de la tarea...'),
            // Aquí puedes añadir más campos para fechas límite, etiquetas, etc.
          ],
        ),
      ),
    );
  }
}
