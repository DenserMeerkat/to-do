import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String passwordHash;

  User({
    required this.id,
    required this.username,
    required this.passwordHash,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'passwordHash': passwordHash,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        username: json['username'],
        passwordHash: json['passwordHash'],
      );
}
