sealed class ApiException implements Exception {
  const ApiException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkException extends ApiException {
  const NetworkException([super.message = 'No internet connection']);
}

class ServerException extends ApiException {
  const ServerException(this.statusCode, [super.message = 'Server error']);
  final int statusCode;
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

class TimeoutException extends ApiException {
  const TimeoutException([super.message = 'Request timed out']);
}
