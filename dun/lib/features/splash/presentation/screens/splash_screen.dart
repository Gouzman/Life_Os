import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _brandController;

  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  late final Animation<double> _brandOpacity;
  late final Animation<Offset> _brandSlide;

  @override
  void initState() {
    super.initState();

    // Animation du logo principal.
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(
        0.0,
        0.65,
        curve: Curves.easeOut,
      ),
    );

    _logoScale = Tween<double>(
      begin: 0.82,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutBack,
      ),
    );

    // Animation du logo + slogan.
    _brandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _brandOpacity = CurvedAnimation(
      parent: _brandController,
      curve: Curves.easeOut,
    );

    _brandSlide = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _brandController,
        curve: Curves.easeOutCubic,
      ),
    );

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(
      const Duration(milliseconds: 150),
    );

    if (!mounted) return;

    await _logoController.forward();

    if (!mounted) return;

    await Future.delayed(
      const Duration(milliseconds: 100),
    );

    if (!mounted) return;

    await _brandController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _brandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.05),
            radius: 1.15,
            colors: [
              Color(0xFF5B16FF),
              Color(0xFF712DFF),
              Color(0xFF9658F5),
              Color(0xFFB982F0),
            ],
            stops: [
              0.0,
              0.38,
              0.72,
              1.0,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final shortestSide =
                  constraints.biggest.shortestSide;

              final logoWidth = (shortestSide * 0.48).clamp(
                150.0,
                230.0,
              );

              final brandWidth = (shortestSide * 0.25).clamp(
                90.0,
                125.0,
              );

              final taglineFontSize =
                  (shortestSide * 0.035).clamp(
                12.0,
                15.0,
              );

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // -------------------------------------------------
                    // LOGO PRINCIPAL
                    // -------------------------------------------------
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: Image.asset(
                          'assets/images/Logo-1.png',
                          width: logoWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: shortestSide * 0.035,
                    ),

                    // -------------------------------------------------
                    // LOGO + SLOGAN
                    // -------------------------------------------------
                    FadeTransition(
                      opacity: _brandOpacity,
                      child: SlideTransition(
                        position: _brandSlide,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/Logo-2.png',
                              width: brandWidth,
                              fit: BoxFit.contain,
                            ),

                            const SizedBox(height: 12),

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Text(
                                'Organistion - Education - Planification',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: taglineFontSize,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
