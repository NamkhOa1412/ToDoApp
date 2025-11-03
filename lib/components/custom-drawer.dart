import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:ktodo_application/components/dialog-custom.dart';
import 'package:ktodo_application/model/info-user.dart';
import 'package:ktodo_application/providers/user-provider.dart';
import 'package:ktodo_application/screens/changepass-screens.dart';
import 'package:ktodo_application/screens/help.dart';
import 'package:provider/provider.dart';
import '../providers/auth-provider.dart';
import '../screens/login-screens.dart';

class AppDrawer extends StatelessWidget {
  final AdvancedDrawerController controller;

  const AppDrawer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        color: Colors.blueGrey.shade800,
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(bottom: 32.0),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                // child: const Icon(Icons.person, size: 60, color: Colors.white),
                child: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                  ? Image.network(
                      user.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, size: 60, color: Colors.white);
                      },
                    )
                  : const Icon(Icons.person, size: 60, color: Colors.white),
              ),
              Text(user!.fullName ?? '', style: TextStyle(color: Color(0xFF26A69A), fontSize: 16, fontWeight: FontWeight.bold),),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Trang chủ'),
                onTap: () {
                  controller.hideDrawer();
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.person),
              //   title: const Text('Thông tin cá nhân'),
              //   onTap: () {
              //     controller.hideDrawer();
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Đổi mật khẩu'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ChangePassScreens()),
                  );
                  controller.hideDrawer();
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Liên hệ hỗ trợ'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HelpScreens()),
                  );
                  controller.hideDrawer();
                },
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Đăng xuất'),
                onTap: () {
                  ConfirmLogoutDialog.show(context: context, title: 'Xác nhận đăng xuất', message: 'Bạn có muốn đăng xuất tài khoản ra khỏi thiết bị!', onPressed: () {
                    auth.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}