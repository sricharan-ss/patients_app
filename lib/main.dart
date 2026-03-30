import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const VitaDataApp());
}

class VitaDataApp extends StatelessWidget {
  const VitaDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VITADATA',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _AppColors.brownDeep,
          brightness: Brightness.light,
        ),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [_AppColors.brownDeep, _AppColors.brownMid],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 28),
                  Image.asset(
                    'assets/images/onlyicon.png',
                    height: 145,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 30),
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'VITADATA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _AppColors.warmWhite,
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your health, digitally organize',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _AppColors.mutedCream,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const _FeatureIconsCluster(),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _AppColors.cream,
                        foregroundColor: _AppColors.brownDeep,
                        elevation: 4,
                        shadowColor: Colors.black38,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: _AppColors.cream,
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationColor: _AppColors.cream,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureIconsCluster extends StatelessWidget {
  const _FeatureIconsCluster();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 165,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 30,
            top: 0,
            child: _IconBadge(
              icon: Icons.health_and_safety_outlined,
              color: _AppColors.cream,
              size: 56,
            ),
          ),
          Positioned(
            right: 32,
            top: 2,
            child: Transform.rotate(
              angle: math.pi / 12,
              child: const _IconBadge(
                icon: Icons.medical_services_outlined,
                color: _AppColors.accent,
                size: 54,
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 3,
            child: const _IconBadge(
              icon: Icons.notification_important_outlined,
              color: _AppColors.accentSoft,
              size: 47,
            ),
          ),
          Positioned(
            right: 38,
            bottom: 0,
            child: Transform.rotate(
              angle: -math.pi / 13,
              child: const _IconBadge(
                icon: Icons.monitor_heart_outlined,
                color: _AppColors.accentSoft,
                size: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color, size: size);
  }
}

class _AppColors {
  const _AppColors._();

  static const brownDeep = Color(0xFF3B1F0A);
  static const brownMid = Color(0xFF6B3A1F);
  static const accent = Color(0xFFD4822A);
  static const accentSoft = Color(0xFFC48743);
  static const cream = Color(0xFFF3E9DB);
  static const mutedCream = Color(0xFFE2CDB6);
  static const warmWhite = Color(0xFFFFFDF8);
}
