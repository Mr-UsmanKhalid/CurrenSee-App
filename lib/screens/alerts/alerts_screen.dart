import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/rate_alert_model.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'create_alert_screen.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) context.read<AlertProvider>().loadAlerts(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlertProvider>();
    final userId = context.watch<AuthProvider>().user?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('Rate Alerts')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateAlertScreen())),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New alert'),
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Padding(padding: EdgeInsets.all(20), child: ShimmerListPlaceholder(itemCount: 5, itemHeight: 80))
            : provider.alerts.isEmpty
                ? const EmptyStateWidget(
                    title: 'No rate alerts set',
                    subtitle: 'Get notified when a currency pair reaches your target rate.',
                    icon: Icons.notifications_active_outlined,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                    itemCount: provider.alerts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final a = provider.alerts[i];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (a.condition == AlertCondition.above ? AppColors.success : AppColors.danger).withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  a.condition == AlertCondition.above ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                  color: a.condition == AlertCondition.above ? AppColors.success : AppColors.danger,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${a.baseCurrency} → ${a.targetCurrency}', style: const TextStyle(fontWeight: FontWeight.w700)),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Alert when rate goes ${a.condition == AlertCondition.above ? 'above' : 'below'} ${a.threshold.toStringAsFixed(4)}',
                                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                    ),
                                    if (a.isTriggered) ...[
                                      const SizedBox(height: 4),
                                      const Text('Triggered', style: TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w700)),
                                    ],
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Switch(
                                    value: a.isActive,
                                    activeThumbColor: AppColors.primary,
                                    onChanged: (_) => context.read<AlertProvider>().toggleActive(a),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.textSecondary),
                                    onPressed: () => context.read<AlertProvider>().deleteAlert(a.id!),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
