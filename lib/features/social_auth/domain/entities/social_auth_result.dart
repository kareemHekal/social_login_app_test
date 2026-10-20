import 'package:equatable/equatable.dart';

class SocialAuthResult extends Equatable {
  final String? token;
  final String? message;
  final Map<String, dynamic>? user;
  final bool isNewUser;
  final String? idToken;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  const SocialAuthResult({
    this.token,
    this.message,
    this.user,
    this.isNewUser = false,
    this.idToken,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [
        token,
        message,
        user,
        isNewUser,
        idToken,
        email,
        displayName,
        photoUrl,
      ];
}
