import 'package:flutter/material.dart';
import 'package:myapp/widget/board_widget.dart';

class BoardsPage extends StatefulWidget {
  @override
  _BoardsPageState createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  List<Board> boards = [];

  void _addBoard() {
    setState(() {
      String boardName = 'Board ${boards.length + 1}';
      boards.add(Board(name: boardName, taskLists: []));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boards'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addBoard,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: boards.map((board) {
            return BoardWidget(
              board: board,
              onBoardUpdated: () {
                setState(() {});  // Actualiza la pantalla cuando se modifica un board
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Board {
  String name;
  List<TaskList> taskLists;

  Board({required this.name, required this.taskLists});
}

class TaskList {
  String name;
  List<CardItem> cards;

  TaskList({required this.name, required this.cards});
}

class CardItem {
  String content;

  CardItem({required this.content});
}
