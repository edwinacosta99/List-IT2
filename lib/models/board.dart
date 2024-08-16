import 'package:myapp/models/task_list.dart';

class Board {
  String id;
  String title;
  List<TaskList> taskLists;

  Board({required this.id, required this.title, required this.taskLists});
}