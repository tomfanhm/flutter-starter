import '../../../../core/storage/token_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._tokenStorage);

  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<User> login({required String email, required String password}) async {
    final model = await _remoteDataSource.login(
      LoginRequest(email: email, password: password),
    );
    final token = model.token;
    if (token != null) {
      await _tokenStorage.writeToken(token);
    }
    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }
}
