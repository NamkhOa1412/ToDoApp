import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ktodo_application/components/app-menu.dart';
import 'package:ktodo_application/components/dialog-custom.dart';
import 'package:ktodo_application/components/list-select.dart';
import 'package:ktodo_application/model/list-board.dart';
import 'package:ktodo_application/providers/board-provider.dart';
import 'package:ktodo_application/providers/card-provider.dart';
import 'package:ktodo_application/screens/board/task-card.dart';
import 'package:ktodo_application/screens/card/card-info.dart';
import 'package:provider/provider.dart';

class BoardColumn extends StatefulWidget {
  final ListBoard list;
  final String board_id;
  const BoardColumn({required this.list, required this.board_id});

  @override
  _BoardColumnState createState() => _BoardColumnState();
}

class _BoardColumnState extends State<BoardColumn> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    boardProvider.loadCard(widget.list.id.toString(), widget.board_id);

    Future.microtask(() {
      context.read<BoardProvider>().loadCard(widget.list.id.toString(), widget.board_id);
    });

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      context.read<BoardProvider>().loadCard(widget.list.id.toString(), widget.board_id);
    });

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    final cardProvider = Provider.of<CardProvider>(context);
    final cards = boardProvider.cardsByList[widget.list.id] ?? [];
    final listBoard = context.watch<BoardProvider>().listBorad;
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
            GestureDetector(
              onLongPressStart: (details) async {
                final result = await showAppMenu(
                  context: context,
                  position: details.globalPosition,
                  items: {
                    'delete': 'Xóa Card',
                    'update': 'Sửa tiêu đề thẻ',
                    'move': 'Di chuyển thẻ'
                  },
                );

                switch (result) {
                  case 'delete':
                    ConfirmLogoutDialog.show(context: context, title: 'Xác nhận xóa', message: 'Bạn có chắc chắn muốn xóa thẻ này!', onPressed: () async {
                      await cardProvider.deleteCard(card.id.toString(), context) == true ?
                      boardProvider.loadCard(widget.list.id.toString(), widget.board_id) : null;
                    });
                    break;

                  case 'update':
                    final TextEditingController titleCtrl = TextEditingController();
                    DialogAdd.show(context: context,Ctrl: titleCtrl, 
                      onPressed: () async {
                        final title = titleCtrl.text.trim();
                        await cardProvider.updateTitleCard(card.id.toString(),title, context) == true ?
                        boardProvider.loadCard(widget.list.id.toString(), widget.board_id) : null;
                    }, title: 'Tên thẻ',hintText: 'Nhập tên thẻ');
                    break;

                  case 'move':
                      if (!mounted) return;
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                        ),
                        builder: (context) {
                          return ListSelectSheet(
                            list: listBoard ?? [],
                            title: 'Chọn danh sách cần chuyển đến',
                            onSelect: (l) async {
                              if ( await cardProvider.moveCard(card.id.toString(),l.id.toString(), context) == true ) {
                                boardProvider.loadCard(widget.list.id.toString(), widget.board_id);
                                boardProvider.loadCard(l.id.toString(), widget.board_id);
                              };
                            },
                          );
                        },
                      );
                  break;
                }
              },

              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => CardProvider(),
                    child: CardInfo(card: card),
                  ),
                ),
              );

            } ,child: TaskCard(title: card.title ?? 'Không có tiêu đề')),
            const SizedBox(height: 6),
          ],
          const SizedBox(height: 6),
          TextButton(
            onPressed: () {
              final TextEditingController titleCtrl = TextEditingController();
              final TextEditingController desCtrl = TextEditingController();
              DialogAddCard.show(context: context,Ctrl1: titleCtrl, Ctrl2: desCtrl,
                onPressed: () async {
                  final title = titleCtrl.text.trim();
                  final des = desCtrl.text.trim();
                  await cardProvider.createCard(widget.list.id.toString(),title,des, context) == true ?
                  boardProvider.loadCard(widget.list.id.toString(), widget.board_id) : null;
              }, title1: '* Tên thẻ',hintText1: 'Nhập tên thẻ', title2: 'Mô tả', hintText2: 'Nhập mô tả');
            },
            child: const Text("+ Thêm thẻ",
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
