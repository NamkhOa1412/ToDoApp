class CardDetail {
  String? id;
  String? title;
  String? description;
  String? dueAt;
  String? createdAt;
  String? updatedAt;
  String? boardId;
  List<Members>? members;
  List<Checklists>? checklists;
  List<Comments>? comments;

  CardDetail(
      {this.id,
      this.title,
      this.description,
      this.dueAt,
      this.createdAt,
      this.updatedAt,
      this.members,
      this.boardId,
      this.checklists,
      this.comments});

  CardDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    dueAt = json['due_at'] ?? '';
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    boardId = json['board_id'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
    if (json['checklists'] != null) {
      checklists = <Checklists>[];
      json['checklists'].forEach((v) {
        checklists!.add(new Checklists.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['due_at'] = this.dueAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['board_id'] = this.boardId;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    if (this.checklists != null) {
      data['checklists'] = this.checklists!.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Members {
  String? id;
  String? username;
  String? fullName;
  dynamic? avatarUrl;

  Members({this.id, this.username, this.fullName, this.avatarUrl});

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullName = json['full_name'];
    avatarUrl = json['avatar_url'] ?? '';
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

class Checklists {
  String? id;
  String? title;
  int? position;
  List<Items>? items;

  Checklists({this.id, this.title, this.position, this.items});

  Checklists.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    position = json['position'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['position'] = this.position;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? content;
  bool? isDone;
  int? position;

  Items({this.id, this.content, this.isDone, this.position});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    isDone = json['is_done'];
    position = json['position'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['is_done'] = this.isDone;
    data['position'] = this.position;
    return data;
  }
}

class Comments {
  String? id;
  String? content;
  String? createdAt;
  dynamic? editedAt;
  User? user;

  Comments({this.id, this.content, this.createdAt, this.editedAt, this.user});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    createdAt = json['created_at'];
    editedAt = json['edited_at'] ?? '';
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['edited_at'] = this.editedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? username;
  dynamic? avatarUrl;

  User({this.id, this.username, this.avatarUrl});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    avatarUrl = json['avatar_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['avatar_url'] = this.avatarUrl;
    return data;
  }
}