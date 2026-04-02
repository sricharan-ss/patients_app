import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_theme.dart';
import 'screens/landing_page.dart';
import 'screens/phone_input_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/main_app_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const VitaDataApp());
}

class VitaDataApp extends StatelessWidget {
  const VitaDataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VITADATA',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/phone-input': (context) => const PhoneInputScreen(),
        '/otp-verification': (context) => const OTPVerificationScreen(),
        '/profile-setup': (context) => const ProfileSetupScreen(),
        '/main-app': (context) => const MainAppScreen(),
      },
    );
  }
}
