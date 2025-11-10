import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String? date;
  const TaskCard({required this.title, this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            if (date != null)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red[800],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(date!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
