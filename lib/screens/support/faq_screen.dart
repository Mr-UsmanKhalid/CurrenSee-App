import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _faqs = [
    ('How do I convert a currency?', 'Go to the Convert tab, enter an amount, choose your currencies, and the converted amount updates instantly using live rates.'),
    ('How often are exchange rates updated?', 'Rates are fetched live each time you open or refresh the Convert or Rates screens.'),
    ('How do rate alerts work?', 'Set a target rate and condition (above/below) for a currency pair under the Alerts tab. You\'ll be notified when the rate crosses your threshold.'),
    ('Is my conversion history saved?', 'Yes, every conversion you save is stored locally on your device in a secure SQL database.'),
    ('Can I change my default currency?', 'Yes — go to Profile > Preferences and choose your default base currency.'),
    ('How do I reset my password?', 'From the sign-in screen, tap "Forgot password?" and follow the steps.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQs')),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: _faqs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final (q, a) = _faqs[i];
            return Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: Card(
                child: ExpansionTile(
                  title: Text(q, style: const TextStyle(fontWeight: FontWeight.w600)),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(a, style: const TextStyle(color: AppColors.textSecondary, height: 1.5))],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
