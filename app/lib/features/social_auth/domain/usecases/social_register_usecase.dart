import '../entities/social_auth_result.dart';
import '../entities/social_register_profile.dart';
import '../repositories/social_auth_repository.dart';

class SocialRegisterUseCase {
  final SocialAuthRepository repository;

  SocialRegisterUseCase(this.repository);

  Future<SocialAuthResult> call({
    required String idToken,
    required SocialRegisterProfile profile,
  }) {
    return repository.registerWithSocial(
      idToken: idToken,
      profile: profile,
    );
  }
}
