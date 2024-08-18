import 'package:flutter/material.dart';
import 'package:myapp/widget/tasklist_widget.dart';
import '../screens/boards_page.dart';

class TaskListScreen extends StatefulWidget {
  final Board board;
  final VoidCallback onBoardUpdated;

  TaskListScreen({
    required this.board,
    required this.onBoardUpdated,
  });

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  void _addTaskList() {
    setState(() {
      widget.board.taskLists.add(TaskList(name: 'New TaskList', cards: []));
    });
    widget.onBoardUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () async {
            final newName = await _showEditDialog(context, widget.board.name);
            if (newName != null && newName.isNotEmpty) {
              setState(() {
                widget.board.name = newName;
              });
              widget.onBoardUpdated();
            }
          },
          child: Text(widget.board.name),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: widget.board.taskLists.map((taskList) {
            return TaskListWidget(
              taskList: taskList,
              onTaskListUpdated: () {
                setState(() {});
                widget.onBoardUpdated();
              },
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskList,
        child: Icon(Icons.add),
      ),
    );
  }

  Future<String?> _showEditDialog(BuildContext context, String currentName) {
    TextEditingController controller = TextEditingController(text: currentName);

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Board Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter board name'),
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
}
