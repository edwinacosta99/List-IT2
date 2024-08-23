import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  void _loadData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    lists = prefs.getStringList('${widget.boardName}_lists') ?? [];
    String? cardsJson = prefs.getString('${widget.boardName}_cards');
    if (cardsJson != null) {
      Map<String, dynamic> decodedMap = json.decode(cardsJson);
      // Convertimos cada valor del mapa a List<String>
      cards = decodedMap.map((key, value) {
        return MapEntry(key, List<String>.from(value));
      });
    } else {
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
                    cards[_listNameController.text] = [];
                    _saveData();
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
                    cards[listName] = cards[listName] ?? [];
                    cards[listName]!.add(_cardNameController.text);
                    _saveData();
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

  void _onCardDropped(String fromList, String toList, int cardIndex) {
    setState(() {
      String card = cards[fromList]!.removeAt(cardIndex);
      cards[toList]!.add(card);
      _saveData();
    });
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
          String listName = lists[index];
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
                        listName,
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
                          // Implementar la funcionalidad de edición aquí
                        } else if (value == 'Delete') {
                          // Implementar la funcionalidad de eliminación aquí
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
                  child: DragTarget<String>(
                    onAccept: (data) {
                      int cardIndex = int.parse(data.split('-')[1]);
                      String fromList = data.split('-')[0];
                      _onCardDropped(fromList, listName, cardIndex);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return ListView.builder(
                        itemCount: cards[listName]!.length,
                        itemBuilder: (context, cardIndex) {
                          String card = cards[listName]![cardIndex];
                          return Draggable<String>(
                            data: '$listName-$cardIndex',
                            feedback: Material(
                              color: Colors.transparent,
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                color: Colors.grey[700],
                                child: Text(
                                  card,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(),
                            child: Card(
                              color: Colors.grey[800],
                              child: ListTile(
                                title: Text(card),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => _addCard(listName),
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
