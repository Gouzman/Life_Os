import 'package:dun/features/auth/presentation/controllers/auth_controller.dart';
import 'package:dun/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _contentAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _contentAnimation = Tween<Offset>(
      begin: const Offset(0, 0.035),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    await ref
        .read(authControllerProvider.notifier)
        .signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState is AuthLoading;

    ref.listen(authControllerProvider, (previous, next) {
      if (next is AuthFailureState && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;

            // ----------------------------------------------------------
            // DESIGN DE RÉFÉRENCE
            //
            // Capture originale :
            // 393 x 852
            //
            // Toutes les proportions sont calculées à partir
            // de cette référence afin de garder le même rendu
            // sur différentes tailles d'écran.
            // ----------------------------------------------------------

            const referenceWidth = 393.0;
            const referenceHeight = 852.0;

            final scale = (screenWidth / referenceWidth)
                .clamp(0.85, 1.25);

            final designWidth = referenceWidth * scale;

            final contentWidth = designWidth > 520
                ? 520.0
                : designWidth;

            return Center(
              child: SizedBox(
                width: contentWidth,
                height: screenHeight,
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: [
                    // ==================================================
                    // GRAND LOGO FANTÔME — HAUT
                    // ==================================================
                    Positioned(
                      top: -72 * scale,
                      left: -52 * scale,
                      child: Opacity(
                        opacity: 0.035,
                        child: Image.asset(
                          'assets/images/Logo-1.png',
                          width: 455 * scale,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // ==================================================
                    // GRAND LOGO FANTÔME — BAS
                    // ==================================================
                    Positioned(
                      bottom: -125 * scale,
                      right: -72 * scale,
                      child: Opacity(
                        opacity: 0.028,
                        child: Image.asset(
                          'assets/images/Logo-1.png',
                          width: 430 * scale,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // ==================================================
                    // CONTENU
                    // ==================================================
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _contentAnimation,
                        child: Stack(
                          children: [
                            // ------------------------------------------
                            // LOGO DUN
                            // ------------------------------------------
                            Positioned(
                              top: 136 * scale,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Image.asset(
                                  'assets/images/Logo-2.png',
                                  width: 141 * scale,
                                  height: 60 * scale,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // ------------------------------------------
                            // TITRE
                            // ------------------------------------------
                            Positioned(
                              top: 345 * scale,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Bienvenue',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                          height: 1.0,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF7136F5),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' sur DUN',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 30,
                                          height: 1.0,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF7136F5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // ------------------------------------------
                            // DESCRIPTION
                            // ------------------------------------------
                            Positioned(
                              top: 408 * scale,
                              left: 24 * scale,
                              right: 24 * scale,
                              child: Text(
                                'Organisez votre vie simplement.\n'
                                'Commencez sans créer de compte et\n'
                                'construisez progressivement votre espace\n'
                                'personnel.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14 * scale,
                                  height: 1.6,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFAAA6AC),
                                ),
                              ),
                            ),

                            // ------------------------------------------
                            // BOUTON
                            // ------------------------------------------
                            Positioned(
                              top: 541 * scale,
                              left: 32 * scale,
                              right: 32 * scale,
                              child: SizedBox(
                                height: 59 * scale,
                                child: ElevatedButton(
                                  onPressed:
                                      isLoading ? null : _continue,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF7836FC),
                                    disabledBackgroundColor:
                                        const Color(0xFFBDA7F0),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        16 * scale,
                                      ),
                                    ),
                                  ),
                                  child: isLoading
                                      ? SizedBox(
                                          width: 23 * scale,
                                          height: 23 * scale,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'Commencer',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18 * scale,
                                            height: 1.0,
                                            fontWeight:
                                                FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            // ------------------------------------------
                            // CONFIDENTIALITÉ
                            // ------------------------------------------
                            Positioned(
                              top: 618 * scale,
                              left: 32 * scale,
                              right: 32 * scale,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.lock_outline_rounded,
                                    size: 17 * scale,
                                    color:
                                        const Color(0xFFB9B5BA),
                                  ),
                                  SizedBox(
                                    width: 7 * scale,
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Vos données restent privées et sécurisées.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11.5 * scale,
                                        height: 1.0,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(
                                          0xFFB1ADB2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
