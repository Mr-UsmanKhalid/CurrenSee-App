import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_utils.dart';
import '../../providers/news_provider.dart';
import '../../widgets/loading_widget.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<NewsProvider>();
      if (provider.articles.isEmpty) provider.loadNews();
    });
  }

  Color _trendColor(String trend) {
    switch (trend) {
      case 'up':
        return AppColors.success;
      case 'down':
        return AppColors.danger;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _trendIcon(String trend) {
    switch (trend) {
      case 'up':
        return Icons.trending_up_rounded;
      case 'down':
        return Icons.trending_down_rounded;
      default:
        return Icons.trending_flat_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NewsProvider>();
    // Read colors from the *current* theme on every build so they update
    // instantly when switching dark/light (no hardcoded Colors.black).
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedText = isDark ? Colors.white70 : AppColors.textSecondary;
    final borderColor = isDark ? Colors.white.withValues(alpha: 0.08) : AppColors.border;

    return Scaffold(
      appBar: AppBar(title: const Text('Market News')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<NewsProvider>().loadNews(),
          child: provider.isLoading
              ? const Padding(padding: EdgeInsets.all(20), child: ShimmerListPlaceholder(itemCount: 5, itemHeight: 110))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: provider.articles.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, i) {
                    final n = provider.articles[i];
                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => NewsDetailScreen(article: n))),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(_trendIcon(n.trend), color: _trendColor(n.trend), size: 18),
                                const SizedBox(width: 6),
                                Text(n.source, style: TextStyle(color: primaryText, fontSize: 12, fontWeight: FontWeight.w600)),
                                const Spacer(),
                                Text(CurrencyUtils.formatDateShort(n.publishedAt), style: TextStyle(color: mutedText, fontSize: 11)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(n.title, style: TextStyle(color: primaryText, fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text(n.summary, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: mutedText)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}