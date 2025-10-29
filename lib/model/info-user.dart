class infoUser {
  String? id;
  String? username;
  String? fullName;
  String? avatarUrl;

  infoUser(
      {this.id,
      this.username,
      this.fullName,
      this.avatarUrl});

  infoUser.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    username = json['username']?.toString() ?? '';
    fullName = json['full_name']?.toString() ?? '';
    avatarUrl = json['avatar_url']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['full_name'] = this.fullName;
    data['avatar_url'] = this.avatarUrl;
    return data;
  }
}