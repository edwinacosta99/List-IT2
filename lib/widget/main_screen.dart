import 'package:flutter/material.dart';
import 'board_widget.dart';
import '../screens/tasklist_screen.dart'; // Importa la pantalla para manejar TaskLists
import '../screens/boards_page.dart'; // Asegúrate de que Board y BoardList estén importados

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Board> boards = [];

  void _addBoard() {
    setState(() {
      boards.add(Board(name: 'New Board', taskLists: []));
    });
  }

  void _onBoardUpdated() {
    setState(() {});
  }

  void _onBoardSelected(Board board) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskListScreen(
          board: board,
          onBoardUpdated: _onBoardUpdated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Boards')),
      body: ListView(
        children: boards.map((board) {
          return BoardWidget(
            board: board,
            onBoardUpdated: _onBoardUpdated,
            onBoardSelected: () => _onBoardSelected(board), // Proporcionar el parámetro requerido
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBoard,
        child: Icon(Icons.add),
        tooltip: 'Add Board',
      ),
    );
  }
}
