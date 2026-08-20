import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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

              // Logo principal.
              final logoWidth = (shortestSide * 0.48).clamp(
                150.0,
                230.0,
              );

              // Logo-2 plus petit pour limiter le flou.
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
                    Image.asset(
                      'assets/images/Logo-1.png',
                      width: logoWidth,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(
                      height: shortestSide * 0.035,
                    ),

                    Image.asset(
                      'assets/images/Logo-2.png',
                      width: brandWidth,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.symmetric(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
