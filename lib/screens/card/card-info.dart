import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ktodo_application/components/check-list.dart';
import 'package:ktodo_application/components/comment.dart';
import 'package:ktodo_application/components/dialog-custom.dart';
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
  // @override
  // void initState() {
  //   super.initState();
  //   final cardProvider = Provider.of<CardProvider>(context, listen: false);
  //   cardProvider.getCardDetail(widget.card.id.toString());
  // }

  Timer? _timer;
  TextEditingController cmtCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CardProvider>().getCardDetail(widget.card.id);
    });

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      context.read<CardProvider>().getCardDetail(widget.card.id);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final cardDetail = context.watch<CardProvider>().cardDetail;
    final cardProvider = Provider.of<CardProvider>(context);

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
                    const SizedBox(height: 6),
                    CheckListUI(checklists: cardDetail.checklists!, cardId: cardDetail.id.toString(),),

                    const SizedBox(height: 16),
                    const Divider(),

                    const SizedBox(height: 16),
                    const Text(
                      'Hoạt động',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    CommentUI(comment: cardDetail.comments!)
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
                      child: CustomInputField(hintText: 'Thêm nhận xét', controller: cmtCtrl,),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF26A69A)),
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