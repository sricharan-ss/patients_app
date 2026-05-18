enum AuthFlow {
  signup,
  login,
}

class SessionStore {
  const SessionStore._();

  static String phoneNumber = '+910000000000';
  static String firstName = '';
  static String lastName = '';
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
    clearAuthAttempt();
  }
}
