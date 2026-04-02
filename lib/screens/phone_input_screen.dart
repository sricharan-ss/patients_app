import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/auth_header.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_checkValidity);
  }

  void _checkValidity() {
    final text = _phoneController.text.trim();
    final isValidValue = text.length == 10 && RegExp(r'^[0-9]+$').hasMatch(text);
    if (_isValid != isValidValue) {
      setState(() {
        _isValid = isValidValue;
      });
    }
  }

  void _validateAndSendOTP() {
    if (_isValid) {
      setState(() {
        _errorMessage = null;
      });
      Navigator.pushNamed(
        context,
        '/otp-verification',
        arguments: _phoneController.text.trim(),
      );
    } else {
      setState(() {
        _errorMessage = 'Please enter a valid 10-digit mobile number';
      });
    }
  }

  @override
  void dispose() {
    _phoneController.removeListener(_checkValidity);
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(
              title: 'Enter your mobile number',
              subtitle: "We'll send you a verification code",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      color: AppColors.brownMid, // Using specified BrownMid for labels
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: '+91-9790939361',
                      hintStyle: const TextStyle(color: Colors.black26),
                      counterText: "",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      filled: true,
                      fillColor: AppColors.cream, // Specification: Color(0xFFFBF6EC)
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.surface), // Specification: Color(0xFFEFE2CC)
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.surface),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.accent, width: 2),
                      ),
                      errorText: _errorMessage,
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isValid ? _validateAndSendOTP : null, // Disable until valid
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isValid 
                          ? AppColors.accent 
                          : AppColors.accent.withOpacity(0.5), // Lighter until 10 digits
                        disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: _isValid ? 4 : 0,
                      ),
                      child: const Text(
                        'Send OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
