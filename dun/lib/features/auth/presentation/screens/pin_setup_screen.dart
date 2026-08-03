import 'package:dun/app/providers/global_providers.dart';
import 'package:dun/core/extensions/build_context_x.dart';
import 'package:dun/shared/buttons/app_button.dart';
import 'package:dun/shared/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _savePin() async {
    final pin = _pinController.text.trim();
    final confirm = _confirmController.text.trim();

    if (pin.length < 4) {
      setState(() => _error = 'Le PIN doit contenir au moins 4 chiffres.');
      return;
    }

    if (pin != confirm) {
      setState(() => _error = 'Les PIN ne correspondent pas.');
      return;
    }

    await ref.read(pinServiceProvider).setPin(pin);
    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: context.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Créez un PIN', style: context.text.headlineMedium),
              const SizedBox(height: 24),
              AppTextField(
                controller: _pinController,
                hintText: 'Nouveau PIN',
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _confirmController,
                hintText: 'Confirmez le PIN',
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              AppButton(label: 'Enregistrer', onPressed: _savePin),
            ],
          ),
        ),
      ),
    );
  }
}
