import 'package:flutter/material.dart';
import 'package:ktodo_application/model/card-detail.dart';
import 'package:ktodo_application/utils/string-utils.dart';

class CommentUI extends StatelessWidget {
  final List<Comments> comment;
  const CommentUI({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    if (comment.isEmpty) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comment.map((comment) {
        return Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.comment, color: Colors.black, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.user?.username ?? 'Unknown',
                      style: const TextStyle(
                        color: Color(0xFF26A69A),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      comment.content ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      StringUtils.formatDate(comment.createdAt!),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}