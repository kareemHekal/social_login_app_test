import '../repositories/social_auth_repository.dart';

class CancelSocialRegistrationUseCase {
  final SocialAuthRepository repository;

  CancelSocialRegistrationUseCase(this.repository);

  Future<void> call() {
    return repository.cancelSocialRegistration();
  }
}
