import 'package:dun/core/extensions/build_context_x.dart';
import 'package:dun/features/auth/presentation/controllers/auth_controller.dart';
import 'package:dun/features/auth/presentation/providers/auth_provider.dart';
import 'package:dun/shared/buttons/app_button.dart';
import 'package:dun/shared/loaders/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AuthFailureState) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: context.pagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenue sur Life OS',
                textAlign: TextAlign.center,
                style: context.text.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                'Commencez anonymement. Vos données restent sécurisées.',
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 48),
              if (state is AuthLoading)
                const AppLoader()
              else
                AppButton(
                  label: 'Continuer anonymement',
                  onPressed: () {
                    ref
                        .read(authControllerProvider.notifier)
                        .signInAnonymously();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
