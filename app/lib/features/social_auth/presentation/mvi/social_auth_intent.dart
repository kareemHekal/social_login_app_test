import 'package:equatable/equatable.dart';
import '../../domain/entities/social_provider.dart';
import '../../domain/entities/social_register_profile.dart';

abstract class SocialAuthIntent extends Equatable {
  const SocialAuthIntent();

  @override
  List<Object?> get props => [];
}

/// Request login with a social provider (Google, Facebook, etc.)
class SocialLoginIntent extends SocialAuthIntent {
  final SocialProvider provider;

  const SocialLoginIntent({this.provider = SocialProvider.google});

  @override
  List<Object?> get props => [provider];
}

/// Submit profile data to register a new social user
class SocialRegisterIntent extends SocialAuthIntent {
  final SocialRegisterProfile profile;

  const SocialRegisterIntent(this.profile);

  @override
  List<Object?> get props => [profile];
}

/// Check if an email is a social user (for Forgot Password)
class SocialCheckUserIntent extends SocialAuthIntent {
  final String email;

  const SocialCheckUserIntent(this.email);

  @override
  List<Object?> get props => [email];
}

/// User cancelled the registration dialog
class SocialCancelRegistrationIntent extends SocialAuthIntent {
  const SocialCancelRegistrationIntent();
}

/// User tapped sign out
class SocialSignOutIntent extends SocialAuthIntent {
  const SocialSignOutIntent();
}

/// Clear temporary errors
class SocialClearErrorIntent extends SocialAuthIntent {
  const SocialClearErrorIntent();
}
