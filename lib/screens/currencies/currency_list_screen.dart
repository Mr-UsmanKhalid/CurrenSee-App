import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/currency_provider.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import 'currency_detail_screen.dart';

class CurrencyListScreen extends StatefulWidget {
  const CurrencyListScreen({super.key});

  @override
  State<CurrencyListScreen> createState() => _CurrencyListScreenState();
}

class _CurrencyListScreenState extends State<CurrencyListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CurrencyProvider>();
      if (provider.currencies.isEmpty) provider.loadCurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CurrencyProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Currencies')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                hintText: 'Search by code or name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.6),
                ),
              ),
              onChanged: provider.search,
            ),
            const SizedBox(height: 12),
            if (provider.error != null) Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(provider.error!, style: const TextStyle(color: AppColors.warning, fontSize: 12))),
            Expanded(
              child: provider.isLoading
                  ? const ShimmerListPlaceholder(itemCount: 8, itemHeight: 64)
                  : provider.filteredCurrencies.isEmpty
                      ? const EmptyStateWidget(title: 'No currencies found', subtitle: 'Try a different search term.', icon: Icons.search_off_rounded)
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 4, bottom: 12),
                          itemCount: provider.filteredCurrencies.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, i) {
                            final c = provider.filteredCurrencies[i];
                            return Material(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => CurrencyDetailScreen(currency: c)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: CircleAvatar(
                                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                      child: Text(c.symbol, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                                    ),
                                    title: Text(c.code, style: const TextStyle(fontWeight: FontWeight.w700)),
                                    subtitle: Text(
                                      c.name,
                                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary),
                                    ),
                                    trailing: Icon(
                                      Icons.chevron_right_rounded,
                                      color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}