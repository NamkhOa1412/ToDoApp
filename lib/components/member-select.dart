import 'package:flutter/material.dart';
import 'package:ktodo_application/model/board-users.dart';

class MemberSelectSheet extends StatelessWidget {
  final List<BoardUsers> users;
  final Function(BoardUsers) onSelect;

  const MemberSelectSheet({
    super.key,
    required this.users,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chọn thành viên",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final u = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(u.fullName?.substring(0,1).toUpperCase() ?? "?", style: TextStyle(color: Color(0xFF26A69A)),),
                  ),
                  title: Text(u.fullName ?? "Không tên", style: TextStyle(color: Color(0xFF26A69A), fontWeight: FontWeight.bold),),
                  subtitle: Text("@${u.username}"),
                  onTap: () => onSelect(u),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
