import 'package:flutter/material.dart';
import 'package:myapp/screens/tasklist_screen.dart';
import 'package:myapp/widget/board_widget.dart';

class BoardsPage extends StatefulWidget {
  @override
  _BoardsPageState createState() => _BoardsPageState();
}

class _BoardsPageState extends State<BoardsPage> {
  List<Board> boards = [];

  void _addBoard() async {
    final boardName = await _showAddBoardDialog();
    if (boardName != null && boardName.isNotEmpty) {
      setState(() {
        boards.add(Board(name: boardName, taskLists: []));
      });
    }
  }

  Future<String?> _showAddBoardDialog() {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Board'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter board name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
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

  void _onBoardUpdated() {
    setState(() {});
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: boards.map((board) {
            return BoardWidget(
              board: board,
              onBoardUpdated: _onBoardUpdated,
              onBoardSelected: () => _onBoardSelected(board),
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
