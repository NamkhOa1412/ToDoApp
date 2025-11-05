import 'package:flutter/material.dart';
import 'package:ktodo_application/model/board.dart';

class MenuBoard extends StatefulWidget {
  final Boards board;
  MenuBoard({super.key, required this.board});

  @override
  State<MenuBoard> createState() => _MenuBoardState();
}

class _MenuBoardState extends State<MenuBoard> {
  @override
  Widget build(BuildContext context) {
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
                            flex: 9,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'MenuBoard',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),

                          Column()
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