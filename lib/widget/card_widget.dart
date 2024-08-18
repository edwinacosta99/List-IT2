import 'package:flutter/material.dart';
import '../screens/boards_page.dart';

class CardWidget extends StatelessWidget {
  final CardItem card;

  CardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6),
      margin: EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Text(card.content),
    );
  }
}
