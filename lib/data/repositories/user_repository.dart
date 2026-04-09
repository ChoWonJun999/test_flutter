import 'package:app/domain/models/user.dart';
import 'package:app/utils/result.dart';

class UserRepository {
  Future<Result<User>> getUser() async {
    // Sample data for local UI flow.
    return Result.ok(const User(name: 'OD Walker', picture: 'https://example.com/profile.png'));
  }
}
