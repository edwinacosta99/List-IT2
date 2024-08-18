import 'package:flutter/material.dart';
import '../screens/boards_page.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final VoidCallback onBoardUpdated;
  final VoidCallback onBoardSelected;

  BoardWidget({
    required this.board,
    required this.onBoardUpdated,
    required this.onBoardSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onBoardSelected,
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
        margin: EdgeInsets.all(8),
        child: Center(
          child: Text(
            board.name,
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
