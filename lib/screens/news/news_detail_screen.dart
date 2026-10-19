import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_utils.dart';
import '../../models/news_model.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsModel article;
  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = isDark ? Colors.white : const Color(0xFF0F172A);
    final mutedText = isDark ? Colors.white70 : AppColors.textSecondary;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.source, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
              const SizedBox(height: 8),
              Text(article.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: primaryText, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(CurrencyUtils.formatDate(article.publishedAt), style: TextStyle(color: mutedText, fontSize: 12)),
              const SizedBox(height: 20),
              Text(article.content, style: TextStyle(color: primaryText, fontSize: 15, height: 1.6)),
            ],
          ),
        ),
      ),
    );
  }
}