import '../repositories/social_auth_repository.dart';

class SocialSignOutUseCase {
  final SocialAuthRepository repository;

  SocialSignOutUseCase(this.repository);

  Future<void> call() {
    return repository.signOut();
  }
}
