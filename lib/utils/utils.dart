import 'package:uuid/uuid.dart';
import 'package:bcrypt/bcrypt.dart';

String getNewUuid() => const Uuid().v4();

String hashPassword(String password) {
  return BCrypt.hashpw(password, BCrypt.gensalt());
}

bool verifyPassword(String password, String hash) {
  return BCrypt.checkpw(password, hash);
}
