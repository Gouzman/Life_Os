import 'package:dun/app/providers/global_providers.dart';
import 'package:dun/core/extensions/build_context_x.dart';
import 'package:dun/shared/buttons/app_button.dart';
import 'package:dun/shared/inputs/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PinLoginScreen extends ConsumerStatefulWidget {
  const PinLoginScreen({super.key});

  @override
  ConsumerState<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends ConsumerState<PinLoginScreen> {
  final _pinController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _validatePin() async {
    final pin = _pinController.text.trim();
    final isValid = await ref.read(pinServiceProvider).validatePin(pin);

    if (isValid && mounted) {
      context.go('/dashboard');
    } else {
      setState(() => _error = 'PIN incorrect.');
    }
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
              Text('Entrez votre PIN', style: context.text.headlineMedium),
              const SizedBox(height: 24),
              AppTextField(
                controller: _pinController,
                hintText: 'PIN',
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
              AppButton(label: 'Déverrouiller', onPressed: _validatePin),
            ],
          ),
        ),
      ),
    );
  }
}
