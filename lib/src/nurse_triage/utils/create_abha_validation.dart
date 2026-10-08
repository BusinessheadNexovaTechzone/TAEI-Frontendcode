class CreateAbhaValidation {
  static const String abhaAddressUsernameGuidance =
      '• Length: 8 to 18 characters.\n'
      '• Use only letters and numbers, with no spaces.\n'
      '• You may use at most one dot (.) and at most one underscore (_).\n'
      '• A dot or underscore must be between characters, not at the beginning or end.\n'
      'For suggested addresses, these rules apply to the username before @.';

  static String? validateAbhaAddressUsername(String value) {
    if (value.isEmpty) return 'Please enter an ABHA Address.';
    if (value != value.trim() || value.contains(RegExp(r'\s'))) {
      return 'Spaces are not allowed in an ABHA Address.';
    }

    final separatorIndex = value.indexOf('@');
    if (separatorIndex != value.lastIndexOf('@')) {
      return 'Please enter a valid ABHA Address.';
    }
    final username =
        separatorIndex < 0 ? value : value.substring(0, separatorIndex);
    if (separatorIndex >= 0 && separatorIndex == value.length - 1) {
      return 'Please enter a valid ABHA Address.';
    }

    if (username.length < 8 || username.length > 18) {
      return 'ABHA Address username must contain 8 to 18 characters.';
    }
    if (!RegExp(r'^[A-Za-z0-9._]+$').hasMatch(username)) {
      return 'Use only letters, numbers, one dot (.) and/or one underscore (_).';
    }
    if (username.startsWith('.') || username.startsWith('_')) {
      return 'A dot or underscore cannot be the first character.';
    }
    if (username.endsWith('.') || username.endsWith('_')) {
      return 'A dot or underscore cannot be the last character.';
    }
    if ('.'.allMatches(username).length > 1 ||
        '_'.allMatches(username).length > 1) {
      return 'Use at most one dot (.) and at most one underscore (_).';
    }
    return null;
  }

  static String? validateAadhaar(
    String? value, {
    required bool shouldShowError,
  }) {
    if (!shouldShowError) {
      return null;
    }

    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.length != 12) {
      return 'Aadhaar Number must contain exactly 12 digits.';
    }
    return null;
  }

  static String? validateConsent(
    bool consentAccepted, {
    required bool shouldShowError,
  }) {
    if (!shouldShowError) {
      return null;
    }
    if (!consentAccepted) {
      return 'Please accept the Terms and Conditions.';
    }
    return null;
  }

  static String? validateAuthMethod(
    String? value, {
    required bool shouldShowError,
  }) {
    if (!shouldShowError) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Please select an authentication method.';
    }
    return null;
  }

  static String? validateCaptcha(
    String? value, {
    required bool shouldShowError,
    required String expectedAnswer,
  }) {
    if (!shouldShowError) {
      return null;
    }

    final answer = (value ?? '').trim();
    if (answer.isEmpty) {
      return 'Answer is required.';
    }
    if (expectedAnswer.isNotEmpty && answer != expectedAnswer) {
      return 'Please enter the correct captcha answer.';
    }
    return null;
  }

  static String? validateOtp(
    String value, {
    required bool shouldShowError,
  }) {
    if (!shouldShowError) {
      return null;
    }

    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 6) {
      return 'OTP must contain exactly 6 digits.';
    }
    return null;
  }

  static String? validateMobile(
    String? value, {
    required bool shouldShowError,
  }) {
    if (!shouldShowError) {
      return null;
    }

    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.length != 10) {
      return 'Mobile Number must contain exactly 10 digits.';
    }
    return null;
  }
}
