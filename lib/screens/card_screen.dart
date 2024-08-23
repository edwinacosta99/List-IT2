import 'package:flutter/material.dart';

class CardScreen extends StatefulWidget {
  final String listName;
  final String cardName;

  CardScreen({required this.listName, required this.cardName});

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late TextEditingController _cardNameController;

  @override
  void initState() {
    super.initState();
    _cardNameController = TextEditingController(text: widget.cardName);
  }

  @override
  void dispose() {
    _cardNameController.dispose();
    super.dispose();
  }

  void _updateCardName() {
    if (_cardNameController.text.isNotEmpty) {
      // Update the card name here
      Navigator.of(context).pop(_cardNameController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cardName),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _cardNameController,
              decoration: InputDecoration(labelText: 'Card Description'),
              maxLines: null, // Allows multiline input
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateCardName,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
