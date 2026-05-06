import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../core/api_service.dart';
import '../core/session_store.dart';
import '../widgets/auth_header.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  String _phoneNumber = "";
  bool _isValid = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_checkValidity);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is String) {
      _phoneNumber = args;
    }
  }

  void _checkValidity() {
    final otp = _controllers.map((c) => c.text).join();
    final isValidValue = otp.length == 6;
    if (_isValid != isValidValue) {
      setState(() {
        _isValid = isValidValue;
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.removeListener(_checkValidity);
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOTPChanged(String value, int index) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty) {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _verifyOTP() async {
    if (_isValid && SessionStore.otpToken != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final otp = _controllers.map((c) => c.text).join();
      final response = await ApiService.verifyOtp(otp, SessionStore.otpToken!);

      setState(() {
        _isLoading = false;
      });

      if (response['status'] == 'OK') {
        if (!mounted) return;
        Navigator.pushNamed(context, '/profile-setup');
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'Invalid OTP';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmWhite,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const AuthHeader(
              title: 'Enter OTP',
              subtitle: 'We sent a code to your phone',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  const Text(
                    'OTP Verification',
                    style: TextStyle(
                      color: AppColors.brownDeep,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter the code sent to\n+91-$_phoneNumber',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.brownMid.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 48,
                        height: 56,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brownDeep,
                          ),
                          onChanged: (value) => _onOTPChanged(value, index),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: AppColors.cream,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.surface,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: AppColors.accent,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '02:32',
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: AppColors.brownMid,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(text: "I didn't receive any code. "),
                        TextSpan(
                          text: 'RESEND',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ],
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (_isValid && !_isLoading) ? _verifyOTP : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (_isValid && !_isLoading) 
                          ? AppColors.accent 
                          : AppColors.accent.withOpacity(0.5),
                        disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: (_isValid && !_isLoading) ? 4 : 0,
                      ),
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Submit',
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
