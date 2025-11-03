import 'package:flutter/material.dart';
import 'package:ktodo_application/components/button-custom.dart';
import 'package:ktodo_application/components/input-custom.dart';
import 'package:ktodo_application/providers/board-provider.dart';
import 'package:ktodo_application/screens/signup-screens.dart';
import 'package:provider/provider.dart';
import '../providers/auth-provider.dart';
import 'home-screens.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  void login() async {
    if (emailCtrl.text == '' || passCtrl.text == '')
    {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thất bại: Email hoặc Password không được để trống!"), backgroundColor: Colors.red,),
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      await auth.login(emailCtrl.text.trim(), passCtrl.text.trim());
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
      final board = Provider.of<BoardProvider>(context, listen: false);
      board.getBoards();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thành công"), backgroundColor: Colors.green,),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng nhập thất bại: Email hoặc Password không chính xác!"), backgroundColor: Colors.red,),
      );
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
                      const SizedBox(height: 60),
                      const Text(
                        "Welcome to KToDo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Đăng nhập",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
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
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      CustomInputField(hintText: 'Password', controller: passCtrl, obscureText: true,),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignupScreen()),
                            );
                          },
                          child: Text('Đăng ký tài khoản', style: TextStyle( fontSize: 13, color: Colors.blue),)
                        )
                      ],),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 30),
                        child: SizedBox(
                          height: 50,
                          child: CustomButton(text: 'Đăng nhập', onPressed: login),
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