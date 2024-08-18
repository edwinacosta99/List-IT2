import 'package:flutter/material.dart';
import '../screens/boards_page.dart';
import 'tasklist_widget.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final VoidCallback onBoardUpdated;

  BoardWidget({required this.board, required this.onBoardUpdated});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: Colors.red,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          _buildBoardTitle(context),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: board.taskLists.map((taskList) {
                  return TaskListWidget(
                    taskList: taskList,
                    onTaskListUpdated: onBoardUpdated,
                  );
                }).toList(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addTaskList();
              onBoardUpdated();
            },
            child: Text('Add TaskList'),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardTitle(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final newName = await _showEditDialog(context, board.name);
        if (newName != null && newName.isNotEmpty) {
          board.name = newName;
          onBoardUpdated();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          board.name,
          style: TextStyle(color: Colors.white, fontSize: 20),
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

  void _addTaskList() {
    board.taskLists.add(TaskList(name: 'New TaskList', cards: []));
  }
}
