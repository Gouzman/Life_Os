import 'package:flutter/material.dart';

import '../../../../../core/extensions/build_context_x.dart';
import '../../../../../shared/buttons/app_button.dart';
import '../controllers/focus_mode_controller.dart';

/// Barre de contrôles du Focus Mode.
///
/// Affiche les boutons d'action adaptés à l'état courant. Toutes les actions
/// sont déléguées via les callbacks fournis. Ce widget ne contient aucune
/// logique métier.
class FocusControls extends StatelessWidget {
  const FocusControls({
    super.key,
    required this.state,
    required this.onStart,
    required this.onPause,
    required this.onResume,
    required this.onComplete,
    required this.onCancel,
  });

  final FocusModeState state;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPrimaryButton(context),
        const SizedBox(height: 12),
        _buildSecondaryButton(context),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return switch (state) {
      FocusModeIdle() => AppButton(
        label: 'Démarrer',
        onPressed: onStart,
        icon: const Icon(Icons.play_arrow_rounded),
      ),
      FocusModeRunning() => AppButton(
        label: 'Pause',
        onPressed: onPause,
        icon: const Icon(Icons.pause_rounded),
      ),
      FocusModePaused() => AppButton(
        label: 'Reprendre',
        onPressed: onResume,
        icon: const Icon(Icons.play_arrow_rounded),
      ),
      FocusModeCompleted() => AppButton(label: 'Terminé', onPressed: null),
      FocusModeCancelled() => AppButton(
        label: 'Annulé',
        onPressed: onStart,
        icon: const Icon(Icons.play_arrow_rounded),
      ),
      FocusModeError() => AppButton(
        label: 'Réessayer',
        onPressed: onStart,
        icon: const Icon(Icons.play_arrow_rounded),
      ),
    };
  }

  Widget _buildSecondaryButton(BuildContext context) {
    final isActive = state is FocusModeRunning || state is FocusModePaused;

    if (!isActive) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Terminer',
            isOutlined: true,
            onPressed: onComplete,
            icon: Icon(Icons.check_rounded, color: context.colors.primary),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppButton(
            label: 'Annuler',
            isOutlined: true,
            onPressed: onCancel,
            icon: Icon(Icons.close_rounded, color: context.colors.primary),
          ),
        ),
      ],
    );
  }
}
