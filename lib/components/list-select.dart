import 'package:flutter/material.dart';
import 'package:ktodo_application/model/board-users.dart';
import 'package:ktodo_application/model/list-board.dart';

class ListSelectSheet extends StatelessWidget {
  final List<ListBoard> list;
  final String title;
  final Function(ListBoard) onSelect;

  const ListSelectSheet({
    super.key,
    required this.list,
    required this.title,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // "Chọn danh sách cần chuyển đến",
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final l = list[index];
                return GestureDetector(
                  onTap: () => onSelect(l),

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // nền xám
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      l.title ?? "Không tên",
                      style: const TextStyle(
                        fontSize: 18,                     // chữ to hơn
                        color: Color(0xFF26A69A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}