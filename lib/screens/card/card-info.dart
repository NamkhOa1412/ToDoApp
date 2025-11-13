import 'package:flutter/material.dart';
import 'package:ktodo_application/components/input-custom.dart';
import 'package:ktodo_application/model/card-detail.dart';
import 'package:ktodo_application/model/card.dart';
import 'package:ktodo_application/providers/card-provider.dart';
import 'package:provider/provider.dart';

class CardInfo extends StatefulWidget {
  final CardModel card;
  const CardInfo({super.key, required this.card});

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  @override
  void initState() {
    super.initState();
    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    cardProvider.getCardDetail(widget.card.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final cardDetail = context.watch<CardProvider>().cardDetail;

    if (cardDetail == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF26A69A)),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      cardDetail!.title.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nội dung',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    CustomInputField(hintText: 'Thêm nội dung thẻ',maxLines: 8, minLines: 6,),
                    const SizedBox(height: 16),
                    const Divider(),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child:Text(
                            'Thành viên',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Icon(Icons.add, color: Color(0xFF26A69A),)
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF26A69A),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cardDetail.members!.length,
                        itemBuilder: (context, index) {
                          final fullname_list = cardDetail.members![index].fullName;
                          final username_list = "@${cardDetail.members![index].username}";
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(fullname_list.toString(), style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),),
                                    Text(username_list, style: TextStyle(
                                      color: Colors.white
                                    ),),
                                  ],
                                )),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child:Text(
                            'Danh sách công việc',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            child: Icon(Icons.add, color: Color(0xFF26A69A))
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    buildChecklistList(cardDetail.checklists!),

                    const SizedBox(height: 16),
                    const Divider(),

                    const SizedBox(height: 16),
                    const Text(
                      'Hoạt động',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    _comment(cardDetail.comments!)
                  ],
                ),
              ),
            ),


            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomInputField(hintText: 'Thêm nhận xét'),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF26A69A)),
                      onPressed: () {
                        // if (_commentController.text.isNotEmpty) {
                        //   print('Comment: ${_commentController.text}');
                        //   _commentController.clear();
                        // }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChecklistList(List<Checklists> checklists) {
    if (checklists.isEmpty) {
      return const Text(
        'Chưa có danh sách công việc',
        style: TextStyle(color: Colors.white70),
      );
    }

    final Map<String, bool> expandedStatus = {
      for (var cl in checklists) cl.id!: true,
    };

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: checklists.map((cl) {
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


  Widget _comment(List<Comments> comments) {
    if (comments.isEmpty) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comments.map((comment) {
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
                    // Username
                    Text(
                      comment.user?.username ?? 'Unknown',
                      style: const TextStyle(
                        color: Color(0xFF26A69A),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Nội dung comment
                    Text(
                      comment.content ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Thời gian comment
                    Text(
                      comment.createdAt ?? '',
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