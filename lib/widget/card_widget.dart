import 'package:flutter/material.dart';
import '../screens/boards_page.dart';

class CardWidget extends StatefulWidget {
  final CardItem card;

  CardWidget({required this.card});

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final newName = await _showEditCardDialog(context, widget.card.content);
        if (newName != null && newName.isNotEmpty) {
          setState(() {
            widget.card.content = newName;
          });
        }
      },
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.all(4),
        child: ListTile(
          title: Text(widget.card.content),
        ),
      ),
    );
  }

  Future<String?> _showEditCardDialog(BuildContext context, String currentName) {
    TextEditingController controller = TextEditingController(text: currentName);

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Card Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new card name'),
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
