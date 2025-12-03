class BoardUsers{
  String? id;
  String? fullName;
  String? username;

  BoardUsers({this.id, this.fullName, this.username});

  BoardUsers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['username'] = this.username;
    return data;
  }
}