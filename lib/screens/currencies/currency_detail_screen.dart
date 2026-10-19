import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_utils.dart';
import '../../models/currency_model.dart';
import '../../providers/exchange_rate_provider.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

class CurrencyDetailScreen extends StatefulWidget {
  final CurrencyModel currency;
  const CurrencyDetailScreen({super.key, required this.currency});

  @override
  State<CurrencyDetailScreen> createState() => _CurrencyDetailScreenState();
}

class _CurrencyDetailScreenState extends State<CurrencyDetailScreen> {
  static const _majors = [
    'USD', 'EUR', 'GBP', 'JPY', 'AUD', 'CAD', 'INR', 'CHF',
    'PKR', 'CNY', 'AED', 'SGD', 'SAR', 'ZAR',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExchangeRateProvider>().loadRates(widget.currency.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rates = context.watch<ExchangeRateProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.currency.code)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(widget.currency.symbol, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                  const SizedBox(height: 14),
                  Text(widget.currency.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Code: ${widget.currency.code}', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Exchange rates vs major currencies', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () => context.read<ExchangeRateProvider>().loadRates(widget.currency.code),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (rates.isLoading)
              const ShimmerListPlaceholder(itemCount: 6, itemHeight: 56)
            else if (rates.error != null)
              AppErrorWidget(message: rates.error!, onRetry: () => context.read<ExchangeRateProvider>().loadRates(widget.currency.code))
            else
              ..._majors.where((c) => c != widget.currency.code).map((code) {
                final r = rates.rateFor(code);
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
                      child: Text(CurrencyUtils.symbolFor(code), style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.w700)),
                    ),
                    title: Text(code, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(CurrencyUtils.nameFor(code)),
                    trailing: Text(
                      r != null ? r.toStringAsFixed(4) : '—',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.historicalRate,
                      arguments: {'base': widget.currency.code, 'target': code},
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}