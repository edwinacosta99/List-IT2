import 'package:flutter/material.dart';
import '../models/board.dart';
import 'package:myapp/tasklist_screen.dart';


class BoardsScreen extends StatelessWidget {
  final List<Board> boards = [
    Board(id: '1', title: 'Project 1', taskLists: []),
    Board(id: '2', title: 'Project 2', taskLists: []),
    // Agrega más tableros si lo deseas
  ];

  BoardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boards'),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return ListTile(
            title: Text(board.title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskListsScreen(board: board),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para agregar un nuevo tablero
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
