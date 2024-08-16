import 'package:flutter/material.dart';
import '../../models/board.dart';
import 'cards_screen.dart';

// Aquí se define el resto del código para la pantalla de listas.


class TaskListsScreen extends StatelessWidget {
  final Board board;

  TaskListsScreen({required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(board.title),
      ),
      body: ListView.builder(
        itemCount: board.taskLists.length,
        itemBuilder: (context, index) {
          final taskList = board.taskLists[index];
          return ListTile(
            title: Text(taskList.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardsScreen(taskList: taskList),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para agregar una nueva lista
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
