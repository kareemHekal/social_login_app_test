import '../entities/social_provider.dart';
import '../entities/social_auth_result.dart';
import '../entities/social_register_profile.dart';

abstract class SocialAuthRepository {
  /// Sign in with social provider (Google, Facebook, etc.)
  /// Automatically retrieves ID token and attempts backend login.
  /// If the account is new on backend, returns result with isNewUser = true.
  Future<SocialAuthResult> loginWithSocial(SocialProvider provider);

  /// Complete registration for a new social user on the backend
  Future<SocialAuthResult> registerWithSocial({
    required String idToken,
    required SocialRegisterProfile profile,
  });

  /// Check whether an email belongs to a social account (for Forgot Password verification)
  Future<bool> checkIsSocialUser(String email);

  /// Cancel registration and rollback orphan Firebase account
  Future<void> cancelSocialRegistration();

  /// Sign out from social providers and Firebase
  Future<void> signOut();
}
