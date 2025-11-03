class Boards {
  String? id;
  String? title;
  String? description;
  bool? isPrivate;
  String? ownerId;
  String? createdAt;
  String? updatedAt;
  String? role;
  int? memberCount;

  Boards(
      {this.id,
      this.title,
      this.description,
      this.isPrivate,
      this.ownerId,
      this.createdAt,
      this.updatedAt,
      this.role,
      this.memberCount});

  Boards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    isPrivate = json['is_private'];
    ownerId = json['owner_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    role = json['role'];
    memberCount = json['member_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['is_private'] = this.isPrivate;
    data['owner_id'] = this.ownerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['role'] = this.role;
    data['member_count'] = this.memberCount;
    return data;
  }
}
