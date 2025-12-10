import 'package:flutter/material.dart';
import 'package:ktodo_application/components/app-menu.dart';
import 'package:ktodo_application/components/dialog-custom.dart';
import 'package:ktodo_application/components/list-select.dart';
import 'package:ktodo_application/model/board.dart';
import 'package:ktodo_application/providers/board-provider.dart';
import 'package:ktodo_application/providers/card-provider.dart';
import 'package:ktodo_application/screens/board/board-content.dart';
import 'package:ktodo_application/screens/card/menu-board.dart';
import 'package:provider/provider.dart';

class TaskInfo extends StatefulWidget {
  final Boards boards;
  const TaskInfo({super.key, required this.boards});

  @override
  State<TaskInfo> createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  final GlobalKey menuKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    final cardProvider = Provider.of<CardProvider>(context);
    final listBoard = context.watch<BoardProvider>().listBorad;
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
                            child: GestureDetector(
                              onTapDown: (details) async {
                              final result = await showAppMenu(
                                context: context,
                                position: details.globalPosition,
                                items: {
                                  'add_board': 'Thêm bảng',
                                  'delete_board': 'Xóa bảng',
                                  'menu_board': 'Menu',
                                },
                              );

                              switch (result) {
                                case 'add_board':
                                  final TextEditingController titleCtrl = TextEditingController();
                                  DialogAdd.show(context: context,Ctrl: titleCtrl, onPressed: () async {
                                    final title = titleCtrl.text.trim();
                                    await boardProvider.addListBoard(widget.boards.id.toString(), title, context);
                                  }, title: 'Tiêu đề',hintText: 'Nhập tiêu đề');
                                break;

                                case 'delete_board':
                                  if (!mounted) return;
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                                      ),
                                      builder: (context) {
                                        return ListSelectSheet(
                                          title: 'Chọn danh sách cần xóa',
                                          list: listBoard ?? [],
                                          onSelect: (l) async {
                                            ConfirmLogoutDialog.show(context: context, title: 'Xác nhận xóa', message: 'Bạn có chắc chắn muốn xóa bảng "${l.title.toString()}" này không!', onPressed: () async {
                                              if ( await cardProvider.deleteList(l.id.toString(), context) == true ) {
                                                boardProvider.getListbyBoardid(widget.boards.id.toString());
                                              };
                                            });
                                          },
                                        );
                                      },
                                    );
                                break;

                                case 'menu_board':
                                  await boardProvider.getInfoBoard(widget.boards.id.toString());
                                  if (!mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MenuBoard(board: widget.boards),
                                    ),
                                  );
                                break;
                              }
},
                              child: Icon(Icons.more_horiz_rounded)
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          BoardContent(board_id: widget.boards.id.toString(),),
                        ],
                      )
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