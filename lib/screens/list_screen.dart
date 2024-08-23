import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Necesario para codificar y decodificar JSON
import 'card_screen.dart';

class ListScreen extends StatefulWidget {
  final String boardName;

  ListScreen({required this.boardName});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<String> lists = [];
  Map<String, List<String>> cards = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Cargar los datos guardados
  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lists = prefs.getStringList('${widget.boardName}_lists') ?? [];
      String? cardsJson = prefs.getString('${widget.boardName}_cards');
      if (cardsJson != null) {
        cards = Map<String, List<String>>.from(json.decode(cardsJson));
      } else {
        // Inicializar listas y tarjetas si no hay datos guardados
        if (lists.isEmpty) {
          lists = ['To Do', 'In Progress', 'Done'];
          cards = {
            'To Do': [],
            'In Progress': [],
            'Done': [],
          };
        }
      }
    });
  }

  // Guardar los datos
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('${widget.boardName}_lists', lists);
    await prefs.setString('${widget.boardName}_cards', json.encode(cards));
  }

  void _addNewList() {
    final TextEditingController _listNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New List'),
          content: TextField(
            controller: _listNameController,
            decoration: InputDecoration(hintText: 'Enter list name'),
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
                if (_listNameController.text.isNotEmpty) {
                  setState(() {
                    lists.add(_listNameController.text);
                    cards[_listNameController.text] = []; // Inicializar lista de tarjetas
                    _saveData(); // Guardar datos cuando se añade una nueva lista
                  });
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

  void _editList(int index) {
    final TextEditingController _listNameController = TextEditingController(text: lists[index]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit List'),
          content: TextField(
            controller: _listNameController,
            decoration: InputDecoration(hintText: 'Enter new list name'),
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
                if (_listNameController.text.isNotEmpty) {
                  setState(() {
                    String oldName = lists[index];
                    lists[index] = _listNameController.text;
                    cards[_listNameController.text] = cards.remove(oldName) ?? [];
                    _saveData(); // Guardar datos cuando se edita una lista
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

  void _deleteList(int index) {
    setState(() {
      String listName = lists[index];
      cards.remove(listName); // Eliminar tarjetas asociadas con la lista
      lists.removeAt(index);
      _saveData(); // Guardar datos cuando se elimina una lista
    });
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete List'),
          content: Text('Are you sure you want to delete this list?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteList(index);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addCard(String listName) {
    final TextEditingController _cardNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Card'),
          content: TextField(
            controller: _cardNameController,
            decoration: InputDecoration(hintText: 'Enter card name'),
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
                if (_cardNameController.text.isNotEmpty) {
                  setState(() {
                    cards[listName] = cards[listName] ?? []; // Asegurarse de que la lista no sea nula
                    cards[listName]!.add(_cardNameController.text);
                    _saveData(); // Guardar datos cuando se añade una tarjeta
                  });
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

  void _editCard(String listName, int cardIndex) async {
    final updatedCardName = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardScreen(
          listName: listName,
          cardName: cards[listName]![cardIndex],
        ),
      ),
    );

    if (updatedCardName != null && updatedCardName != cards[listName]![cardIndex]) {
      setState(() {
        cards[listName]![cardIndex] = updatedCardName;
        _saveData(); // Guardar datos cuando se edita una tarjeta
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
      ),
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lists.length,
        itemBuilder: (context, index) {
          return Container(
            width: 250,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lists[index],
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Edit') {
                          _editList(index);
                        } else if (value == 'Delete') {
                          _showDeleteConfirmationDialog(index);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cards[lists[index]]?.length ?? 0,
                    itemBuilder: (context, cardIndex) {
                      return Card(
                        color: Colors.grey[800],
                        child: ListTile(
                          title: Text(cards[lists[index]]![cardIndex]),
                          onTap: () => _editCard(lists[index], cardIndex),
                        ),
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => _addCard(lists[index]),
                  child: Text(
                    '+ Add card',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewList,
        child: Icon(Icons.add),
      ),
    );
  }
}
