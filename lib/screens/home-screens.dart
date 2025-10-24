import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth-provider.dart';
import 'login-screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Xin chào ${auth.user?.email ?? ''}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text("Đăng nhập thành công!")),
    );
  }
}
