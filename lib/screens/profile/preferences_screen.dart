import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/currency_provider.dart';
import '../../providers/preference_provider.dart';
import '../../widgets/currency_dropdown.dart';
import '../../models/currency_model.dart';
import '../../core/utils/currency_utils.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      context.read<CurrencyProvider>().loadCurrencies();
      if (userId != null) context.read<PreferenceProvider>().load(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PreferenceProvider>();
    final currencies = context.watch<CurrencyProvider>().currencies;
    final userId = context.watch<AuthProvider>().user?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.attach_money_rounded, color: AppColors.primary),
                title: const Text('Default base currency', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Used automatically when you open Convert'),
                trailing: CurrencyDropdown(
                  selectedCode: prefs.defaultBaseCurrency,
                  currencies: currencies.isEmpty
                      ? [CurrencyModel(code: prefs.defaultBaseCurrency, name: CurrencyUtils.nameFor(prefs.defaultBaseCurrency), symbol: CurrencyUtils.symbolFor(prefs.defaultBaseCurrency))]
                      : currencies,
                  onChanged: (v) {
                    if (userId != null) context.read<PreferenceProvider>().updateDefaultCurrency(userId, v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.notifications_active_outlined, color: AppColors.primary),
                title: const Text('Push notifications', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('Rate alerts and app updates'),
                value: prefs.notificationsEnabled,
                activeThumbColor: AppColors.primary,
                onChanged: (v) {
                  if (userId != null) context.read<PreferenceProvider>().updateNotificationsEnabled(userId, v);
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                title: const Text('Dark mode', style: TextStyle(fontWeight: FontWeight.w600)),
                value: prefs.themeMode == ThemeMode.dark,
                activeThumbColor: AppColors.primary,
                onChanged: (v) {
                  if (userId != null) context.read<PreferenceProvider>().updateThemeMode(userId, v ? ThemeMode.dark : ThemeMode.light);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
