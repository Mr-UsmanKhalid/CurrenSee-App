import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/conversion_provider.dart';
import '../../providers/currency_provider.dart';
import '../../providers/exchange_rate_provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';
import '../../widgets/currency_dropdown.dart';
import '../../widgets/error_widget.dart';
import '../notifications/notifications_screen.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _amountController = TextEditingController(text: '100');
  String _from = 'USD';
  String _to = 'EUR';
  double? _convertedAmount;
  double? _rate;
  bool _converting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = context.read<AuthProvider>();
      _from = auth.user?.defaultCurrency ?? 'USD';
      await context.read<CurrencyProvider>().loadCurrencies();
      await _refreshRates();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _refreshRates() async {
    await context.read<ExchangeRateProvider>().loadRates(_from);
    _recalculate();
  }

  void _recalculate() {
    final rates = context.read<ExchangeRateProvider>();
    final rate = _from == _to ? 1.0 : rates.rateFor(_to);
    final amount = double.tryParse(_amountController.text) ?? 0;
    setState(() {
      _rate = rate;
      _convertedAmount = rate != null ? amount * rate : null;
    });
  }

  void _swap() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
    });
    _refreshRates();
  }

  Future<void> _saveConversion() async {
    final auth = context.read<AuthProvider>();
    final userId = auth.user?.id;
    if (userId == null || _rate == null) return;
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    setState(() => _converting = true);
    await context.read<ConversionProvider>().recordConversion(
          userId: userId,
          fromCurrency: _from,
          toCurrency: _to,
          amount: amount,
          convertedAmount: amount * _rate!,
          rate: _rate!,
        );

    await context.read<NotificationProvider>().addNotification(
          NotificationModel(
            userId: userId,
            title: 'Conversion saved',
            message:
                '${CurrencyUtils.formatWithSymbol(amount, _from)} $_from → ${CurrencyUtils.formatWithSymbol(amount * _rate!, _to)} $_to',
            type: 'system',
          ),
        );

    if (!mounted) return;
    setState(() => _converting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Conversion saved to history')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = context.watch<CurrencyProvider>();
    final rateProvider = context.watch<ExchangeRateProvider>();
    final notifications = context.watch<NotificationProvider>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshRates,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Convert',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Live exchange rates',
                        style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none_rounded),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                        ),
                      ),
                      if (notifications.unreadCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),
                            constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                            child: Text(
                              '${notifications.unreadCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: Theme.of(context).brightness == Brightness.dark ? AppColors.primaryGradient : AppColors.primaryGradient,
                  border: Theme.of(context).brightness == Brightness.dark
                      ? Border.all(color: Colors.white.withValues(alpha: 0.06))
                      : null,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 19, 78, 79).withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('YOU SEND', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                        CurrencyDropdown(
                          selectedCode: _from,
                          currencies: currencyProvider.currencies,
                          light: true,
                          onChanged: (code) {
                            setState(() => _from = code);
                            _refreshRates();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Theme(
                      data: Theme.of(context).copyWith(
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: Colors.white,
                          selectionColor: Colors.white.withValues(alpha: 0.35),
                          selectionHandleColor: Colors.white,
                        ),
                      ),
                      child:
TextField(
                      controller: _amountController,
                      cursorColor: Colors.white,
                      cursorWidth: 2.5,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700),
                      decoration: const InputDecoration(
                        filled: false,
                        fillColor: Colors.transparent,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (_) => _recalculate(),
                    ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.25), height: 1)),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: _swap,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), shape: BoxShape.circle),
                            child: const Icon(Icons.swap_vert_rounded, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.25), height: 1)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('YOU GET', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 0.5, fontWeight: FontWeight.w600)),
                        CurrencyDropdown(
                          selectedCode: _to,
                          currencies: currencyProvider.currencies,
                          light: true,
                          onChanged: (code) {
                            setState(() => _to = code);
                            _recalculate();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _convertedAmount != null ? CurrencyUtils.formatAmount(_convertedAmount!) : '—',
                      style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (rateProvider.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: AppErrorWidget(message: rateProvider.error!, onRetry: _refreshRates),
                )
              else if (_rate != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.trending_up_rounded, color: AppColors.secondary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '1 $_from = ${CurrencyUtils.formatAmount(_rate!, decimals: 4)} $_to',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (rateProvider.isLoading)
                        const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              Text(
                'Quick actions',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickAction(
                      icon: _converting ? null : Icons.bookmark_add_outlined,
                      loading: _converting,
                      label: 'Save',
                      color: AppColors.primary,
                      onTap: (_rate == null || _converting) ? null : _saveConversion,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.show_chart_rounded,
                      label: 'Trends',
                      color: AppColors.secondary,
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.historicalRate,
                        arguments: {'base': _from, 'target': _to},
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.list_alt_rounded,
                      label: 'Browse',
                      color: AppColors.warning,
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.currencyList),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickAction(
                      icon: Icons.refresh_rounded,
                      label: 'Refresh',
                      color: AppColors.danger,
                      onTap: _refreshRates,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData? icon;
  final bool loading;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickAction({
    this.icon,
    this.loading = false,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Column(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: loading
                    ? SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: color),
                      )
                    : Icon(icon, color: color, size: 22),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}