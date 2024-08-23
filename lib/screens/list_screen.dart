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
        // Si no hay datos guardados, inicializamos las listas vacías
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

  void _deleteList(int index) {
    setState(() {
      cards.remove(lists[index]);
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
                    Text(
                      lists[index],
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteConfirmationDialog(index),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: cards[lists[index]]!.length,
                    itemBuilder: (context, cardIndex) {
                      return Card(
                        color: Colors.grey[800],
                        child: ListTile(
                          title: Text(cards[lists[index]]![cardIndex]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CardScreen(
                                  listName: lists[index],
                                  cardName: cards[lists[index]]![cardIndex],
                                ),
                              ),
                            );
                          },
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
        onPressed: () {
          setState(() {
            lists.add('New List');
            cards['New List'] = [];
            _saveData(); // Guardar datos cuando se añade una nueva lista
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
