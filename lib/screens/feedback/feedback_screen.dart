import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../models/feedback_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/feedback_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _feedbackService = FeedbackService();
  int _rating = 5;
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;
    setState(() => _submitting = true);

    try {
      final feedback = FeedbackModel(
        userId: userId,
        subject: _subjectController.text,
        message: _messageController.text,
        rating: _rating,
      );
      await _feedbackService.submit(feedback);

      if (!mounted) return;
      _subjectController.clear();
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Thanks for your feedback!')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send feedback: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send feedback')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('How would you rate CurrenSee?', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(5, (i) {
                    final filled = i < _rating;
                    return IconButton(
                      icon: Icon(filled ? Icons.star_rounded : Icons.star_border_rounded, color: AppColors.accent, size: 32),
                      onPressed: () => setState(() => _rating = i + 1),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _subjectController,
                  label: 'Subject',
                  hint: 'What\'s this about?',
                  prefixIcon: Icons.subject_rounded,
                  validator: (v) => Validators.notEmpty(v, label: 'Subject'),
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  controller: _messageController,
                  label: 'Your feedback',
                  hint: 'Tell us what you think or report an issue...',
                  maxLines: 6,
                  validator: (v) => Validators.notEmpty(v, label: 'Feedback'),
                ),
                const SizedBox(height: 28),
                CustomButton(label: 'Submit feedback', isLoading: _submitting, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}