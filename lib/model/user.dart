class User {
  String? id;
  String? email;
  String? phone;
  String? accessToken;
  String? error; // Dùng để lưu lỗi nếu login thất bại

  User({this.id, this.email, this.phone, this.accessToken, this.error});

  // Tạo User từ JSON trả về từ Supabase
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  // Chuyển User thành Map nếu cần lưu trữ hoặc debug
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'accessToken': accessToken,
      'error': error,
    };
  }
}