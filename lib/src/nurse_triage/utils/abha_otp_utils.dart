int? extractAbhaProfileId(Map<String, dynamic>? response) {
  if (response == null) return null;

  bool looksLikeProfileContext(String key) {
    final lowered = key.toLowerCase();
    return lowered.contains('profile') ||
        lowered.contains('abha') ||
        lowered.contains('healthid') ||
        lowered.contains('account');
  }

  int? parseProfileIdValue(Object? value) {
    if (value == null) return null;
    if (value is int) return value > 0 ? value : null;
    if (value is num) return value.toInt() > 0 ? value.toInt() : null;
    if (value is String) {
      final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isEmpty) return null;
      final parsed = int.tryParse(digits);
      return parsed != null && parsed > 0 ? parsed : null;
    }
    return null;
  }

  int? walk(Object? node, {bool inProfileContext = false}) {
    if (node is Map) {
      final keys = node.keys.map((key) => key.toString().toLowerCase()).toList();
      final hasProfileContext = inProfileContext ||
          keys.any(looksLikeProfileContext);

      for (final entry in node.entries) {
        final key = entry.key.toString().toLowerCase();
        final value = entry.value;

        final keyLooksLikeProfileId = const {
          'profileid',
          'abhaprofileid',
          'abha_profile_id',
          'profile_id',
          'profileidnumber',
          'profileidno',
          'abhaid',
          'abha_id',
          'abhaidnumber',
          'abha_profileid',
          'profileidvalue',
          'profileidval',
        }.contains(key);

        if (keyLooksLikeProfileId) {
          final parsed = parseProfileIdValue(value);
          if (parsed != null) return parsed;
        }

        final keyLooksLikeNestedId =
            const {'id', 'profileid', 'profile_id'}.contains(key) &&
                (hasProfileContext || looksLikeProfileContext(key));
        if (keyLooksLikeNestedId) {
          final parsed = parseProfileIdValue(value);
          if (parsed != null) return parsed;
        }

        final nestedResult = walk(
          value,
          inProfileContext: hasProfileContext || looksLikeProfileContext(key),
        );
        if (nestedResult != null) return nestedResult;
      }
      return null;
    }

    if (node is List) {
      for (final item in node) {
        final result = walk(item, inProfileContext: inProfileContext);
        if (result != null) return result;
      }
    }

    return null;
  }

  return walk(response);
}

bool isExistingAbhaAccountResponse(Map<String, dynamic> response) {
  bool indicatesExistingAccount(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('account already exist') ||
        normalized.contains('abha profile already exist') ||
        normalized.contains('abha already exist') ||
        normalized.contains('health id already exist') ||
        normalized.contains('already registered');
  }

  bool visit(Object? value) {
    if (value is Map) {
      for (final entry in value.entries) {
        final key = entry.key
            .toString()
            .toLowerCase()
            .replaceAll('_', '')
            .replaceAll('-', '');
        if (key == 'isnew' &&
            entry.value?.toString().trim().toLowerCase() == 'false') {
          return true;
        }
        if (key == 'message' &&
            entry.value is String &&
            indicatesExistingAccount(entry.value as String)) {
          return true;
        }
        if (visit(entry.value)) return true;
      }
    } else if (value is List) {
      for (final item in value) {
        if (visit(item)) return true;
      }
    }

    return false;
  }

  return visit(response);
}

String buildMobileOtpFailureMessage(dynamic payload) {
  final rawMessage = payload?.toString().toLowerCase() ?? '';

  if (rawMessage.contains('expired') || rawMessage.contains('transaction')) {
    return 'This OTP has expired.\n\nPlease request a new OTP.';
  }

  if (rawMessage.contains('otp') || rawMessage.contains('incorrect')) {
    return 'The mobile verification OTP is incorrect.\n\nPlease check the OTP and try again.';
  }

  return 'We couldn\'t verify your mobile number.\n\nPlease try again.';
}
