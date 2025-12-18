import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ktodo_application/components/check-list.dart';
import 'package:ktodo_application/components/comment.dart';
import 'package:ktodo_application/components/dialog-custom.dart';
import 'package:ktodo_application/components/input-custom.dart';
import 'package:ktodo_application/components/member-select.dart';
import 'package:ktodo_application/components/timer-task.dart';
import 'package:ktodo_application/model/card.dart';
import 'package:ktodo_application/providers/card-provider.dart';
import 'package:ktodo_application/utils/string-utils.dart';
import 'package:provider/provider.dart';

class CardInfo extends StatefulWidget {
  final CardModel card;
   CardInfo({super.key, required this.card});

  @override
  State<CardInfo> createState() => _CardInfoState();
}

class _CardInfoState extends State<CardInfo> {
  // @override
  // void initState() {
  //   super.initState();
  //   final cardProvider = Provider.of<CardProvider>(context, listen: false);
  //   cardProvider.getCardDetail(widget.card.id.toString());
  // }

  Timer? _timer;
  TextEditingController cmtCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  bool _isDescriptionInitialized = false;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CardProvider>().getCardDetail(widget.card.id);
    });

    _timer = Timer.periodic( Duration(seconds: 10), (timer) {
      context.read<CardProvider>().getCardDetail(widget.card.id);
    });

    descriptionCtrl.addListener(() {
      context.read<CardProvider>().checkDescriptionChanged(descriptionCtrl.text);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    descriptionCtrl.dispose();
    cmtCtrl.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final cardDetail = context.watch<CardProvider>().cardDetail;
    final cardProvider = Provider.of<CardProvider>(context);

    if (cardDetail == null) {
      return  Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF26A69A)),
        ),
      );
    }

    if (!_isDescriptionInitialized && (cardDetail.description?.isNotEmpty ?? false)) {
      descriptionCtrl.text = cardDetail.description!;
      _isDescriptionInitialized = true;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    icon:  Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                   SizedBox(width: 8),
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
                padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          'Nội dung',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        cardProvider.isDescriptionChanged ? GestureDetector(
                          onTap: () async {
                            await cardProvider.updateDesCard(
                              widget.card.id.toString(),
                              descriptionCtrl.text,
                            );
                          },
                          child: Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 32,
                          ),
                        ) : SizedBox(),
                      ],
                    ),
                     SizedBox(height: 6),
                    CustomInputField(hintText: 'Thêm nội dung thẻ',maxLines: 8, minLines: 6, controller: descriptionCtrl,),
                     SizedBox(height: 16),
                     Divider(),

                     SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          'Thời gian',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                     SizedBox(height: 6),
                    InkWell(
                      onTap: () {
                        if (!mounted) return;
                          showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                            ),
                            builder: (context) {
                              return TimerTask(cardId: cardDetail.id.toString(),  dueAt: cardDetail.dueAt.toString(),);
                            },
                          );
                      },
                      child: Container(
                        color: Color(0xFF26A69A),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            Icon(Icons.timer, color: Colors.white,),
                            SizedBox(width: 6),
                            Text(
                              cardDetail.dueAt == null || cardDetail.dueAt == '' ? 'Thời gian kết thúc' : StringUtils.formatDate(cardDetail.dueAt.toString()),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                     SizedBox(height: 16),
                     Divider(),

                     SizedBox(height: 16),
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
                            onTap: () async {
                              final boardUsers = await cardProvider.getBoardUsers(cardDetail.boardId.toString());
                              if (!mounted) return;
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                                ),
                                builder: (context) {
                                  return MemberSelectSheet(
                                    users: boardUsers ?? [],
                                    onSelect: (u) async {
                                      await cardProvider.addUsertoCard(widget.card.id, u.id.toString(), context);
                                    },
                                  );
                                },
                              );
                            },
                            child: Icon(Icons.add, color: Color(0xFF26A69A),)
                          )
                        ),
                      ],
                    ),
                     SizedBox(height: 6),
                    cardDetail.members != null && cardDetail.members!.isNotEmpty ? Container(
                      width: double.infinity,
                      padding:  EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFF26A69A),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics:  NeverScrollableScrollPhysics(),
                        itemCount: cardDetail.members!.length,
                        itemBuilder: (context, index) {
                          final fullname_list = cardDetail.members![index].fullName;
                          final username_list = "@${cardDetail.members![index].username}";
                          return Padding(
                            padding:  EdgeInsets.symmetric(vertical: 4),
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
                    ) : SizedBox(),
                     SizedBox(height: 16),
                     Divider(),

                     SizedBox(height: 16),
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
                            onTap: () {
                              final TextEditingController titleCtrl = TextEditingController();
                              DialogAdd.show(context: context,Ctrl: titleCtrl, 
                                onPressed: () async {
                                final title = titleCtrl.text.trim();
                                await cardProvider.addCheckList(widget.card.id.toString(), title, context);
                              }, title: 'Tên Task',hintText: 'Nhập tên task');
                            },
                            child: Icon(Icons.add, color: Color(0xFF26A69A))
                          )
                        ),
                      ],
                    ),
                     SizedBox(height: 6),
                    CheckListUI(checklists: cardDetail.checklists!, cardId: cardDetail.id.toString(),),

                     SizedBox(height: 16),
                     Divider(),

                     SizedBox(height: 16),
                     Text(
                      'Hoạt động',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                     SizedBox(height: 6),
                    CommentUI(comment: cardDetail.comments!)
                  ],
                ),
              ),
            ),


            SafeArea(
              top: false,
              child: Container(
                padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomInputField(hintText: 'Thêm nhận xét', controller: cmtCtrl,),
                    ),
                     SizedBox(width: 8),
                    IconButton(
                      icon:  Icon(Icons.send, color: Color(0xFF26A69A)),
                      onPressed: () async {
                        if (cmtCtrl.text.isNotEmpty) {
                          final is_true = await cardProvider.addComment(cardDetail.id.toString(), cmtCtrl.text);
                          if (is_true == true) {
                            cmtCtrl.clear(); 
                            FocusScope.of(context).unfocus();
                          } 
                        }
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

}