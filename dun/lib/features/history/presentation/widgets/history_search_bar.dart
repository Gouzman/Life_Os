import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_x.dart';

class HistorySearchBar extends StatelessWidget {
  const HistorySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: "Rechercher dans l'historique...",
        prefixIcon: Icon(
          Icons.search_outlined,
          color: context.colors.onSurfaceVariant,
        ),
        filled: true,
        fillColor: context.colors.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        hintStyle: TextStyle(color: context.colors.onSurfaceVariant),
      ),
    );
  }
}
