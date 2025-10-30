import 'package:flutter/material.dart';
import 'package:ktodo_application/components/button-custom.dart';
import 'package:ktodo_application/components/input-custom.dart';
import 'package:ktodo_application/providers/auth-provider.dart';
import 'package:provider/provider.dart';

class ChangePassScreens extends StatelessWidget {
  ChangePassScreens({super.key});
  final newPassCtrl = TextEditingController();

  void changePassword(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      await auth.changePassword(newPassCtrl.text.trim(), context);
    } catch (e) {
      print("lỗi $e");
    }
  }

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
                                "Đổi mật khẩu",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // const SizedBox(height: 40),

                      // const Text(
                      //   "Mật khẩu cũ",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold, fontSize: 16),
                      // ),
                      // const SizedBox(height: 10),

                      // CustomInputField(hintText: 'Password', obscureText: true,),

                      // const SizedBox(height: 20),

                      // const Text(
                      //   "Password",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.bold, fontSize: 16),
                      // ),
                      // const SizedBox(height: 10),

                      // CustomInputField(hintText: 'Password', obscureText: true,),

                      const SizedBox(height: 20),

                      const Text(
                        "Password mới",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      CustomInputField(hintText: 'Nhập Password mới', obscureText: true,controller: newPassCtrl,),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 30),
                        child: SizedBox(
                          height: 50,
                          child: CustomButton(text: 'Đổi mật khẩu', onPressed: () {
                            changePassword(context);
                          }),
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