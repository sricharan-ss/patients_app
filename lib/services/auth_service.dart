import 'dart:convert';

import '../core/backend_config.dart';
import '../core/session_store.dart';

class AuthService {
  static String get _effectiveBaseUrl => BackendConfig.baseUrl;

  static Uri _uri(String path) => Uri.parse('$_effectiveBaseUrl$path');

  static Future<SignupInitResult> signupInitiate({
    required String phoneNumber,
    required String firstName,
    required String lastName,
  }) async {
    SessionStore.currentAuthFlow = AuthFlow.signup;
    SessionStore.phoneNumber = phoneNumber;
    SessionStore.firstName = firstName;
    SessionStore.lastName = lastName;

    final response = await _postWithFallback(
      paths: const ['/api/auth/user'],
      payload: {
        'phoneNumber': phoneNumber,
        'firstName': firstName,
        'lastName': lastName,
      },
    );

    if (response.networkError != null) {
      return SignupInitResult.failure(response.networkError!);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final verificationToken = _readString(response.decoded, 'token');
      if (verificationToken != null && verificationToken.isNotEmpty) {
        SessionStore.verificationToken = verificationToken;
        final backendMessage = _readString(response.decoded, 'message') ??
            'OTP sent to your phone.';
        return SignupInitResult.success(
          message: backendMessage,
          verificationToken: verificationToken,
        );
      }
      return SignupInitResult.failure('No verification token received');
    }

    return SignupInitResult.failure(
      _readString(response.decoded, 'message') ?? 'Unable to create account',
    );
  }

  static Future<LoginInitResult> loginInitiate({
    required String phoneNumber,
  }) async {
    SessionStore.currentAuthFlow = AuthFlow.login;
    SessionStore.phoneNumber = phoneNumber;

    final response = await _postWithFallback(
      paths: const ['/api/auth/login/phone', '/api/auth/user'],
      payload: {
        'phoneNumber': phoneNumber,
      },
    );

    if (response.networkError != null) {
      return LoginInitResult.failure(response.networkError!);
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      final verificationToken = _readString(response.decoded, 'token');
      if (verificationToken != null && verificationToken.isNotEmpty) {
        SessionStore.verificationToken = verificationToken;
        return LoginInitResult.success(
          message:
              _readString(response.decoded, 'message') ?? 'OTP sent to your phone.',
          verificationToken: verificationToken,
        );
      }
      return LoginInitResult.failure('No verification token received');
    }

    return LoginInitResult.failure(
      _readString(response.decoded, 'message') ?? 'Unable to log in',
    );
  }

  static Future<AuthResult> verifyOtp({
    required String otp,
  }) async {
    final token = SessionStore.verificationToken;
    if (token == null || token.isEmpty) {
      return AuthResult.failure('No verification token. Please try again.');
    }

    final candidatePaths = SessionStore.currentAuthFlow == AuthFlow.signup
        ? const [
            '/api/auth/verify-otp',
            '/api/auth/verify-otp-temp',
            '/api/auth/login/phone/verify',
          ]
        : const [
            '/api/auth/login/phone/verify',
            '/api/auth/verify-otp',
          ];

    final response = await _postWithFallback(
      paths: candidatePaths,
      payload: {'otp': otp},
      bearerToken: token,
      retryOnNotFound: true,
    );

    if (response.networkError != null) {
      return AuthResult.failure(response.networkError!);
    }

    if (response.statusCode == 200) {
      final accessToken = _readString(response.decoded, 'accessToken');
      if (accessToken != null && accessToken.isNotEmpty) {
        SessionStore.accessToken = accessToken;
        SessionStore.registerUser(SessionStore.phoneNumber, {
          'firstName': SessionStore.firstName,
          'lastName': SessionStore.lastName,
        });
        SessionStore.verificationToken = null;
        return AuthResult.success(
          message: _readString(response.decoded, 'message') ?? 'Authentication successful',
        );
      }
      return AuthResult.failure('No access token received');
    }

    if (response.statusCode == 404) {
      return AuthResult.failure(
        'OTP verification route is not available in backend. Please verify auth routes in backend.',
      );
    }

    final message =
        _readString(response.decoded, 'message') ?? 'OTP verification failed';
    if (SessionStore.currentAuthFlow == AuthFlow.signup &&
        message.toLowerCase().contains('token corrupted')) {
      return AuthResult.failure(
        'Signup OTP verification is not enabled in backend routes. Please ask backend to add /api/auth/verify-otp.',
      );
    }

    return AuthResult.failure(
      message,
    );
  }

