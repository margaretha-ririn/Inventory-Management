// lib/models/user_model.dart
class User {
  final int userId;
  final String username;
  final String email;
  final String? fullName;
  final String role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  User({
    required this.userId,
    required this.username,
    required this.email,
    this.fullName,
    required this.role,
    required this.isActive,
    this.createdAt,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      fullName: json['full_name'],
      role: json['role'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
    );
  }

  // Convert User to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'full_name': fullName,
      'role': role,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  // Create copy with updated fields
  User copyWith({
    int? userId,
    String? username,
    String? email,
    String? fullName,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return User(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  // Check if user is admin
  bool get isAdmin => role.toLowerCase() == 'admin';

  // Check if user is regular user
  bool get isRegularUser => role.toLowerCase() == 'user';

  // Get display name (full name or username)
  String get displayName => fullName ?? username;

  // Check if user account is active
  bool get isAccountActive => isActive;

  @override
  String toString() {
    return 'User(userId: $userId, username: $username, email: $email, role: $role, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.userId == userId &&
        other.username == username &&
        other.email == email &&
        other.fullName == fullName &&
        other.role == role &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.lastLogin == lastLogin;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        username.hashCode ^
        email.hashCode ^
        fullName.hashCode ^
        role.hashCode ^
        isActive.hashCode ^
        createdAt.hashCode ^
        lastLogin.hashCode;
  }
}
