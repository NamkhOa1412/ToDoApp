import 'package:flutter/material.dart';
import 'package:ktodo_application/model/board.dart';
import 'package:ktodo_application/providers/board-provider.dart';
import 'package:ktodo_application/screens/card/task-card.dart';
import 'package:ktodo_application/screens/task-info.dart';
import 'package:provider/provider.dart';

class ListTask extends StatelessWidget {
  const ListTask({super.key});

  @override
  Widget build(BuildContext context) {
    final boards = context.watch<BoardProvider>().listBoards;

    if (boards.isEmpty) {
      return SizedBox();
    }

    return ListView.builder(
      itemCount: boards.length,
      itemBuilder: (context, index) {
        final board = boards[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TaskInfo(boards: board,)),
            );
          },
          child: TaskCard(boards: board)
        );
      },
    );
  }
}