int? extractAbhaProfileId(Map<String, dynamic>? response) {
  if (response == null) return null;

  int? walk(Object? node, {bool inProfileContext = false}) {
    if (node is Map) {
      final keys = node.keys.map((key) => key.toString().toLowerCase()).toList();
      final hasProfileContext = inProfileContext ||
          keys.any((key) => key.contains('profile') || key.contains('abha'));

      for (final entry in node.entries) {
        final key = entry.key.toString().toLowerCase();
        final value = entry.value;

        final keyLooksLikeProfileId = key == 'profileid' ||
            key == 'abhaprofileid' ||
            key == 'abha_profile_id' ||
            key == 'profile_id';

        if (keyLooksLikeProfileId) {
          final parsed = int.tryParse(value?.toString() ?? '');
          if (parsed != null) return parsed;
        }

        final keyLooksLikeNestedId = key == 'id' && hasProfileContext;
        if (keyLooksLikeNestedId) {
          final parsed = int.tryParse(value?.toString() ?? '');
          if (parsed != null) return parsed;
        }

        final nestedResult = walk(
          value,
          inProfileContext: hasProfileContext || key.contains('profile') || key.contains('abha'),
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
