import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/social_provider.dart';

abstract class SocialAuthFirebaseDataSource {
  Future<String> getSocialIdToken(SocialProvider provider);
  Future<void> markSocialUser(String email, {String provider = 'google'});
  Future<bool> isSocialUser(String email);
  Future<void> deleteCurrentFirebaseUser();
  Future<void> signOut();
  User? getCurrentUser();
}

class SocialAuthFirebaseDataSourceImpl implements SocialAuthFirebaseDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  SocialAuthFirebaseDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance,
        googleSignIn = googleSignIn ??
            GoogleSignIn(
              serverClientId: ApiConstants.webClientId,
              scopes: const ['email', 'profile'],
            );

  @override
  Future<String> getSocialIdToken(SocialProvider provider) async {
    switch (provider) {
      case SocialProvider.google:
        return _signInWithGoogle();
      case SocialProvider.facebook:
        // Ready for Facebook integration in competition
        throw AuthException(
          message: 'تسجيل الدخول بـ Facebook سيكون متاحاً قريباً',
        );
    }
  }

  Future<String> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      if (account == null) {
        throw AuthException(message: 'تم إلغاء تسجيل الدخول بجوجل');
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      final String? idToken = await userCredential.user?.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw AuthException(message: 'فشل في استخراج Firebase ID Token');
      }

      return idToken;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(message: 'حدث خطأ أثناء الاتصال بجوجل: ${e.toString()}');
    }
  }

  @override
  Future<void> markSocialUser(
    String email, {
    String provider = 'google',
  }) async {
    try {
      await firestore
          .collection(ApiConstants.socialUsersCollection)
          .doc(email.trim().toLowerCase())
          .set({
        'provider': provider,
        'email': email.trim().toLowerCase(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw ServerException(
        message: 'فشل تسجيل المستخدم في Firestore: ${e.toString()}',
      );
    }
  }

  @override
  Future<bool> isSocialUser(String email) async {
    try {
      final doc = await firestore
          .collection(ApiConstants.socialUsersCollection)
          .doc(email.trim().toLowerCase())
          .get();
      return doc.exists;
    } catch (e) {
      throw ServerException(
        message: 'فشل التحقق من نوع الحساب: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteCurrentFirebaseUser() async {
    try {
      await firebaseAuth.currentUser?.delete();
    } catch (_) {}
  }

  @override
  Future<void> signOut() async {
    try {
      await googleSignIn.signOut();
      await firebaseAuth.signOut();
    } catch (_) {}
  }

  @override
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}
