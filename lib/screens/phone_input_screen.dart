import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/session_store.dart';
import '../core/api_service.dart';
import '../widgets/auth_header.dart';
import '../services/auth_service.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;
  bool _isValid = false;
  bool _isLoading = false;
  bool _isLogin = false;

  @override
  void initState() {
    super.initState();
    _firstNameController.addListener(_checkValidity);
    _lastNameController.addListener(_checkValidity);
    _phoneController.addListener(_checkValidity);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _isLogin = args['isLogin'] as bool? ?? false;
      SessionStore.currentAuthFlow = _isLogin ? AuthFlow.login : AuthFlow.signup;
      _checkValidity();
    }
  }

  void _checkValidity() {
    final phoneText = _phoneController.text.trim();
    final phoneValid = phoneText.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phoneText);
    final nameValid = _isLogin ||
        (_firstNameController.text.trim().isNotEmpty && _lastNameController.text.trim().isNotEmpty);
    final isValidValue = phoneValid && nameValid;
    if (_isValid != isValidValue) {
      setState(() {
        _isValid = isValidValue;
      });
    }
  }

  Future<void> _validateAndSendOTP() async {
    if (!_isValid) {
      setState(() {
        _errorMessage = _isLogin
            ? 'Please enter a valid 10-digit mobile number.'
            : 'Please fill in your name and a valid 10-digit mobile number';
      });
      return;
    }

    final phoneNumber = '+91${_phoneController.text.trim()}';
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    SessionStore.clearAuthAttempt();

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        final result = await AuthService.loginInitiate(phoneNumber: phoneNumber);
        if (result.success && mounted) {
          Navigator.pushNamed(context, '/otp-verification');
        } else {
          setState(() {
            _errorMessage = result.message;
            _isLoading = false;
          });
        }
      } else {
        final result = await AuthService.signupInitiate(
          phoneNumber: phoneNumber,
          firstName: firstName,
          lastName: lastName,
        );
        if (result.success && mounted) {
          Navigator.pushNamed(context, '/otp-verification');
        } else {
          setState(() {
            _errorMessage = result.message;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to authenticate. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_checkValidity);
    _lastNameController.removeListener(_checkValidity);
    _phoneController.removeListener(_checkValidity);
    _firstNameController.dispose();
    _lastNameController.dispose();
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
            AuthHeader(
              title: _isLogin ? 'Login with OTP' : 'Create your account',
              subtitle: _isLogin ? 'Enter your registered phone number' : "Tell us who you are and we'll send a code",
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!_isLogin) ...[
                    const Text(
                      'First Name',
                      style: TextStyle(
                        color: AppColors.brownMid,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _firstNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Enter first name',
                        hintStyle: const TextStyle(color: Colors.black26),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        filled: true,
                        fillColor: AppColors.cream,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.surface),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.surface),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.accent, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Last Name',
                      style: TextStyle(
                        color: AppColors.brownMid,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _lastNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Enter last name',
                        hintStyle: const TextStyle(color: Colors.black26),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                        filled: true,
                        fillColor: AppColors.cream,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.surface),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.surface),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: AppColors.accent, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      color: AppColors.brownMid,
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
                      fillColor: AppColors.cream,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.surface),
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
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isValid && !_isLoading ? _validateAndSendOTP : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isValid
                            ? AppColors.accent
                            : AppColors.accent.withOpacity(0.5),
                        disabledBackgroundColor: AppColors.accent.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: _isValid ? 4 : 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              _isLogin ? 'Login with OTP' : 'Send OTP',
                              style: const TextStyle(
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
