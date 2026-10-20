import 'package:flutter/material.dart';
import '../../mvi/social_auth_state.dart';

class SocialForgotPasswordCheckCard extends StatefulWidget {
  final SocialAuthState state;
  final Function(String email) onCheckEmail;

  const SocialForgotPasswordCheckCard({
    super.key,
    required this.state,
    required this.onCheckEmail,
  });

  @override
  State<SocialForgotPasswordCheckCard> createState() => _SocialForgotPasswordCheckCardState();
}

class _SocialForgotPasswordCheckCardState extends State<SocialForgotPasswordCheckCard> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isChecking = state.checkStatus == SocialCheckStatus.checking;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lock_reset, color: Colors.deepOrange),
                SizedBox(width: 8),
                Text(
                  'اختبار التحقق من نسيان كلمة المرور',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'التحقق هل الحساب Social User في Firestore لتوجيهه لزر الدخول أم إكمال الـ OTP القديم:',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'ادخل الإيميل للاختبار...',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isChecking
                      ? null
                      : () => widget.onCheckEmail(_emailController.text),
                  child: isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('فحص'),
                ),
              ],
            ),
            if (state.checkStatus != SocialCheckStatus.idle) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: state.checkStatus == SocialCheckStatus.isSocial
                      ? Colors.amber.shade50
                      : state.checkStatus == SocialCheckStatus.isNormal
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: state.checkStatus == SocialCheckStatus.isSocial
                        ? Colors.amber.shade400
                        : state.checkStatus == SocialCheckStatus.isNormal
                            ? Colors.green.shade400
                            : Colors.red.shade400,
                  ),
                ),
                child: Text(
                  state.checkMessage ?? '',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: state.checkStatus == SocialCheckStatus.isSocial
                        ? Colors.amber.shade900
                        : state.checkStatus == SocialCheckStatus.isNormal
                            ? Colors.green.shade900
                            : Colors.red.shade900,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
