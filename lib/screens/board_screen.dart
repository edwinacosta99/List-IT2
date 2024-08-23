import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_screen.dart';
import '../services/auth_service.dart';

class BoardScreen extends StatefulWidget {
  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  final List<String> boards = [];

  @override
  void initState() {
    super.initState();
    _loadBoards();
  }

  void _loadBoards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      boards.addAll(prefs.getStringList('boards') ?? []);
    });
  }

  void _saveBoards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('boards', boards);
  }

  void _addNewBoard(String boardName) {
    setState(() {
      boards.add(boardName);
      _saveBoards();
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

  void _editBoard(int index) {
    final TextEditingController _boardNameController =
        TextEditingController(text: boards[index]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Board'),
          content: TextField(
            controller: _boardNameController,
            decoration: InputDecoration(hintText: 'Enter new board name'),
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
                  setState(() {
                    boards[index] = _boardNameController.text;
                    _saveBoards();
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBoard(int index) {
    setState(() {
      boards.removeAt(index);
      _saveBoards();
    });
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Board'),
          content: Text('Are you sure you want to delete this board?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteBoard(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _signOut() async {
    await AuthService()
        .signout(context: context); // Usar el argumento con nombre
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boards'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
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
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  leading: Icon(
                    Icons.dashboard,
                    color: Colors.blue,
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editBoard(index);
                      } else if (value == 'delete') {
                        _showDeleteConfirmationDialog(index);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ];
                    },
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
