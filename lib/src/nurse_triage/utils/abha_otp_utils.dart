int? extractAbhaProfileId(Map<String, dynamic>? response) {
  final candidates = <Object?>[
    response?['profileId'],
    response?['data']?['profileId'],
    response?['result']?['profileId'],
    response?['result']?['ABHAProfile']?['profileId'],
    response?['result']?['ABHAProfile']?['id'],
    response?['result']?['id'],
    response?['abhaProfileId'],
    response?['data']?['abhaProfileId'],
    response?['result']?['abhaProfileId'],
    response?['ABHAProfileId'],
    response?['result']?['ABHAProfileId'],
  ];

  for (final candidate in candidates) {
    if (candidate == null) continue;
    final parsed = int.tryParse(candidate.toString());
    if (parsed != null) {
      return parsed;
    }
  }

  return null;
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
