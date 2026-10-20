class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException(statusCode: $statusCode, message: $message)';
}

class AuthException implements Exception {
  final String message;

  AuthException({required this.message});

  @override
  String toString() => 'AuthException(message: $message)';
}

class UserNotRegisteredException implements Exception {
  final String message;

  UserNotRegisteredException({this.message = 'User is not registered'});

  @override
  String toString() => 'UserNotRegisteredException(message: $message)';
}
