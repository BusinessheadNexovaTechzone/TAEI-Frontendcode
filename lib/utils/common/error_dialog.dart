import 'package:flutter/material.dart';

class CommonErrorDialog {
  static String extractErrorMessage(dynamic payload) {
    if (payload == null) {
      return '';
    }

    if (payload is String) {
      return payload.trim();
    }

    if (payload is List) {
      for (final item in payload) {
        final message = extractErrorMessage(item);
        if (message.isNotEmpty) {
          return message;
        }
      }
      return '';
    }

    if (payload is Map) {
      final map = Map<String, dynamic>.from(payload);

      final nestedError = map['error'];
      if (nestedError != null) {
        final nestedMessage = extractErrorMessage(nestedError);
        if (nestedMessage.isNotEmpty) {
          return nestedMessage;
        }
      }

      final message = _stringFrom(map['message']);
      if (message.isNotEmpty) {
        return message;
      }

      final loginId = _stringFrom(map['loginId']);
      if (loginId.isNotEmpty) {
        return loginId;
      }

      final mobile = _stringFrom(map['mobile']);
      if (mobile.isNotEmpty) {
        return mobile;
      }

      for (final entry in map.entries) {
        final key = entry.key.toString().toLowerCase();
        if (key == 'error' ||
            key == 'message' ||
            key == 'loginid' ||
            key == 'mobile' ||
            key == 'status' ||
            key == 'success' ||
            key == 'code' ||
            key == 'txnid' ||
            key == 'data') {
          continue;
        }

        final nested = extractErrorMessage(entry.value);
        if (nested.isNotEmpty) {
          return nested;
        }
      }
    }

    return '';
  }

  static String extractFriendlyErrorMessage(dynamic payload) {
    final rawMessage = _extractRawErrorText(payload);
    if (rawMessage.isEmpty) {
      return _defaultFriendlyMessage();
    }

    final normalized = rawMessage.toLowerCase();

    if (_containsAny(normalized, [
      'invalid loginid',
      'invalid aadhaar',
      'aadhaar number incorrect',
      'aadhaar number is incorrect',
      'uidai error code : 998',
      'uidai error 998',
      'aadhaar validation failed',
      'loginid is invalid',
      'invalid aadhaar number',
      'resident shall use correct aadhaar',
      'aadhaar incorrect',
    ])) {
      return _aadhaarFriendlyMessage();
    }

    if (_containsAny(normalized, [
      'invalid mobile number',
      'mobile number is invalid',
      'invalid mobile no',
      'mobile invalid',
      'mobile validation failed',
      'mobile required',
      'invalid mobile',
      'mobile is invalid',
    ])) {
      return _mobileFriendlyMessage();
    }

    if (_containsAny(normalized, [
          'otp validation failed',
          'invalid otp',
          'otp incorrect',
          'incorrect otp',
          'wrong otp',
          'otp expired',
          'uidai otp failed',
          'otp mismatch',
          'otp invalid',
          'otp is expired',
        ]) ||
        (normalized.contains('otp') &&
            (normalized.contains('expired') ||
                normalized.contains('incorrect') ||
                normalized.contains('wrong') ||
                normalized.contains('mismatch') ||
                normalized.contains('invalid') ||
                normalized.contains('failed')))) {
      return _otpFriendlyMessage();
    }

    if (_containsAny(normalized, [
      'invalid abha number',
      'abha validation failed',
      'abha number incorrect',
      'abha number invalid',
    ])) {
      return _abhaNumberFriendlyMessage();
    }

    if (_containsAny(normalized, [
      'abha address already exists',
      'preferred address already exists',
      'unique address required',
      'address already exists',
    ])) {
      return _abhaAddressFriendlyMessage();
    }

    if (_containsAny(normalized, [
      'invalid transaction id',
      'transaction expired',
      'txn invalid',
      'txn not found',
      'transaction id',
    ])) {
      return _transactionFriendlyMessage();
    }

    if (_containsAny(normalized, [
      'face authentication failed',
      'face scan failed',
      'face verification failed',
      'face verification',
    ])) {
      return _faceFriendlyMessage();
    }

    if (_containsAny(normalized, [
      'fingerprint capture failed',
      'pid missing',
      'capture error',
      'device error',
      'rd service error',
      'fingerprint',
    ])) {
      return _fingerprintFriendlyMessage();
    }

    if (_containsAny(normalized, [
      'timeout',
      'socketexception',
      'network error',
      'connection refused',
      'unable to connect',
      'no internet',
    ])) {
      return _networkFriendlyMessage();
    }

    if (_containsAny(normalized, [
      '500',
      'internal server error',
      'unexpected error',
      'service unavailable',
      'server error',
    ])) {
      return _serverFriendlyMessage();
    }

    return _defaultFriendlyMessage();
  }

