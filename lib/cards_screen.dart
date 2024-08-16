import 'package:flutter/material.dart';
import '../models/task_list.dart';

// Aquí se define el resto del código para la pantalla de tarjetas.


class CardsScreen extends StatelessWidget {
  final TaskList taskList;

  CardsScreen({required this.taskList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(taskList.title),
      ),
      body: ListView.builder(
        itemCount: taskList.cards.length,
        itemBuilder: (context, index) {
          final cardItem = taskList.cards[index];
          return ListTile(
            title: Text(cardItem.title),
            subtitle: Text(cardItem.description),
            onTap: () {
              // Lógica para editar o ver los detalles de la tarjeta
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para agregar una nueva tarjeta
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
