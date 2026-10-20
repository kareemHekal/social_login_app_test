import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/social_auth_result.dart';
import '../../domain/entities/social_provider.dart';
import '../../domain/entities/social_register_profile.dart';
import '../../domain/repositories/social_auth_repository.dart';
import '../datasources/social_auth_firebase_data_source.dart';
import '../datasources/social_auth_gateway_data_source.dart';

class SocialAuthRepositoryImpl implements SocialAuthRepository {
  final SocialAuthFirebaseDataSource socialAuthFirebaseDataSource;
  final SocialAuthGatewayDataSource socialAuthGatewayDataSource;

  SocialAuthRepositoryImpl({
    required this.socialAuthFirebaseDataSource,
    required this.socialAuthGatewayDataSource,
  });

  @override
  Future<SocialAuthResult> loginWithSocial(SocialProvider provider) async {
    // 1. Get ID Token from the social provider via Firebase
    final idToken = await socialAuthFirebaseDataSource.getSocialIdToken(provider);
    final user = socialAuthFirebaseDataSource.getCurrentUser();

    try {
      // 2. Call Cloudflare Worker gateway
      final response = await socialAuthGatewayDataSource.callSocialLogin(idToken);

      // 3. Mark user in Firestore so Forgot Password check works
      final email = user?.email ?? '';
      if (email.isNotEmpty) {
        try {
          await socialAuthFirebaseDataSource.markSocialUser(email, provider: provider.name);
        } catch (e) {
          debugPrint('⚠️ Error saving to Firestore in loginWithSocial: $e');
        }
      }

      return SocialAuthResult(
        token: response.token,
        message: response.message,
        user: response.user,
        isNewUser: false,
        idToken: idToken,
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoURL,
      );
    } on UserNotRegisteredException {
      // Account does not exist on Elevate backend yet
      return SocialAuthResult(
        isNewUser: true,
        idToken: idToken,
        message: 'الحساب جديد ويحتاج لإكمال البيانات',
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoURL,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<SocialAuthResult> registerWithSocial({
    required String idToken,
    required SocialRegisterProfile profile,
  }) async {
    final user = socialAuthFirebaseDataSource.getCurrentUser();

    try {
      final response = await socialAuthGatewayDataSource.callSocialRegister(
        idToken: idToken,
        profile: profile,
      );

      // Mark in Firestore for Forgot Password verification
      final email = user?.email ?? '';
      if (email.isNotEmpty) {
        try {
          await socialAuthFirebaseDataSource.markSocialUser(email);
        } catch (e) {
          debugPrint('⚠️ Error saving to Firestore in registerWithSocial: $e');
        }
      }

      return SocialAuthResult(
        token: response.token,
        message: response.message,
        user: response.user,
        isNewUser: false,
        idToken: idToken,
        email: user?.email,
        displayName: user?.displayName,
        photoUrl: user?.photoURL,
      );
    } on ServerException catch (e) {
      if (e.statusCode == 409) {
        // Rollback: Delete orphan account from Firebase Auth
        await socialAuthFirebaseDataSource.deleteCurrentFirebaseUser();
        await socialAuthFirebaseDataSource.signOut();
        throw AuthException(
          message:
              'هذا البريد الإلكتروني مسجل مسبقاً بكلمة مرور عادية على السيرفر القديم. يرجى تسجيل الدخول بالبريد وكلمة المرور الخاصة بك.',
        );
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> checkIsSocialUser(String email) async {
    return await socialAuthFirebaseDataSource.isSocialUser(email);
  }

  @override
  Future<void> cancelSocialRegistration() async {
    await socialAuthFirebaseDataSource.deleteCurrentFirebaseUser();
    await socialAuthFirebaseDataSource.signOut();
  }

  @override
  Future<void> signOut() async {
    await socialAuthFirebaseDataSource.signOut();
  }
}