  static String _extractRawErrorText(dynamic payload) {
    if (payload == null) {
      return '';
    }

    if (payload is String) {
      return payload.trim();
    }

    if (payload is List) {
      for (final item in payload) {
        final message = _extractRawErrorText(item);
        if (message.isNotEmpty) {
          return message;
        }
      }
      return '';
    }

    if (payload is Map) {
      final map = Map<String, dynamic>.from(payload);

      final nestedError = map['error'];
      if (nestedError != null) {
        final nestedMessage = _extractRawErrorText(nestedError);
        if (nestedMessage.isNotEmpty) {
          return nestedMessage;
        }
      }

      for (final key in [
        'message',
        'loginId',
        'loginid',
        'mobile',
        'detail',
        'error'
      ]) {
        final value = _stringFrom(map[key]);
        if (value.isNotEmpty) {
          return value;
        }
      }

      for (final entry in map.entries) {
        final nested = _extractRawErrorText(entry.value);
        if (nested.isNotEmpty) {
          return nested;
        }
      }
    }

    return _stringFrom(payload);
  }

  static bool _containsAny(String value, List<String> terms) {
    return terms.any(value.contains);
  }

  static String _aadhaarFriendlyMessage() {
    return 'The Aadhaar number you entered appears to be incorrect.\n\nPlease check your 12-digit Aadhaar number and try again.';
  }

  static String _mobileFriendlyMessage() {
    return 'The mobile number you entered is invalid.\n\nPlease enter a valid 10-digit mobile number linked to your Aadhaar or ABHA account.';
  }

  static String _otpFriendlyMessage() {
    return 'The OTP you entered is incorrect or has expired.\n\nPlease check the OTP and try again, or request a new OTP.';
  }

  static String _abhaNumberFriendlyMessage() {
    return 'The ABHA number you entered is invalid.\n\nPlease check your 14-digit ABHA number and try again.';
  }

  static String _abhaAddressFriendlyMessage() {
    return 'This ABHA Address is already in use.\n\nPlease choose another unique ABHA Address.';
  }

  static String _transactionFriendlyMessage() {
    return 'Your session has expired.\n\nPlease start the verification process again.';
  }

  static String _faceFriendlyMessage() {
    return 'Face verification could not be completed.\n\nPlease scan your face again and ensure your face is clearly visible.';
  }

  static String _fingerprintFriendlyMessage() {
    return 'Fingerprint capture was unsuccessful.\n\nPlease place your finger properly on the scanner and try again.';
  }

  static String _networkFriendlyMessage() {
    return 'Unable to connect to the server.\n\nPlease check your internet connection and try again.';
  }

  static String _serverFriendlyMessage() {
    return 'Something went wrong on the server.\n\nPlease try again after a few moments.';
  }

  static String _defaultFriendlyMessage() {
    return 'Unable to complete your request.\n\nPlease try again or contact your system administrator if the problem continues.';
  }

  static String _stringFrom(Object? value) {
    if (value == null) {
      return '';
    }
    return value.toString().trim();
  }

  static Future<void> show(
    BuildContext context, {
    String title = 'Unable to Continue',
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (dialogContext) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          titlePadding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 360,
              minWidth: 300,
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.visible,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.3,
              ),
            ),
          ),
          actions: [
            SizedBox(
              width: 88,
              child: ElevatedButton(
                onPressed: onPressed ??
                    () {
                      Navigator.of(dialogContext).pop();
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(buttonText),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  static Future<void> showFromResponse(
    BuildContext context, {
    required dynamic response,
    String title = 'Unable to Continue',
    String buttonText = 'OK',
    bool barrierDismissible = false,
  }) {
    final extractedMessage = extractFriendlyErrorMessage(response);
    return show(
      context,
      title: title,
      message: extractedMessage.isNotEmpty
          ? extractedMessage
          : CommonErrorDialog._defaultFriendlyMessage(),
      buttonText: buttonText,
      barrierDismissible: barrierDismissible,
    );
  }
}
