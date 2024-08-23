import 'package:flutter/material.dart';
import 'list_screen.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final List<String> boards = [];

  void _addNewBoard(String boardName) {
    setState(() {
      boards.add(boardName);
    });
  }

  void _showAddBoardDialog() {
    final TextEditingController _boardNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Board'),
          content: TextField(
            controller: _boardNameController,
            decoration: InputDecoration(hintText: 'Enter board name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_boardNameController.text.isNotEmpty) {
                  _addNewBoard(_boardNameController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boards'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Lógica para búsqueda
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Lógica para notificaciones
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('list-it Workspace'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Board 1'),
              onTap: () {
                // Lógica para abrir otro tablero
              },
            ),
          ],
        ),
      ),
      body: boards.isEmpty
          ? Center(
              child: Text(
                'No boards created. Add a new board.',
                style: TextStyle(color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: boards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    boards[index],
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    Icons.dashboard,
                    color: Colors.blue,
                  ),
                  trailing: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ListScreen(boardName: boards[index]),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBoardDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
