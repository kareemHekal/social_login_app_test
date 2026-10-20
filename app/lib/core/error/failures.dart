import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.statusCode});
}

class UserNotRegisteredFailure extends Failure {
  const UserNotRegisteredFailure({String message = 'User not registered on backend'})
      : super(message, statusCode: 404);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Check your internet connection'})
      : super(message);
}
