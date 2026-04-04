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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const LandingPage());
          case '/phone-input':
            return MaterialPageRoute(builder: (_) => const PhoneInputScreen());
          case '/otp-verification':
            return MaterialPageRoute(builder: (_) => const OTPVerificationScreen());
          case '/profile-setup':
            return MaterialPageRoute(builder: (_) => const ProfileSetupScreen());
          case '/main-app':
            return MaterialPageRoute(builder: (_) => const MainAppScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/appearance':
            return MaterialPageRoute(builder: (_) => const AppearanceScreen());
          case '/faqs':
            return MaterialPageRoute(builder: (_) => const FAQScreen());
          case '/hospital-list':
            final args = settings.arguments as Map<String, dynamic>?;
            final nearbyOnly = args?['nearbyOnly'] as bool? ?? false;
            return MaterialPageRoute(
              builder: (_) => HospitalListScreen(nearbyOnly: nearbyOnly),
            );
          case '/doctor-list':
            final args = settings.arguments as Map<String, dynamic>?;
            final searchQuery = args?['searchQuery'] as String?;
            return MaterialPageRoute(
              builder: (_) => DoctorListScreen(initialSearchQuery: searchQuery),
            );
          case '/search-results':
            return MaterialPageRoute(builder: (_) => const SearchResultsScreen());
          default:
            return MaterialPageRoute(builder: (_) => const LandingPage());
        }
      },
    );
  }
}
