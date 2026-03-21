import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<User> login({required String email, required String password}) {
    return _remoteDataSource.login(
      LoginRequest(email: email, password: password),
    );
  }

  @override
  Future<void> logout() async {
    // Clear stored tokens / session data
  }
}
