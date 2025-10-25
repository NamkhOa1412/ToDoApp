import 'package:flutter/material.dart';
import 'package:ktodo_application/components/button-custom.dart';
import 'package:ktodo_application/components/input-custom.dart';
import 'package:provider/provider.dart';
import '../providers/auth-provider.dart';
import 'home-screens.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmpassCtrl = TextEditingController();

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
                                "Đăng ký tài khoản",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      CustomInputField(hintText: 'Email', controller: emailCtrl,),

                      const SizedBox(height: 20),

                      const Text(
                        "Tên người dùng",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      CustomInputField(hintText: 'Tên người dùng', controller: usernameCtrl, obscureText: true,),

                      const SizedBox(height: 20),

                      const Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      CustomInputField(hintText: 'Password', controller: passCtrl, obscureText: true,),

                      const SizedBox(height: 20),

                      const Text(
                        "Xác nhận Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      CustomInputField(hintText: 'Xác nhận Password', controller: passCtrl, obscureText: true,),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 30),
                        child: SizedBox(
                          height: 50,
                          child: CustomButton(text: 'Đăng ký', onPressed: () {}),
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