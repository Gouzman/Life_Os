import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';

/// Simple PIN-based authentication screen.
///
/// For Sprint 4, authentication is local and uses a hardcoded PIN.
/// No credentials leave the device.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  static const _correctPin = '1234';

  final List<String> _digits = [];
  bool _hasError = false;

  void _onDigit(String d) {
    if (_digits.length >= 4) return;
    setState(() {
      _digits.add(d);
      _hasError = false;
    });
    if (_digits.length == 4) _validate();
  }

  void _onDelete() {
    if (_digits.isEmpty) return;
    setState(() {
      _digits.removeLast();
      _hasError = false;
    });
  }

  void _validate() {
    final entered = _digits.join();
    if (entered == _correctPin) {
      context.go('/focus');
    } else {
      setState(() {
        _digits.clear();
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Life OS',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Entrez votre code PIN',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // PIN dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(4, (i) {
                      final filled = i < _digits.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _hasError
                                ? AppColors.danger
                                : filled
                                ? AppColors.primary
                                : AppColors.surfaceHigh,
                            border: Border.all(
                              color: _hasError
                                  ? AppColors.danger
                                  : AppColors.border,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  if (_hasError) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Code incorrect',
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: AppColors.danger),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xxl),

                  // Numeric pad
                  _NumPad(onDigit: _onDigit, onDelete: _onDelete),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Numeric pad ────────────────────────────────────────────────────────────

class _NumPad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;

  const _NumPad({required this.onDigit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', 'del'],
    ];

    return Column(
      children: rows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((key) {
            if (key.isEmpty) return const SizedBox(width: 80, height: 64);
            return _PadKey(
              label: key,
              onTap: key == 'del' ? onDelete : () => onDigit(key),
              isDelete: key == 'del',
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _PadKey extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDelete;

  const _PadKey({
    required this.label,
    required this.onTap,
    this.isDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 64,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Center(
          child: isDelete
              ? const Icon(
                  Icons.backspace_outlined,
                  color: AppColors.textSecondary,
                  size: 22,
                )
              : Text(
                  label,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
