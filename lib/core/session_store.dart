enum AuthFlow {
  signup,
  login,
}

class SessionStore {
  const SessionStore._();

  static String phoneNumber = '+910000000000';
  static String firstName = '';
  static String lastName = '';
  static String email = '';
  static String? verificationToken;
  static String? devOtp;
  static String? accessToken;
  static AuthFlow currentAuthFlow = AuthFlow.signup;

  static final Set<String> registeredPhones = <String>{};
  static final Map<String, Map<String, dynamic>> registeredUsers = <String, Map<String, dynamic>>{};

  static bool isPhoneRegistered(String phone) => registeredPhones.contains(phone);

  static void reservePhone(String phone) {
    registeredPhones.add(phone);
  }

  static void registerUser(String phone, Map<String, dynamic> userData) {
    registeredPhones.add(phone);
    registeredUsers[phone] = userData;
  }

  static bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;

  static String get fullName {
    final direct = '$firstName $lastName'.trim();
    if (direct.isNotEmpty) {
      return direct;
    }
    final userData = registeredUsers[phoneNumber];
    final fallbackFirst = (userData?['firstName'] as String?)?.trim() ?? '';
    final fallbackLast = (userData?['lastName'] as String?)?.trim() ?? '';
    final fallback = '$fallbackFirst $fallbackLast'.trim();
    if (fallback.isNotEmpty) {
      return fallback;
    }
    return 'User';
  }

  static String get profileInitial {
    final name = fullName.trim();
    if (name.isEmpty || name.toLowerCase() == 'user') {
      return 'U';
    }
    return name[0].toUpperCase();
  }

  static void clearAuthAttempt() {
    verificationToken = null;
    devOtp = null;
    currentAuthFlow = AuthFlow.signup;
  }

  static void logout() {
    accessToken = null;
    phoneNumber = '+910000000000';
    firstName = '';
    lastName = '';
    email = '';
    clearAuthAttempt();
  }
}
