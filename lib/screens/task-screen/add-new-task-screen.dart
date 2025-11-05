import 'package:flutter/material.dart';
import 'package:ktodo_application/components/button-custom.dart';
import 'package:ktodo_application/components/input-custom.dart';
import 'package:ktodo_application/providers/board-provider.dart';
import 'package:provider/provider.dart';

class AddNewTaskScreen extends StatelessWidget {
  const AddNewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleCtrl = TextEditingController();
    final desCtrl = TextEditingController();

    void addBoard() async{
      if (titleCtrl.text == '')
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tiêu đề không được để trống"), backgroundColor: Colors.red,),
        );
        return;
      } 
      else {
        final boardProvider = Provider.of<BoardProvider>(context, listen: false);
        try {
          await boardProvider.addBoard(titleCtrl.text.trim(), desCtrl.text.trim(), context);
        } catch (e) {
          print("lỗi $e");
        }
      }
    }
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
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 9,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tạo bảng mới",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "* Tiêu đề",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16, color: Colors.red),
                      ),
                      const SizedBox(height: 10),
                      CustomInputField(hintText: 'Tiêu đề',controller: titleCtrl,),

                      const SizedBox(height: 10),

                      const Text(
                        "Mô tả",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      
                      CustomInputField(hintText: "Nhập mô tả", minLines: 4, maxLines: 5, controller: desCtrl,),
                      SizedBox(height: 10),

                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 30),
                        child: SizedBox(
                          height: 50,
                          child: 
                          // _isLoading
                          //     ? const Center(child: CircularProgressIndicator(color: Color(0xFF26A69A),))
                          //     :
                               CustomButton(text: 'Tạo bảng mới', onPressed: addBoard),
                        ),
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