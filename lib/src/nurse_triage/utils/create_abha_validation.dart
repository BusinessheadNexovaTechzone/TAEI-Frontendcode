class CreateAbhaValidation {
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
