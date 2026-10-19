import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:curved_navigation_bar_pro/curved_navigation_bar_pro.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../converter/converter_screen.dart';
import '../history/conversion_history_screen.dart';
import '../alerts/alerts_screen.dart';
import '../news/news_screen.dart';
import '../profile/profile_screen.dart';
import '../../core/theme/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _index = 0;

  final _screens = const [
    ConverterScreen(),
    ConversionHistoryScreen(),
    AlertsScreen(),
    NewsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.id;
      if (userId != null) {
        context.read<NotificationProvider>().loadNotifications(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Derive every nav-bar color from the *current* theme brightness instead
    // of hardcoding one variant — this is what makes it actually switch
    // when the user toggles dark mode.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: CurvedNavigationBarPro(
        barHeight: 90,
        fabSink: 20,
        fabGap: 8,
        cornerRadius: 17,
        notchShoulderRadius: 17,
        contentPadding: 19,
        navbarStyle: CNBPStyles.minimalMono,
        activeIconSize: 26,
        inactiveIconSize: 26,
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        activeColor: isDark ? AppColors.primary : AppColors.primary,
        activeIconColor: Colors.white,
        fabColor: isDark ? AppColors.primary : AppColors.primary,
        inactiveColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        shadowColor: (isDark ? Colors.black : AppColors.textPrimary)
            .withValues(alpha: isDark ? 0.35 : 0.1),
        items: const [
          CurvedNavigationItemPro(
            inactiveIcon: Icons.currency_exchange_outlined,
            activeIcon: Icons.currency_exchange_rounded,
            label: 'Convert',
          ),
          CurvedNavigationItemPro(
            inactiveIcon: Icons.history_outlined,
            activeIcon: Icons.history_rounded,
            label: 'History',
          ),
          CurvedNavigationItemPro(
            inactiveIcon: Icons.notifications_none_rounded,
            activeIcon: Icons.notifications_active_rounded,
            label: 'Alerts',
          ),
          CurvedNavigationItemPro(
            inactiveIcon: Icons.article_outlined,
            activeIcon: Icons.article_rounded,
            label: 'News',
          ),
          CurvedNavigationItemPro(
            inactiveIcon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
          ),
        ],
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}