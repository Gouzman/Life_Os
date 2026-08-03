import 'package:dun/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

Future<void> showAppDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'OK',
  VoidCallback? onConfirm,
}) async {
  return showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: context.text.titleLarge),
        content: Text(message, style: context.text.bodyMedium),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
}
