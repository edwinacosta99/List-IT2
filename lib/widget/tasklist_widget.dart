import 'package:flutter/material.dart';
import '../screens/boards_page.dart';
import 'card_widget.dart';

class TaskListWidget extends StatefulWidget {
  final TaskList taskList;
  final VoidCallback onTaskListUpdated;

  TaskListWidget({required this.taskList, required this.onTaskListUpdated});

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blue,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          _buildTaskListTitle(context),
          Column(
            children: widget.taskList.cards.map((card) {
              return CardWidget(card: card);
            }).toList(),
          ),
          ElevatedButton(
            onPressed: _addCard,
            child: Text('Add Card'),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskListTitle(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final newName = await _showEditDialog(context, widget.taskList.name);
        if (newName != null && newName.isNotEmpty) {
          setState(() {
            widget.taskList.name = newName;
          });
          widget.onTaskListUpdated();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.taskList.name,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Future<String?> _showEditDialog(BuildContext context, String currentName) {
    TextEditingController controller = TextEditingController(text: currentName);

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit TaskList Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter task list name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addCard() async {
    final cardName = await _showAddCardDialog(context);
    if (cardName != null && cardName.isNotEmpty) {
      setState(() {
        widget.taskList.cards.add(CardItem(content: cardName));
      });
      widget.onTaskListUpdated();
    }
  }

  Future<String?> _showAddCardDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Card'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter card name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
