import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/currency_utils.dart';
import '../models/currency_model.dart';

class CurrencyDropdown extends StatelessWidget {
  final String selectedCode;
  final List<CurrencyModel> currencies;
  final ValueChanged<String> onChanged;
  final bool light;

  const CurrencyDropdown({
    super.key,
    required this.selectedCode,
    required this.currencies,
    required this.onChanged,
    this.light = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = light ? Colors.white : Theme.of(context).colorScheme.onSurface;
    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: light ? Colors.white.withValues(alpha: 0.16) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: light ? null : Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: light ? Colors.white.withValues(alpha: 0.25) : AppColors.primary.withValues(alpha: 0.1),
              child: Text(
                CurrencyUtils.symbolFor(selectedCode),
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
              ),
            ),
            const SizedBox(width: 8),
            Text(selectedCode, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: fg)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, color: fg),
          ],
        ),
      ),
    );
  }

  void _openPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        String query = '';
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final filtered = currencies
                .where((c) =>
                    query.isEmpty ||
                    c.code.toLowerCase().contains(query.toLowerCase()) ||
                    c.name.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              minChildSize: 0.5,
              maxChildSize: 0.92,
              expand: false,
              builder: (ctx, scrollController) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(height: 4, width: 42, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(height: 16),
                      Text('Select currency', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      TextField(
                        autofocus: false,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search currency or code',
                        ),
                        onChanged: (v) => setModalState(() => query = v),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (ctx, i) {
                            final c = filtered[i];
                            final selected = c.code == selectedCode;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                child: Text(c.symbol, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary)),
                              ),
                              title: Text(c.code, style: const TextStyle(fontWeight: FontWeight.w700)),
                              subtitle: Text(c.name),
                              trailing: selected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                              onTap: () {
                                onChanged(c.code);
                                Navigator.pop(ctx);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
