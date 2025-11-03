import 'package:flutter/material.dart';
import 'package:ktodo_application/model/board.dart';

class TaskCard extends StatelessWidget {
  final Boards boards;

  const TaskCard({
    super.key,
    required this.boards
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xff009688), // teal
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    boards.title.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        boards.description.toString(),
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Row info
                Row(
                  children: [
                    Icon(Icons.comment, size: 16),
                    const SizedBox(width: 4),
                    // Text("$comments", style: const TextStyle(fontSize: 13)),

                    const SizedBox(width: 12),
                    Icon(Icons.person, size: 16),
                    const SizedBox(width: 4),
                    Text(boards.memberCount.toString(), style: const TextStyle(fontSize: 13)),

                    const Spacer(),
                    // Text(
                    //   date,
                    //   style: const TextStyle(
                    //       fontSize: 12, color: Colors.grey),
                    // )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
