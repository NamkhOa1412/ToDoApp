import 'package:flutter/material.dart';
import 'package:ktodo_application/components/button-custom.dart';
import 'package:ktodo_application/components/dialog-custom.dart';
import 'package:ktodo_application/model/board.dart';
import 'package:ktodo_application/providers/board-provider.dart';
import 'package:provider/provider.dart';

class MenuBoard extends StatefulWidget {
  final Boards board;
  MenuBoard({super.key, required this.board});

  @override
  State<MenuBoard> createState() => _MenuBoardState();
}

class _MenuBoardState extends State<MenuBoard> {
  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    final usernameCtrl = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                              'Thông tin bản',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(
                          Icons.info_outline
                        ),
                        Text(
                          "Được làm bởi",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          boardProvider.boardResponse.info.fullName.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF26A69A)),
                        ),
                        Text(
                          "@${boardProvider.boardResponse.info.username.toString()}",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline
                        ),
                        Text(
                          "Mô tả",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Text(
                      widget.board.description ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.person
                        ),
                        Text(
                          "Thành viên",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),

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
                        itemCount: boardProvider.boardResponse.users.length,
                        itemBuilder: (context, index) {
                          final fullname_list = boardProvider.boardResponse.users[index].fullName;
                          final username_list = "@${boardProvider.boardResponse.users[index].username}";
                          final role_list = boardProvider.boardResponse.users[index].role == 'owner' ? 'Quản trị viên' : 'Thành viên';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(flex: 7 , child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(fullname_list, style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),),
                                    Text(username_list, style: TextStyle(
                                      color: Colors.white
                                    ),),
                                  ],
                                )),
                                Expanded(flex: 3, child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(role_list, style: TextStyle(
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

                    widget.board.role != 'owner' ? Padding(
                      padding: EdgeInsets.only(bottom: 20, top: 10),
                      child: SizedBox(),
                    ) : Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      child: SizedBox(
                        height: 50,
                        child: CustomButton(text: 'Thêm thành viên', onPressed: () {
                          final TextEditingController usernameCtrl = TextEditingController();
                          DialogAdd.show(context: context,Ctrl: usernameCtrl, onPressed: () async {
                            final username = usernameCtrl.text.trim();
                            await boardProvider.addUser(widget.board.id.toString(), username, context);
                          }, title: 'Username',hintText: 'Nhập Username');
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
