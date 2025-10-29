import 'package:flutter/material.dart';
import 'package:ktodo_application/providers/user-provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../providers/auth-provider.dart';
import 'login-screens.dart';
import '../components/custom-drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

  void _toggleDrawer(String id) async {
    final user = Provider.of<UserProvider>(context, listen: false);
    await user.getUser(id);
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return AdvancedDrawer(
      controller: _advancedDrawerController,
      animationDuration: Duration(milliseconds: 300),
      animateChildDecoration: true,
      backdrop: Container(
        color: Colors.blueGrey.shade800,
      ),
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () { _toggleDrawer(auth.user!.id!); },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                print('thong bao');
              },
            ),
          ],
        ),
        body: const Center(child: Text("Đăng nhập thành công!")),
      ),
      drawer: AppDrawer(controller: _advancedDrawerController,),
    );
  }
}