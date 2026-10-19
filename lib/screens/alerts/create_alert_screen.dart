import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../models/rate_alert_model.dart';
import '../../providers/alert_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/currency_provider.dart';
import '../../widgets/currency_dropdown.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class CreateAlertScreen extends StatefulWidget {
  const CreateAlertScreen({super.key});

  @override
  State<CreateAlertScreen> createState() => _CreateAlertScreenState();
}

class _CreateAlertScreenState extends State<CreateAlertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _thresholdController = TextEditingController();
  String _base = 'USD';
  String _target = 'EUR';
  AlertCondition _condition = AlertCondition.above;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<CurrencyProvider>().loadCurrencies());
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;
    setState(() => _saving = true);
    await context.read<AlertProvider>().createAlert(
          RateAlertModel(
            userId: userId,
            baseCurrency: _base,
            targetCurrency: _target,
            threshold: double.parse(_thresholdController.text),
            condition: _condition,
          ),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currencies = context.watch<CurrencyProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('New rate alert')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Currency pair', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: CurrencyDropdown(selectedCode: _base, currencies: currencies.currencies, onChanged: (v) => setState(() => _base = v))),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Icon(Icons.arrow_forward_rounded)),
                    Expanded(child: CurrencyDropdown(selectedCode: _target, currencies: currencies.currencies, onChanged: (v) => setState(() => _target = v))),
                  ],
                ),
                const SizedBox(height: 24),
                const Text('Notify me when the rate is', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Above'),
                        selected: _condition == AlertCondition.above,
                        onSelected: (_) => setState(() => _condition = AlertCondition.above),
                        selectedColor: AppColors.success,
                        labelStyle: TextStyle(color: _condition == AlertCondition.above ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Below'),
                        selected: _condition == AlertCondition.below,
                        onSelected: (_) => setState(() => _condition = AlertCondition.below),
                        selectedColor: AppColors.danger,
                        labelStyle: TextStyle(color: _condition == AlertCondition.below ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  controller: _thresholdController,
                  label: 'Target rate',
                  hint: 'e.g. 1.0950',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  prefixIcon: Icons.flag_outlined,
                  validator: Validators.amount,
                ),
                const SizedBox(height: 32),
                CustomButton(label: 'Create alert', isLoading: _saving, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
