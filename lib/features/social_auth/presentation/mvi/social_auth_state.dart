import 'package:equatable/equatable.dart';

enum SocialAuthStatus {
  initial,
  loading,
  authenticated,
  needsRegistration,
  error,
}

enum SocialCheckStatus {
  idle,
  checking,
  isSocial,
  isNormal,
  error,
}

class SocialAuthState extends Equatable {
  final SocialAuthStatus authStatus;
  final SocialCheckStatus checkStatus;

  // Social token & profile
  final String? idToken;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  // Elevate Backend data
  final String? backendToken;
  final Map<String, dynamic>? backendUser;
  final String? authMessage;

  // Forgot password check results
  final String? checkedEmail;
  final String? checkMessage;

  // Error
  final String? errorMessage;

  const SocialAuthState({
    this.authStatus = SocialAuthStatus.initial,
    this.checkStatus = SocialCheckStatus.idle,
    this.idToken,
    this.email,
    this.displayName,
    this.photoUrl,
    this.backendToken,
    this.backendUser,
    this.authMessage,
    this.checkedEmail,
    this.checkMessage,
    this.errorMessage,
  });

  SocialAuthState copyWith({
    SocialAuthStatus? authStatus,
    SocialCheckStatus? checkStatus,
    String? idToken,
    String? email,
    String? displayName,
    String? photoUrl,
    String? backendToken,
    Map<String, dynamic>? backendUser,
    String? authMessage,
    String? checkedEmail,
    String? checkMessage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SocialAuthState(
      authStatus: authStatus ?? this.authStatus,
      checkStatus: checkStatus ?? this.checkStatus,
      idToken: idToken ?? this.idToken,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      backendToken: backendToken ?? this.backendToken,
      backendUser: backendUser ?? this.backendUser,
      authMessage: authMessage ?? this.authMessage,
      checkedEmail: checkedEmail ?? this.checkedEmail,
      checkMessage: checkMessage ?? this.checkMessage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
        authStatus,
        checkStatus,
        idToken,
        email,
        displayName,
        photoUrl,
        backendToken,
        backendUser,
        authMessage,
        checkedEmail,
        checkMessage,
        errorMessage,
      ];
}
