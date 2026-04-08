import '../../../../core/network/api_client.dart';
import '../models/login_request.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<UserModel> login(LoginRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Empty response from /auth/login');
    }
    return UserModel.fromJson(data);
  }
}
