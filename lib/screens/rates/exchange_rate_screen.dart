import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/currency_provider.dart';
import '../../providers/exchange_rate_provider.dart';
import '../../widgets/currency_dropdown.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';

/// Full exchange-rate board: pick a base currency and see live rates against
/// every supported currency, matching the "Exchange Rate Information" spec.
class ExchangeRateScreen extends StatefulWidget {
  const ExchangeRateScreen({super.key});

  @override
  State<ExchangeRateScreen> createState() => _ExchangeRateScreenState();
}

class _ExchangeRateScreenState extends State<ExchangeRateScreen> {
  String _base = 'USD';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CurrencyProvider>().loadCurrencies();
      context.read<ExchangeRateProvider>().loadRates(_base);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencies = context.watch<CurrencyProvider>();
    final rates = context.watch<ExchangeRateProvider>();
    final entries = rates.rates.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    return Scaffold(
      appBar: AppBar(title: const Text('Exchange Rates')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text('Base currency', style: TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  CurrencyDropdown(
                    selectedCode: _base,
                    currencies: currencies.currencies,
                    onChanged: (code) {
                      setState(() => _base = code);
                      context.read<ExchangeRateProvider>().loadRates(code);
                    },
                  ),
                ],
              ),
            ),
            if (rates.lastUpdated != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('Updated ${TimeOfDay.fromDateTime(rates.lastUpdated!).format(context)}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ),
            Expanded(
              child: rates.isLoading
                  ? const Padding(padding: EdgeInsets.all(20), child: ShimmerListPlaceholder(itemCount: 10, itemHeight: 56))
                  : rates.error != null
                      ? AppErrorWidget(message: rates.error!, onRetry: () => context.read<ExchangeRateProvider>().loadRates(_base))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: entries.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, i) {
                            final e = entries[i];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w700)),
                              trailing: Text(e.value.toStringAsFixed(4), style: const TextStyle(fontWeight: FontWeight.w600)),
                              onTap: () => Navigator.of(context).pushNamed(
                                AppRoutes.historicalRate,
                                arguments: {'base': _base, 'target': e.key},
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
