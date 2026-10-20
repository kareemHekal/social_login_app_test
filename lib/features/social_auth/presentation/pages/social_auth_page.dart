import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/social_provider.dart';
import '../../domain/entities/social_register_profile.dart';
import '../mvi/social_auth_cubit.dart';
import '../mvi/social_auth_intent.dart';
import '../mvi/social_auth_state.dart';
import 'widgets/social_forgot_password_check_card.dart';
import 'widgets/social_register_dialog.dart';
import 'widgets/social_user_profile_card.dart';

class SocialAuthPage extends StatelessWidget {
  const SocialAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Auth Gateway', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<SocialAuthCubit, SocialAuthState>(
        listener: (context, state) {
          if (state.authStatus == SocialAuthStatus.needsRegistration) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dContext) => SocialRegisterDialog(
                initialDisplayName: state.displayName,
                email: state.email,
                onSubmit: (SocialRegisterProfile profile) {
                  context.read<SocialAuthCubit>().processIntent(
                        SocialRegisterIntent(profile),
                      );
                },
                onCancel: () {
                  context.read<SocialAuthCubit>().processIntent(
                        const SocialCancelRegistrationIntent(),
                      );
                },
              ),
            );
          }

          if (state.authStatus == SocialAuthStatus.error && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state.authStatus == SocialAuthStatus.authenticated && state.authMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.authMessage!),
                backgroundColor: Colors.green.shade700,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<SocialAuthCubit>();
          final isLoading = state.authStatus == SocialAuthStatus.loading;
          final isAuthenticated = state.authStatus == SocialAuthStatus.authenticated;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Banner
                Card(
                  color: Colors.indigo.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Icon(Icons.hub_outlined, color: Colors.indigo, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'المعمارية: تطبيق فلاتر (MVI + Clean Architecture) ← Social Auth DataSources ← وسيط Cloudflare Gateway ← سيرفر Elevate.',
                            style: TextStyle(fontSize: 12, color: Colors.indigo),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Main Social Auth Section
                if (isAuthenticated) ...[
                  SocialUserProfileCard(
                    state: state,
                    onSignOut: () => cubit.processIntent(const SocialSignOutIntent()),
                  ),
                ] else ...[
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 28.0),
                      child: Column(
                        children: [
                          const Icon(Icons.account_circle, size: 64, color: Colors.indigo),
                          const SizedBox(height: 12),
                          const Text(
                            'تسجيل الدخول عبر الشبكات الاجتماعية',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'الدخول أو التسجيل الذكي بحسابك المفضل عبر الـ Gateway',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 24),
                          if (isLoading)
                            const Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 12),
                                Text(
                                  'جارٍ المصادقة مع الـ Gateway...',
                                  style: TextStyle(fontSize: 12, color: Colors.indigo),
                                ),
                              ],
                            )
                          else ...[
                            // Google Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black87,
                                  elevation: 2,
                                  side: BorderSide(color: Colors.grey.shade300),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: Image.network(
                                  'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                  width: 22,
                                  height: 22,
                                  errorBuilder: (_, _, _) => const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                                ),
                                label: const Text(
                                  'متابعة باستخدام Google',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                onPressed: () {
                                  cubit.processIntent(
                                    const SocialLoginIntent(provider: SocialProvider.google),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Facebook Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1877F2),
                                  foregroundColor: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.facebook, size: 24, color: Colors.white),
                                label: const Text(
                                  'متابعة باستخدام Facebook',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                onPressed: () {
                                  cubit.processIntent(
                                    const SocialLoginIntent(provider: SocialProvider.facebook),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // Forgot Password Check Section
                SocialForgotPasswordCheckCard(
                  state: state,
                  onCheckEmail: (email) {
                    cubit.processIntent(SocialCheckUserIntent(email));
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
