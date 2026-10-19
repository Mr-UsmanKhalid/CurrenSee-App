import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../services/support_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _supportService = SupportService();
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;
    setState(() => _submitting = true);

    try {
      await _supportService.submitTicket(
        subject: _subjectController.text,
        message: _messageController.text,
      );

      if (!mounted) return;
      _subjectController.clear();
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Support ticket submitted. Our team will get back to you by email.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit ticket: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact support')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Describe your issue and we\'ll respond by email as soon as possible.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _subjectController,
                  label: 'Subject',
                  hint: 'e.g. Rate alert not triggering',
                  prefixIcon: Icons.subject_rounded,
                  validator: (v) => Validators.notEmpty(v, label: 'Subject'),
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  controller: _messageController,
                  label: 'Message',
                  hint: 'Tell us what happened...',
                  maxLines: 6,
                  validator: (v) => Validators.notEmpty(v, label: 'Message'),
                ),
                const SizedBox(height: 28),
                CustomButton(label: 'Submit ticket', isLoading: _submitting, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}