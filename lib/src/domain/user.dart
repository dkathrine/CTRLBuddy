class User {
  final String id;
  final String name;
  final String status;
  final String bio;
  final String profilePicture;
  final List<String> threads;
  final List<String> interests;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    this.status = "",
    this.bio = "",
    this.profilePicture = "",
    List<String>? threads,
    List<String>? interests,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : threads = threads ?? [],
       interests = interests ?? [],
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'name': name,
    'status': status,
    'bio': bio,
    'profilePicture': profilePicture,
    'threads': threads,
    'interests': interests,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory User.fromMap(String id, Map<String, dynamic> map) {
    return User(
      id: id,
      name: map['name'],
      status: map['status'] ?? "",
      bio: map['bio'] ?? "",
      profilePicture: map['profilePicture'] ?? "",
      threads: List<String>.from(map['threads'] ?? []),
      interests: List<String>.from(map['interests'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
