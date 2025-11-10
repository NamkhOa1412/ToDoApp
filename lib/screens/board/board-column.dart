import 'package:flutter/material.dart';
import 'package:ktodo_application/model/list-board.dart';
import 'package:ktodo_application/screens/board/task-card.dart';

class BoardColumn extends StatelessWidget {
  final ListBoard list;
  const BoardColumn({required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Color(0xFF26A69A),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(list.title.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(height: 8),
          // TaskCard(title: "Plan Game"),
          // TaskCard(title: "Project 002", date: "3 thg 3"),
          // TaskCard(title: "Project 002", date: "3 thg 3"),\
          const SizedBox(height: 6),
          TextButton(
            onPressed: () {},
            child: const Text("+ Thêm thẻ",
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
