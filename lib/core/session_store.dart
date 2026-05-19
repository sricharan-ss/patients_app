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
  static String emergencyContact = '';
  static String? age;
  static String gender = '';
  static String bloodGroup = '';
  static List<String> chronicConditions = <String>[];
  static String? patientId;
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

    final first = _readString(userData['firstName']);
    final last = _readString(userData['lastName']);
    final directEmail = _readString(userData['email']);
    final directEmergencyContact = _readString(userData['emergencyContact']);
    final directAge = _readString(userData['age']);
    final directGender = _readString(userData['gender']);
    final directBloodGroup = _readString(userData['bloodGroup']);
    final directPatientId = _readString(userData['patientId']);
    final directConditions = _readStringList(userData['chronicConditions']);

    if (first.isNotEmpty) {
      firstName = first;
    }
    if (last.isNotEmpty) {
      lastName = last;
    }
    if (directEmail.isNotEmpty) {
      email = directEmail;
    }
    if (directEmergencyContact.isNotEmpty) {
      emergencyContact = directEmergencyContact;
    }
    if (directAge.isNotEmpty) {
      age = directAge;
    }
    if (directGender.isNotEmpty) {
      gender = directGender;
    }
    if (directBloodGroup.isNotEmpty) {
      bloodGroup = directBloodGroup;
    }
    if (directPatientId.isNotEmpty) {
      patientId = directPatientId;
    }
    if (directConditions.isNotEmpty) {
      chronicConditions = directConditions;
    }
  }

  static bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;

  static String get fullName {
    final direct = '$firstName $lastName'.trim();
    if (direct.isNotEmpty) {
      return direct;
    }
    final userData = registeredUsers[phoneNumber];
    final fallbackFirst = _readString(userData?['firstName']);
    final fallbackLast = _readString(userData?['lastName']);
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

  static String get ageLabel {
    final storedAge = age?.trim() ?? '';
    if (storedAge.isNotEmpty) {
      return storedAge;
    }
    final userData = registeredUsers[phoneNumber];
    return _readString(userData?['age']);
  }

  static String get genderLabel {
    final storedGender = gender.trim();
    if (storedGender.isNotEmpty) {
      return storedGender;
    }
    final userData = registeredUsers[phoneNumber];
    return _readString(userData?['gender']);
  }

  static String get bloodGroupLabel {
    final storedBloodGroup = bloodGroup.trim();
    if (storedBloodGroup.isNotEmpty) {
      return storedBloodGroup;
    }
    final userData = registeredUsers[phoneNumber];
    return _readString(userData?['bloodGroup']);
  }

  static List<String> get chronicConditionsLabel {
    if (chronicConditions.isNotEmpty) {
      return List<String>.from(chronicConditions);
    }
    final userData = registeredUsers[phoneNumber];
    final values = userData?['chronicConditions'];
    if (values is List) {
      return values.whereType<String>().where((value) => value.trim().isNotEmpty).toList();
    }
    return <String>[];
  }

  static String _readString(dynamic value) {
    if (value is String) {
      return value.trim();
    }
    return '';
  }

  static List<String> _readStringList(dynamic value) {
    if (value is List) {
      return value.whereType<String>().map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
    }
    return <String>[];
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
    emergencyContact = '';
    age = null;
    gender = '';
    bloodGroup = '';
    chronicConditions = <String>[];
    patientId = null;
    clearAuthAttempt();
  }
}
