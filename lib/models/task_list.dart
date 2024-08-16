import 'package:myapp/models/card_item.dart';

class TaskList {
  String id;
  String title;
  List<CardItem> cards;

  TaskList({required this.id, required this.title, required this.cards});
}