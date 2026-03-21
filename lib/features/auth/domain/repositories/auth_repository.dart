import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<void> logout();
}
