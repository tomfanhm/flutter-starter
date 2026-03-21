import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_starter/core/network/auth_interceptor.dart';
import 'package:flutter_starter/core/network/logging_interceptor.dart';
import 'package:flutter_starter/core/storage/token_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('AuthInterceptor', () {
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
    });

    test('attaches bearer token when storage has token', () async {
      const testToken = 'test-jwt-token';
      when(() => mockStorage.read(key: 'auth_token'))
          .thenAnswer((_) async => testToken);

      final tokenStorage = TokenStorage(storage: mockStorage);
      final interceptor = AuthInterceptor(tokenStorage: tokenStorage);
      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(
        options,
        RequestInterceptorHandler(),
      );

      expect(options.headers['Authorization'], equals('Bearer $testToken'));
    });

    test('does not attach header when storage returns null', () async {
      when(() => mockStorage.read(key: 'auth_token'))
          .thenAnswer((_) async => null);

      final tokenStorage = TokenStorage(storage: mockStorage);
      final interceptor = AuthInterceptor(tokenStorage: tokenStorage);
      final options = RequestOptions(path: '/test');

      await interceptor.onRequest(
        options,
        RequestInterceptorHandler(),
      );

      expect(options.headers.containsKey('Authorization'), isFalse);
    });
  });

  group('TokenStorage', () {
    late MockFlutterSecureStorage mockStorage;
    late TokenStorage tokenStorage;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      tokenStorage = TokenStorage(storage: mockStorage);
    });

    test('writes token to secure storage', () async {
      when(() => mockStorage.write(key: 'auth_token', value: 'abc'))
          .thenAnswer((_) async {});

      await tokenStorage.writeToken('abc');

      verify(() => mockStorage.write(key: 'auth_token', value: 'abc'))
          .called(1);
    });

    test('deletes token from secure storage', () async {
      when(() => mockStorage.delete(key: 'auth_token'))
          .thenAnswer((_) async {});

      await tokenStorage.deleteToken();

      verify(() => mockStorage.delete(key: 'auth_token')).called(1);
    });
  });

  group('LoggingInterceptor', () {
    test('can be instantiated', () {
      final interceptor = LoggingInterceptor();
      expect(interceptor, isA<Interceptor>());
    });
  });
}
