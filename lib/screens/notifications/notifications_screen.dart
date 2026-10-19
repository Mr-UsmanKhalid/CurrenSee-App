import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _iconFor(String type) {
    switch (type) {
      case 'alert':
        return Icons.notifications_active_rounded;
      case 'news':
        return Icons.article_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    final userId = context.watch<AuthProvider>().user?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (provider.notifications.isNotEmpty)
            TextButton(
              onPressed: userId == null ? null : () => context.read<NotificationProvider>().markAllRead(userId),
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: SafeArea(
        child: provider.isLoading
            ? const Padding(padding: EdgeInsets.all(20), child: ShimmerListPlaceholder(itemCount: 6, itemHeight: 68))
            : provider.notifications.isEmpty
                ? const EmptyStateWidget(
                    title: 'You\'re all caught up',
                    subtitle: 'Notifications about alerts and account activity will appear here.',
                    icon: Icons.notifications_none_rounded,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: provider.notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final n = provider.notifications[i];
                      return Dismissible(
                        key: ValueKey(n.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(16)),
                          child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                        ),
                        onDismissed: (_) => context.read<NotificationProvider>().delete(n.id!),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: n.isRead ? Theme.of(context).cardColor : AppColors.primary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: InkWell(
                            onTap: () => context.read<NotificationProvider>().markRead(n.id!),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(_iconFor(n.type), color: AppColors.primary),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(n.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 4),
                                      Text(n.message, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                      const SizedBox(height: 6),
                                      Text(CurrencyUtils.formatDate(n.createdAt), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                                    ],
                                  ),
                                ),
                                if (!n.isRead)
                                  Container(width: 8, height: 8, margin: const EdgeInsets.only(top: 4), decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
