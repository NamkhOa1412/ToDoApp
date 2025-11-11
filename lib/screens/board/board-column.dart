import 'package:flutter/material.dart';
import 'package:ktodo_application/model/list-board.dart';
import 'package:ktodo_application/providers/board-provider.dart';
import 'package:ktodo_application/screens/board/task-card.dart';
import 'package:provider/provider.dart';

class BoardColumn extends StatefulWidget {
  final ListBoard list;
  final String board_id;
  const BoardColumn({required this.list, required this.board_id});

  @override
  _BoardColumnState createState() => _BoardColumnState();
}

class _BoardColumnState extends State<BoardColumn> {
  @override
  void initState() {
    super.initState();
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    boardProvider.loadCard(widget.list.id.toString(), widget.board_id);
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    final cards = boardProvider.cardsByList[widget.list.id] ?? [];
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
          Text(widget.list.title.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(height: 8),
          // TaskCard(title: title)
          for (var card in cards) ...[
            TaskCard(title: card.title ?? "Không có tiêu đề"),
            const SizedBox(height: 6),
          ],
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
