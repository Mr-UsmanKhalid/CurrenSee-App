class UserModel {
  final int? id;
  final String name;
  final String email;
  final String passwordHash;
  final String? profilePicturePath;
  final String defaultCurrency;
  final DateTime createdAt;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    this.profilePicturePath,
    this.defaultCurrency = 'USD',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password_hash': passwordHash,
      'profile_picture_path': profilePicturePath,
      'default_currency': defaultCurrency,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      email: map['email'] as String,
      passwordHash: map['password_hash'] as String,
      profilePicturePath: map['profile_picture_path'] as String?,
      defaultCurrency: map['default_currency'] as String? ?? 'USD',
      createdAt: DateTime.tryParse(map['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  /// NEW: builds a UserModel from the backend's /api/auth/* and
  /// /api/users/me responses, which never include password_hash.
  factory UserModel.fromApiJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      email: json['email'] as String,
      passwordHash: '', // never sent by the API, never needed client-side
      profilePicturePath:
          (json['profilePicturePath'] ?? json['profile_picture_path']) as String?,
      defaultCurrency:
          (json['defaultCurrency'] ?? json['default_currency']) as String? ?? 'USD',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? profilePicturePath,
    String? defaultCurrency,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      createdAt: createdAt,
    );
  }
}