  static Future<AuthResult> resendOtp() async {
    if (SessionStore.phoneNumber.trim().isEmpty) {
      return AuthResult.failure('Phone number is missing. Please start again.');
    }

    if (SessionStore.currentAuthFlow == AuthFlow.login) {
      final loginResult = await loginInitiate(phoneNumber: SessionStore.phoneNumber);
      if (loginResult.success) {
        return AuthResult.success(message: loginResult.message);
      }
      return AuthResult.failure(loginResult.message);
    }

    final firstName = SessionStore.firstName.trim();
    final lastName = SessionStore.lastName.trim();
    if (firstName.isEmpty || lastName.isEmpty) {
      return AuthResult.failure('Name details are missing. Please restart signup.');
    }

    final signupResult = await signupInitiate(
      phoneNumber: SessionStore.phoneNumber,
      firstName: firstName,
      lastName: lastName,
    );
    if (signupResult.success) {
      return AuthResult.success(message: signupResult.message);
    }
    return AuthResult.failure(signupResult.message);
  }

  static Future<_BackendResponse> _postWithFallback({
    required List<String> paths,
    required Map<String, dynamic> payload,
    String? bearerToken,
    bool retryOnNotFound = false,
  }) async {
    for (var index = 0; index < paths.length; index++) {
      final path = paths[index];
      final response = await _post(path, payload, bearerToken: bearerToken);
      if (!retryOnNotFound || response.statusCode != 404 || index == paths.length - 1) {
        return response;
      }
    }

    return _BackendResponse(
      statusCode: 500,
      decoded: const <String, dynamic>{},
      networkError: 'Unable to process request.',
    );
  }

  static Future<_BackendResponse> _post(
    String path,
    Map<String, dynamic> payload, {
    String? bearerToken,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(_uri(path));
      request.headers.contentType = ContentType.json;
      if (bearerToken != null && bearerToken.isNotEmpty) {
        request.headers.set('Authorization', 'Bearer $bearerToken');
      }
      request.write(jsonEncode(payload));

      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      final decoded = _decodeMap(body);
      return _BackendResponse(
        statusCode: response.statusCode,
        decoded: decoded,
      );
    } on SocketException {
      return _BackendResponse(
        statusCode: 0,
        decoded: const <String, dynamic>{},
        networkError:
            'Unable to reach backend at $_effectiveBaseUrl. Make sure the server is running.',
      );
    } catch (_) {
      return _BackendResponse(
        statusCode: 0,
        decoded: const <String, dynamic>{},
        networkError: 'Unexpected error while calling backend.',
      );
    } finally {
      client.close(force: true);
    }
  }

  static Map<String, dynamic> _decodeMap(String body) {
    if (body.isEmpty) {
      return <String, dynamic>{};
    }
    final parsed = jsonDecode(body);
    if (parsed is Map<String, dynamic>) {
      return parsed;
    }
    return <String, dynamic>{};
  }

  static String? _readString(Map<String, dynamic> decoded, String key) {
    final value = decoded[key];
    if (value is String) {
      return value;
    }
    return null;
  }

  static Future<bool> refreshToken() async {
    return SessionStore.accessToken != null;
  }

  static void logout() {
    SessionStore.logout();
  }
}

class _BackendResponse {
  final int statusCode;
  final Map<String, dynamic> decoded;
  final String? networkError;

  const _BackendResponse({
    required this.statusCode,
    required this.decoded,
    this.networkError,
  });
}

class AuthResult {
  final bool success;
  final String message;

  AuthResult._({required this.success, required this.message});

  factory AuthResult.success({required String message}) {
    return AuthResult._(success: true, message: message);
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(success: false, message: message);
  }
}

class SignupInitResult {
  final bool success;
  final String message;
  final String? verificationToken;

  SignupInitResult._({
    required this.success,
    required this.message,
    this.verificationToken,
  });

  factory SignupInitResult.success({
    required String message,
    required String verificationToken,
  }) {
    return SignupInitResult._(
      success: true,
      message: message,
      verificationToken: verificationToken,
    );
  }

  factory SignupInitResult.failure(String message) {
    return SignupInitResult._(success: false, message: message);
  }
}

class LoginInitResult {
  final bool success;
  final String message;
  final String? verificationToken;

  LoginInitResult._({
    required this.success,
    required this.message,
    this.verificationToken,
  });

  factory LoginInitResult.success({
    required String message,
    required String verificationToken,
  }) {
    return LoginInitResult._(
      success: true,
      message: message,
      verificationToken: verificationToken,
    );
  }

  factory LoginInitResult.failure(String message) {
    return LoginInitResult._(success: false, message: message);
  }
}

