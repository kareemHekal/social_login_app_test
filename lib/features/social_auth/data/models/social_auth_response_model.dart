import '../../domain/entities/social_auth_result.dart';

class SocialAuthResponseModel extends SocialAuthResult {
  const SocialAuthResponseModel({
    super.token,
    super.message,
    super.user,
    super.isNewUser = false,
    super.idToken,
    super.email,
    super.displayName,
    super.photoUrl,
  });

  factory SocialAuthResponseModel.fromJson(
    Map<String, dynamic> json, {
    bool isNewUser = false,
    String? idToken,
    String? email,
    String? displayName,
    String? photoUrl,
  }) {
    return SocialAuthResponseModel(
      token: json['token'] as String?,
      message: json['message'] as String?,
      user: json['user'] is Map<String, dynamic>
          ? json['user'] as Map<String, dynamic>
          : null,
      isNewUser: isNewUser,
      idToken: idToken,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'message': message,
      'user': user,
    };
  }
}
