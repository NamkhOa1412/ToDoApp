class BoardInfo {
  final String username;
  final String fullName;

  BoardInfo({
    required this.username,
    required this.fullName,
  });

  factory BoardInfo.fromJson(Map<String, dynamic> json) {
    return BoardInfo(
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }
}

class BoardUser {
  final String role;
  final String username;
  final String fullName;

  BoardUser({
    required this.role,
    required this.username,
    required this.fullName,
  });

  factory BoardUser.fromJson(Map<String, dynamic> json) {
    return BoardUser(
      role: json['role'] ?? '',
      username: json['username'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }
}

class BoardResponse {
  final BoardInfo info;
  final List<BoardUser> users;

  BoardResponse({
    required this.info,
    required this.users,
  });

  factory BoardResponse.fromJson(Map<String, dynamic> json) {
    return BoardResponse(
      info: BoardInfo.fromJson(json['info']),
      users: (json['users'] as List<dynamic>)
          .map((u) => BoardUser.fromJson(u))
          .toList(),
    );
  }
}