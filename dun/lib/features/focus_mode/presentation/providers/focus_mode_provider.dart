import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/focus_mode_controller.dart';

export '../controllers/focus_mode_controller.dart' show FocusModeState;

/// Fournit le [FocusModeController] pour une tâche identifiée par son [taskId].
///
/// Le contrôleur enrichit l'état d'[ExecutionController] avec les données
/// temps réel de l'[ExecutionTimer] (temps écoulé, restant, progression).
///
/// Il est marqué [autoDispose] afin que les ressources (timer, abonnements)
/// soient libérées naturellement lorsque l'écran Focus Mode est fermé.
final focusModeControllerProvider = NotifierProvider.autoDispose
    .family<FocusModeController, FocusModeState, String>(
      (taskId) => FocusModeController(taskId: taskId),
    );
