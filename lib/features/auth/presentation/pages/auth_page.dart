import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String _pin = '';
  final int _pinLength = 4; // Tu peux passer à 6 si tu préfères

  void _onDigitPressed(String digit) {
    if (_pin.length < _pinLength) {
      setState(() {
        _pin += digit;
      });

      if (_pin.length == _pinLength) {
        _authenticate();
      }
    }
  }

  void _onDeletePressed() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  void _authenticate() {
    // Simulation d'un petit délai de vérification
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        // Redirection vers le dashboard une fois le code validé
        context.go('/focus'); 
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E3A8A), // Bleu profond
              Color(0xFF0F172A), // Bleu très sombre/noir
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              Text(
                'Life OS',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const Gap(12),
              Text(
                'Touch ID or Enter Passcode',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              
              const Gap(40),
              
              // Indicateurs du PIN
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pinLength, (index) {
                  final isFilled = index < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? Colors.white : Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  );
                }),
              ),
              
              const Spacer(flex: 2),
              
              // Pavé numérique iOS Style
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumpadButton('1'),
                        _buildNumpadButton('2', letters: 'ABC'),
                        _buildNumpadButton('3', letters: 'DEF'),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumpadButton('4', letters: 'GHI'),
                        _buildNumpadButton('5', letters: 'JKL'),
                        _buildNumpadButton('6', letters: 'MNO'),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumpadButton('7', letters: 'PQRS'),
                        _buildNumpadButton('8', letters: 'TUV'),
                        _buildNumpadButton('9', letters: 'WXYZ'),
                      ],
                    ),
                    const Gap(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Bouton invisible pour équilibrer la grille
                        const SizedBox(width: 75, height: 75), 
                        _buildNumpadButton('0'),
                        _buildActionIndicator(),
                      ],
                    ),
                  ],
                ),
              ),
              
              const Spacer(flex: 1),
              
              // Boutons du bas (Emergency / Cancel)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Emergency',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ),
                    TextButton(
                      onPressed: _onDeletePressed,
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumpadButton(String number, {String? letters}) {
    return GestureDetector(
      onTap: () => _onDigitPressed(number),
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1.5,
          ),
          color: Colors.white.withValues(alpha: 0.05), // Léger fond au repos
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w400,
                height: 1.0,
              ),
            ),
            if (letters != null) ...[
              const Gap(2),
              Text(
                letters,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildActionIndicator() {
    return GestureDetector(
      onTap: _onDeletePressed,
      child: SizedBox(
        width: 75,
        height: 75,
        child: Center(
          child: _pin.isNotEmpty
              ? const Icon(Icons.backspace_outlined, color: Colors.white, size: 28)
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
