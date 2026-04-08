import 'package:flutter_starter/features/auth/domain/entities/user.dart';
import 'package:flutter_starter/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository mockRepository;
  late LoginUseCase loginUseCase;

  setUp(() {
    mockRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockRepository);
  });

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testUser = User(id: '1', email: testEmail, name: 'Test User');

  group('LoginUseCase', () {
    test('should return User when login succeeds', () async {
      when(
        () => mockRepository.login(
          email: testEmail,
          password: testPassword,
        ),
      ).thenAnswer((_) async => testUser);

      final result = await loginUseCase(
        email: testEmail,
        password: testPassword,
      );

      expect(result, equals(testUser));
      verify(
        () => mockRepository.login(
          email: testEmail,
          password: testPassword,
        ),
      ).called(1);
    });

    test('should propagate exception when login fails', () async {
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('Invalid credentials'));

      expect(
        () => loginUseCase(email: testEmail, password: testPassword),
        throwsA(isA<Exception>()),
      );
    });
  });
}
