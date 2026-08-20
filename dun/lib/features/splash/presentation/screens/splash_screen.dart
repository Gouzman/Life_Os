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
              Color(0xFF8D55F5),
              Color(0xFFB582F3),
            ],
            stops: [0.0, 0.38, 0.72, 1.0],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final shortestSide = constraints.biggest.shortestSide;

              // Grand logo
              final logoWidth = (shortestSide * 0.48).clamp(
                150.0,
                230.0,
              );

              // Logo + slogan : volontairement plus petit
              final brandWidth = (shortestSide * 0.38).clamp(
                130.0,
                200.0,
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
                      height: shortestSide * 0.045,
                    ),

                    // Image 2 réduite
                    SizedBox(
                      width: brandWidth,
                      height: 50,
                      child: Image.asset(
                        'assets/images/Logo-2.png',
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 16),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'Organisez votre vie, une tâche à la fois.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
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
