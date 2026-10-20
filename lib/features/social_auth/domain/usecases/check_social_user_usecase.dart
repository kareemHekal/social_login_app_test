import '../repositories/social_auth_repository.dart';

class CheckSocialUserUseCase {
  final SocialAuthRepository repository;

  CheckSocialUserUseCase(this.repository);

  Future<bool> call(String email) {
    return repository.checkIsSocialUser(email);
  }
}
