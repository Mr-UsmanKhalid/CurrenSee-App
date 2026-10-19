import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/currency_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/currency_model.dart';
import '../../widgets/currency_dropdown.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../support/faq_screen.dart';
import '../support/support_screen.dart';
import '../feedback/feedback_screen.dart';
import 'preferences_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(22)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    child: Text(
                      (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? '', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(user?.email ?? '', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    onPressed: () => _openEditProfile(context, user),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const _SectionLabel('Account'),
            _ProfileTile(icon: Icons.tune_rounded, label: 'Preferences', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PreferencesScreen()))),
            const SizedBox(height: 24),
            const _SectionLabel('Support'),
            _ProfileTile(icon: Icons.help_outline_rounded, label: 'FAQs & user guide', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FaqScreen()))),
            _ProfileTile(icon: Icons.support_agent_rounded, label: 'Contact support', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SupportScreen()))),
            _ProfileTile(icon: Icons.feedback_outlined, label: 'Send feedback', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FeedbackScreen()))),
            const SizedBox(height: 24),
            _ProfileTile(
              icon: Icons.logout_rounded,
              label: 'Log out',
              color: AppColors.danger,
              onTap: () => _confirmLogout(context),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditProfile(BuildContext context, user) {
    if (user == null) return;
    final nameController = TextEditingController(text: user.name);
    String currency = user.defaultCurrency;
    context.read<CurrencyProvider>().loadCurrencies();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              final currencies = context.watch<CurrencyProvider>().currencies;
              final userProvider = context.watch<UserProvider>();
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit profile', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 20),
                  CustomTextField(controller: nameController, label: 'Full name', prefixIcon: Icons.person_outline_rounded),
                  const SizedBox(height: 18),
                  const Text('Default currency', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  CurrencyDropdown(
                    selectedCode: currency,
                    currencies: currencies.isEmpty
                        ? [CurrencyModel(code: currency, name: CurrencyUtils.nameFor(currency), symbol: CurrencyUtils.symbolFor(currency))]
                        : currencies,
                    onChanged: (v) => setModalState(() => currency = v),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    label: 'Save changes',
                    isLoading: userProvider.isSaving,
                    onPressed: () async {
                      final updated = await context.read<UserProvider>().updateProfile(
                            current: user,
                            name: nameController.text,
                            defaultCurrency: currency,
                          );
                      context.read<AuthProvider>().updateLocalUser(updated);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You can sign back in anytime with your email and password.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
              }
            },
            child: const Text('Log out', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(text.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.6)),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileTile({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
