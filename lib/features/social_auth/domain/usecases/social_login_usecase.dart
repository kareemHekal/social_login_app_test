import '../entities/social_auth_result.dart';
import '../entities/social_provider.dart';
import '../repositories/social_auth_repository.dart';

class SocialLoginUseCase {
  final SocialAuthRepository repository;

  SocialLoginUseCase(this.repository);

  Future<SocialAuthResult> call(SocialProvider provider) {
    return repository.loginWithSocial(provider);
  }
}
