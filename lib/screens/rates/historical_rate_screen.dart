import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/exchange_rate_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';

class HistoricalRateScreen extends StatefulWidget {
  final String base;
  final String target;
  const HistoricalRateScreen({super.key, required this.base, required this.target});

  @override
  State<HistoricalRateScreen> createState() => _HistoricalRateScreenState();
}

class _HistoricalRateScreenState extends State<HistoricalRateScreen> {
  int _days = 30;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    context.read<ExchangeRateProvider>().loadHistory(widget.base, widget.target, days: _days);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExchangeRateProvider>();
    final points = provider.history;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.base} → ${widget.target}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.base} to ${widget.target} trend',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              const Text('Historical exchange rate movement', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [7, 30, 90].map((d) {
                  final selected = _days == d;
                  return ChoiceChip(
                    label: Text('$d D'),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _days = d);
                      _load();
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
                    backgroundColor: Theme.of(context).cardColor,
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: provider.historyLoading
                    ? const LoadingWidget(message: 'Loading historical data…')
                    : points.isEmpty
                        ? const EmptyStateWidget(
                            title: 'No historical data',
                            subtitle: 'Try a different currency pair or time range.',
                            icon: Icons.show_chart_rounded,
                          )
                        : _Chart(points: points, target: widget.target),
              ),
              if (points.isNotEmpty) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _StatTile(label: 'Lowest', value: points.map((p) => p.rate).reduce((a, b) => a < b ? a : b)),
                    _StatTile(label: 'Highest', value: points.map((p) => p.rate).reduce((a, b) => a > b ? a : b)),
                    _StatTile(label: 'Latest', value: points.last.rate),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final double value;
  const _StatTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value.toStringAsFixed(4), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  final List<dynamic> points;
  final String target;
  const _Chart({required this.points, required this.target});

  @override
  Widget build(BuildContext context) {
    final spots = <FlSpot>[
      for (int i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].rate as double),
    ];
    final minY = points.map((p) => p.rate as double).reduce((a, b) => a < b ? a : b);
    final maxY = points.map((p) => p.rate as double).reduce((a, b) => a > b ? a : b);
    final pad = (maxY - minY) * 0.15 + 0.0001;

    return LineChart(
      LineChartData(
        minY: minY - pad,
        maxY: maxY + pad,
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: const FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 46)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.12)),
          ),
        ],
      ),
    );
  }
}
