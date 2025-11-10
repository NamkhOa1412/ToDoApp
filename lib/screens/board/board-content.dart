import 'package:flutter/material.dart';
import 'package:ktodo_application/providers/board-provider.dart';
import 'package:ktodo_application/screens/board/board-column.dart';
import 'package:provider/provider.dart';

class BoardContent extends StatelessWidget {
  // final List<String> columns = ['Plan', 'Cần làm', 'Đang làm', 'Hoàn thành'];

  @override
  Widget build(BuildContext context) {
    final listBoard = context.watch<BoardProvider>().listBorad;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listBoard.map((col) => BoardColumn(list: col)).toList(),
      ),
    );
  }
}
