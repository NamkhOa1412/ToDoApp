import 'package:flutter/material.dart';
import 'package:ktodo_application/components/app-menu.dart';
import 'package:ktodo_application/components/dialog-custom.dart';
import 'package:ktodo_application/model/card-detail.dart';
import 'package:ktodo_application/providers/card-provider.dart';
import 'package:provider/provider.dart';

class CheckListUI extends StatefulWidget {
  final List<Checklists> checklists;
  final String cardId;
  const CheckListUI({super.key, required this.checklists, required this.cardId});

  @override
  State<CheckListUI> createState() => _CheckListUIState();
}

class _CheckListUIState extends State<CheckListUI> {
  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<CardProvider>(context);
    Map<String, bool> loadingMap = {};

    if (widget.checklists.isEmpty) {
      return const Text(
        'Chưa có danh sách công việc',
        style: TextStyle(color: Colors.white70),
      );
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.checklists.map((cl) {
            final totalTasks = cl.items!.length;
            final doneTasks = cl.items!.where((t) => t.isDone!).length;
            final progress = totalTasks > 0 ? doneTasks / totalTasks : 0.0;
            final isExpanded = cardProvider.expandedStatus[cl.id!] ?? true;

            return GestureDetector(
              onLongPressStart: (details) async {
                final result = await showAppMenu(
                  context: context,
                  position: details.globalPosition,
                  items: {
                    'delete': 'Xóa danh sách',
                    'rename': 'Đổi tên',
                    'update': cardProvider.deletingStatus[cl.id!] == true ? 'Tắt xóa Item' : 'Bật xóa Item',
                  },
                );

                switch (result) {
                  case 'delete':
                    ConfirmLogoutDialog.show(context: context, title: 'Xác nhận xóa', message: 'Bạn có chắc chắn muốn xóa danh sách này !', onPressed: () async {
                      await cardProvider.deleteCheckList(widget.cardId, cl.id.toString(), context);
                    });
                    
                    break;

                  case 'rename':
                    final TextEditingController titleCtrl = TextEditingController();
                    DialogAdd.show(context: context,Ctrl: titleCtrl, 
                      onPressed: () async {
                      final title = titleCtrl.text.trim();
                      await cardProvider.updateChecklistTitle(widget.cardId, cl.id.toString(), title, context);
                    }, title: 'Tên Danh sách',hintText: 'Nhập tên danh sách');
                    break;

                  case 'update':
                    final isDeleting = cardProvider.deletingStatus[cl.id!] == true;
                    cardProvider.toggleDeleting(cl.id!, !isDeleting);
                    break;
                }
              },

              child: Padding(
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
                              cardProvider.changeStatusExpanded(cl.id!);
                            },
                            child: Icon(
                              isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: Colors.white70,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // const Icon(Icons.more_vert, color: Colors.white70, size: 20),
                        ],
                      ),
                      const SizedBox(height: 8),
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
                      if (isExpanded) ...[
                        const SizedBox(height: 12),
                        Column(
                          children: cl.items!.map((item) {
                            final isLoading = loadingMap[item.id] == true;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  // Checkbox(
                                  //   value: item.isDone,
                                  //   onChanged: (val)  async{
                                  //     if (val == null) return;
                                  //     await cardProvider.updateStatusCheckListItem(widget.cardId ,item.id.toString(), val);
                                  //   },
                                  //   activeColor: const Color(0xFF26A69A),
                                  // ),
                                  isLoading ? 
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF26A69A),
                                      ),
                                    ),
                                  )
                                  : Checkbox(
                                    value: item.isDone,
                                    onChanged: (val) async {
                                      if (val == null) return;
              
                                      setState(() {
                                        loadingMap[item.id!] = true; 
                                      });
              
                                      await cardProvider.updateStatusCheckListItem(
                                        widget.cardId,
                                        item.id.toString(),
                                        val,
                                      );
              
                                      setState(() {
                                        loadingMap[item.id!] = false; 
                                      });
                                    },
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
                                  ),
                                  if (cardProvider.deletingStatus[cl.id!] == true)
                                    GestureDetector(
                                      onTap: () async {
                                        ConfirmLogoutDialog.show(context: context, title: 'Xác nhận xóa', message: 'Bạn có chắc chắn muốn xóa item này !', onPressed: () async {
                                          await cardProvider.deleteChecklistItem(widget.cardId, item.id.toString(), context);
                                        });
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(Icons.close, color: Colors.redAccent),
                                      ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        // const Text(
                        //   'Thêm mục...',
                        //   style: TextStyle(
                        //     color: Colors.white70,
                        //     fontStyle: FontStyle.italic,
                        //   ),
                        // ),
                        cardProvider.isAdding[cl.id!] == true
                      ? Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: cardProvider.controllers[cl.id!],
                                autofocus: true,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final text = cardProvider.getText(cl.id!);
                                if (text.isEmpty) return;
              
                                await cardProvider.addCheckListItem(
                                  cl.id!, text , context, widget.cardId
                                );
              
                                cardProvider.clearText(cl.id!);
                                cardProvider.toggleAdding(cl.id!, false);
                              },
                              child: const Icon(Icons.check, color: Color(0xFF26A69A)),
                            ),
                            GestureDetector(
                              onTap: () {
                                cardProvider.clearText(cl.id!);
                                cardProvider.toggleAdding(cl.id!, false);
                              },
                              child: const Icon(Icons.close, color: Colors.redAccent),
                            ),
                          ],
                        )
                      : GestureDetector(
                          onTap: () => cardProvider.toggleAdding(cl.id!, true),
                          child: const Text(
                            'Thêm mục...',
                            style: TextStyle(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}