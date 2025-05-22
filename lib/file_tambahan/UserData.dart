class UserData {
  final int id;
  final int userid;
  final String name;
  final String email;
  final String ketua;

  UserData({
    required this.id,
    required this.userid,
    required this.name,
    required this.email,
    required this.ketua,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      userid: json['user_id'] ?? 0, // Sesuaikan dengan tipe datanya
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      ketua: json['ketua'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userid': userid,
      'name': name,
      'email': email,
      'ketua': ketua,
    };
  }
}
