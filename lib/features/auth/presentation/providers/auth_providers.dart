import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/storage/token_storage.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) => ApiClient();

@Riverpod(keepAlive: true)
TokenStorage tokenStorage(TokenStorageRef ref) => TokenStorage();

@riverpod
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) =>
    AuthRemoteDataSource(ref.watch(apiClientProvider));

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepositoryImpl(
      ref.watch(authRemoteDataSourceProvider),
      ref.watch(tokenStorageProvider),
    );

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) =>
    LoginUseCase(ref.watch(authRepositoryProvider));

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AsyncValue<User?> build() => const AsyncData(null);

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(loginUseCaseProvider);
      return useCase(email: email, password: password);
    });
  }

  Future<void> logout() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AsyncData(null);
  }

  String? get errorMessage {
    if (!state.hasError) return null;
    final error = state.error;
    return switch (error) {
      NetworkException() =>
        'No internet connection. Please check your network.',
      TimeoutException() => 'Request timed out. Please try again.',
      UnauthorizedException() => 'Invalid email or password.',
      ServerException() => 'Something went wrong. Please try again later.',
      _ => 'An unexpected error occurred.',
    };
  }
}
