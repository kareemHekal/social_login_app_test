import 'package:flutter/material.dart';
import '../../../domain/entities/social_register_profile.dart';

class SocialRegisterDialog extends StatefulWidget {
  final String? initialDisplayName;
  final String? email;
  final Function(SocialRegisterProfile) onSubmit;
  final VoidCallback? onCancel;

  const SocialRegisterDialog({
    super.key,
    this.initialDisplayName,
    this.email,
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<SocialRegisterDialog> createState() => _SocialRegisterDialogState();
}

class _SocialRegisterDialogState extends State<SocialRegisterDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  final _heightController = TextEditingController(text: '175');
  final _weightController = TextEditingController(text: '75');
  final _ageController = TextEditingController(text: '25');

  String _gender = 'male';
  String _goal = 'Gain weight';
  String _activityLevel = 'level1';

  @override
  void initState() {
    super.initState();
    final names = (widget.initialDisplayName ?? '').trim().split(' ');
    _firstNameController = TextEditingController(text: names.isNotEmpty ? names.first : 'User');
    _lastNameController = TextEditingController(text: names.length > 1 ? names.sublist(1).join(' ') : 'Social');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.person_add_alt_1, color: Colors.indigo),
              SizedBox(width: 8),
              Text('إكمال بيانات الحساب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          if (widget.email != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                widget.email!,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(labelText: 'الاسم الأول', border: OutlineInputBorder()),
                        validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(labelText: 'اسم العائلة', border: OutlineInputBorder()),
                        validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _heightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'الطول (سم)', border: OutlineInputBorder()),
                        validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'الوزن (كجم)', border: OutlineInputBorder()),
                        validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'العمر', border: OutlineInputBorder()),
                        validator: (v) => v == null || v.isEmpty ? 'مطلوب' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: const InputDecoration(labelText: 'النوع (Gender)', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('ذكر (Male)')),
                    DropdownMenuItem(value: 'female', child: Text('أنثى (Female)')),
                  ],
                  onChanged: (v) => setState(() => _gender = v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _goal,
                  decoration: const InputDecoration(labelText: 'الهدف (Goal)', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'Gain weight', child: Text('زيادة الوزن (Gain weight)')),
                    DropdownMenuItem(value: 'Lose weight', child: Text('خسارة الوزن (Lose weight)')),
                    DropdownMenuItem(value: 'Get fitter', child: Text('لياقة بدنية (Get fitter)')),
                  ],
                  onChanged: (v) => setState(() => _goal = v!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _activityLevel,
                  decoration: const InputDecoration(labelText: 'مستوى النشاط (Activity Level)', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'level1', child: Text('مستوى 1 (خفيف)')),
                    DropdownMenuItem(value: 'level2', child: Text('مستوى 2 (متوسط)')),
                    DropdownMenuItem(value: 'level3', child: Text('مستوى 3 (عالي)')),
                  ],
                  onChanged: (v) => setState(() => _activityLevel = v!),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onCancel?.call();
          },
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final profile = SocialRegisterProfile(
                firstName: _firstNameController.text.trim(),
                lastName: _lastNameController.text.trim(),
                gender: _gender,
                height: num.tryParse(_heightController.text) ?? 175,
                weight: num.tryParse(_weightController.text) ?? 75,
                age: int.tryParse(_ageController.text) ?? 25,
                goal: _goal,
                activityLevel: _activityLevel,
              );
              Navigator.of(context).pop();
              widget.onSubmit(profile);
            }
          },
          child: const Text('تسجيل وإنشاء الحساب'),
        ),
      ],
    );
  }
}
