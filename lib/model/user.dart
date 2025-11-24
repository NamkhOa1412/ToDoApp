class User {
  String? id;
  String? email;
  String? phone;
  String? accessToken;
  String? refreshToken;
  int ? expiresAt;
  String? error;

  User({this.id, this.email, this.phone, this.accessToken, this.error});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'accessToken': accessToken,
      'refresh_token': refreshToken,
      'expiresAt': expiresAt,
      'error': error,
    };
  }
}