import 'package:flutter/material.dart';
import 'package:ktodo_application/model/board.dart';
import 'package:ktodo_application/providers/board-provider.dart';
import 'package:ktodo_application/screens/card/menu-board.dart';
import 'package:provider/provider.dart';

class TaskInfo extends StatefulWidget {
  final Boards boards;
  const TaskInfo({super.key, required this.boards});

  @override
  State<TaskInfo> createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                widget.boards.title.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: Icon(Icons.more_horiz_rounded, color: Colors.black),
                                onPressed: () async {
                                  await boardProvider.getInfoBoard(widget.boards.id.toString());
                                  if (!mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => MenuBoard(board: widget.boards)),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}