class UserModel {
  final int userId;
  final String username;
  final String email;
  final String fullName;
  final String role;
  final String? nim;
  final String? programStudi;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.fullName,
    required this.role,
    this.nim,
    this.programStudi,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'] is int ? json['user_id'] : int.parse(json['user_id'].toString()),
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'] ?? '',
      role: json['role'] ?? 'user',
      nim: json['nim'],
      programStudi: json['program_studi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'full_name': fullName,
      'role': role,
      'nim': nim,
      'program_studi': programStudi,
    };
  }
}
