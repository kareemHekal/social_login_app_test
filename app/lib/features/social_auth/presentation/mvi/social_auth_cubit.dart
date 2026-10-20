import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/cancel_social_registration_usecase.dart';
import '../../domain/usecases/check_social_user_usecase.dart';
import '../../domain/usecases/social_login_usecase.dart';
import '../../domain/usecases/social_register_usecase.dart';
import '../../domain/usecases/social_sign_out_usecase.dart';
import 'social_auth_intent.dart';
import 'social_auth_state.dart';

class SocialAuthCubit extends Cubit<SocialAuthState> {
  final SocialLoginUseCase socialLoginUseCase;
  final SocialRegisterUseCase socialRegisterUseCase;
  final CheckSocialUserUseCase checkSocialUserUseCase;
  final SocialSignOutUseCase socialSignOutUseCase;
  final CancelSocialRegistrationUseCase cancelSocialRegistrationUseCase;

  SocialAuthCubit({
    required this.socialLoginUseCase,
    required this.socialRegisterUseCase,
    required this.checkSocialUserUseCase,
    required this.socialSignOutUseCase,
    required this.cancelSocialRegistrationUseCase,
  }) : super(const SocialAuthState());

  void processIntent(SocialAuthIntent intent) {
    if (intent is SocialLoginIntent) {
      _handleSocialLogin(intent);
    } else if (intent is SocialRegisterIntent) {
      _handleSocialRegister(intent);
    } else if (intent is SocialCheckUserIntent) {
      _handleSocialCheckUser(intent);
    } else if (intent is SocialCancelRegistrationIntent) {
      _handleCancelRegistration();
    } else if (intent is SocialSignOutIntent) {
      _handleSignOut();
    } else if (intent is SocialClearErrorIntent) {
      emit(state.copyWith(clearError: true));
    }
  }

  Future<void> _handleSocialLogin(SocialLoginIntent intent) async {
    emit(state.copyWith(
      authStatus: SocialAuthStatus.loading,
      clearError: true,
    ));

    try {
      final result = await socialLoginUseCase(intent.provider);

      if (result.isNewUser) {
        emit(state.copyWith(
          authStatus: SocialAuthStatus.needsRegistration,
          idToken: result.idToken,
          email: result.email,
          displayName: result.displayName,
          photoUrl: result.photoUrl,
          authMessage: 'حساب جديد، يرجى استكمال البيانات للتسجيل',
        ));
      } else {
        emit(state.copyWith(
          authStatus: SocialAuthStatus.authenticated,
          idToken: result.idToken,
          backendToken: result.token,
          backendUser: result.user,
          email: result.email,
          displayName: result.displayName,
          photoUrl: result.photoUrl,
          authMessage: result.message ?? 'تم تسجيل الدخول بنجاح',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        authStatus: SocialAuthStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _handleSocialRegister(SocialRegisterIntent intent) async {
    final currentToken = state.idToken ;
    if (currentToken == null || currentToken.isEmpty) {
      emit(state.copyWith(
        authStatus: SocialAuthStatus.error,
        errorMessage: 'انتهت صلاحية جلسة التسجيل، يرجى المحاولة مرة أخرى',
      ));
      return;
    }

    emit(state.copyWith(
      authStatus: SocialAuthStatus.loading,
      clearError: true,
    ));

    try {
      final result = await socialRegisterUseCase(
        idToken: currentToken,
        profile: intent.profile,
      );

      emit(state.copyWith(
        authStatus: SocialAuthStatus.authenticated,
        backendToken: result.token,
        backendUser: result.user,
        email: result.email,
        displayName: result.displayName,
        photoUrl: result.photoUrl,
        authMessage: result.message ?? 'تم إنشاء الحساب بنجاح',
      ));
    } catch (e) {
      emit(state.copyWith(
        authStatus: SocialAuthStatus.error,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _handleSocialCheckUser(SocialCheckUserIntent intent) async {
    final email = intent.email.trim();

    if (email.isEmpty) {
      emit(state.copyWith(
        checkStatus: SocialCheckStatus.error,
        checkMessage: 'يرجى إدخال البريد الإلكتروني للتحقق منه',
      ));
      return;
    }

    emit(state.copyWith(
      checkStatus: SocialCheckStatus.checking,
      checkedEmail: email,
    ));

    try {
      final isSocial = await checkSocialUserUseCase(email);
      if (isSocial) {
        emit(state.copyWith(
          checkStatus: SocialCheckStatus.isSocial,
          checkedEmail: email,
          checkMessage:
              '⚠️ هذا الحساب مسجل بواسطة Social Login. لا يمكن استعادة كلمة المرور، يرجى تسجيل الدخول مباشرة بالزر الاجتماعي.',
        ));
      } else {
        emit(state.copyWith(
          checkStatus: SocialCheckStatus.isNormal,
          checkedEmail: email,
          checkMessage:
              '✅ هذا الحساب مسجل بالطريقة العادية (Email/Password). يمكنه استعادة كلمة المرور عبر الـ OTP كالمعتاد.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        checkStatus: SocialCheckStatus.error,
        checkMessage: 'فشل التحقق: ${e.toString().replaceFirst('Exception: ', '')}',
      ));
    }
  }


  Future<void> _handleCancelRegistration() async {
    await cancelSocialRegistrationUseCase();
    emit(const SocialAuthState());
  }

  Future<void> _handleSignOut() async {
    await socialSignOutUseCase();
    emit(const SocialAuthState());
  }
}
