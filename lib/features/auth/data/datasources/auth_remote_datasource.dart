import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../models/login_request.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<User> login(LoginRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
    );
    return User.fromJson(response.data!);
  }
}
