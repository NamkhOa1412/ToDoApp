import 'package:flutter/material.dart';
import 'package:ktodo_application/model/card-detail.dart';

class CheckListUI extends StatefulWidget {
  final List<Checklists> checklists;
  const CheckListUI({super.key, required this.checklists});

  @override
  State<CheckListUI> createState() => _CheckListUIState();
}

class _CheckListUIState extends State<CheckListUI> {
  @override
  Widget build(BuildContext context) {
    if (widget.checklists.isEmpty) {
      return const Text(
        'Chưa có danh sách công việc',
        style: TextStyle(color: Colors.white70),
      );
    }

    final Map<String, bool> expandedStatus = {
      for (var cl in widget.checklists) cl.id!: true,
    };

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.checklists.map((cl) {
            final totalTasks = cl.items!.length;
            final doneTasks = cl.items!.where((t) => t.isDone!).length;
            final progress = totalTasks > 0 ? doneTasks / totalTasks : 0.0;
            final isExpanded = expandedStatus[cl.id!]!;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header + expand/collapse
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cl.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              expandedStatus[cl.id!] = !isExpanded;
                            });
                          },
                          child: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.more_vert, color: Colors.white70, size: 20),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Progress line luôn hiển thị
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final maxWidth = constraints.maxWidth;
                        return Stack(
                          children: [
                            Container(
                              height: 4,
                              width: maxWidth,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              height: 4,
                              width: maxWidth * progress,
                              decoration: BoxDecoration(
                                color: const Color(0xFF26A69A),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    // Nếu expanded mới hiển thị tasks
                    if (isExpanded) ...[
                      const SizedBox(height: 12),
                      Column(
                        children: cl.items!.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: item.isDone,
                                  onChanged: (val) {},
                                  activeColor: const Color(0xFF26A69A),
                                ),
                                Expanded(
                                  child: Text(
                                    item.content!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      decoration: item.isDone!
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      decorationColor: Colors.white,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Thêm mục...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}