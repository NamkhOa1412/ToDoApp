import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth-provider.dart';
import 'home-screens.dart';
import 'login-screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.loadSession();

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    if (auth.isLoggedIn) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xFF26A69A),)),
    );
  }
}
