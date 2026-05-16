import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../core/session_store.dart';
import '../services/auth_service.dart';
import '../widgets/auth_header.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (index) => FocusNode());
  String _phoneNumber = "";
  bool _isValid = false;
  bool _isLoading = false;
  String? _statusMessage;
  bool _statusIsError = true;
  bool _isLogin = false;

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
    _phoneNumber = SessionStore.phoneNumber.replaceFirst('+91', '').trim();
    _isLogin = SessionStore.currentAuthFlow == AuthFlow.login;
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

  Future<void> _verifyOTP() async {
    if (!_isValid) {
      setState(() {
        _statusMessage = 'Enter the 6-digit code sent to your phone';
        _statusIsError = true;
      });
      return;
    }

    final otp = _controllers.map((c) => c.text).join();

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    final result = await AuthService.verifyOtp(otp: otp);

    if (!mounted) {
      return;
    }

    if (result.success) {
      if (_isLogin) {
        Navigator.pushNamedAndRemoveUntil(context, '/main-app', (route) => false);
      } else {
        Navigator.pushNamed(context, '/profile-setup');
      }
      return;
    }

    setState(() {
      _statusMessage = result.message;
      _statusIsError = true;
      _isLoading = false;
    });
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    final result = await AuthService.resendOtp();

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
      _statusMessage = result.message;
      _statusIsError = !result.success;
    });
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
                  if (_statusMessage != null) ...[
                    Text(
                      _statusMessage!,
                      style: TextStyle(
                        color: _statusIsError ? Colors.redAccent : Colors.green,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "I didn't receive any code.",
                        style: TextStyle(
                          color: AppColors.brownMid,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _isLoading ? null : _resendOtp,
                        child: Text(
                          'RESEND',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: _isLoading
                                ? AppColors.brownMid.withOpacity(0.5)
                                : AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isValid && !_isLoading ? _verifyOTP : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isValid ? AppColors.accent : AppColors.accent.withOpacity(0.5),
                        disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: (_isValid && !_isLoading) ? 4 : 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
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
