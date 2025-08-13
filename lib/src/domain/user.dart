import 'package:uuid/uuid.dart';

class User {
  final String id;
  final String name;
  final String status;
  final String bio;
  final String profilePicture;
  List<String> threads;
  List<String> interests;

  User({
    required this.name,
    this.status = "",
    this.bio = "",
    this.profilePicture = "",
    List<String>? threads,
    List<String>? interests,
  }) : threads = threads ?? [],
       interests = interests ?? [],
       id = Uuid().v4();
}
