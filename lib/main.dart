import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/app_theme.dart';
import 'screens/landing_page.dart';
import 'screens/phone_input_screen.dart';
import 'screens/otp_verification_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'screens/main_app_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/appearance_screen.dart';
import 'screens/faq_screen.dart';
import 'screens/hospital_list_screen.dart';
import 'screens/doctor_list_screen.dart';
import 'screens/search_results_screen.dart';

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
        '/settings': (context) => const SettingsScreen(),
        '/appearance': (context) => const AppearanceScreen(),
        '/faqs': (context) => const FAQScreen(),
        '/hospital-list': (context) => const HospitalListScreen(),
        '/doctor-list': (context) => const DoctorListScreen(),
        '/search-results': (context) => const SearchResultsScreen(),
      },
    );
  }
}
