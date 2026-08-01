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
    final rawMessage = extractErrorMessage(payload);
    final lower = rawMessage.toLowerCase();

    if (lower.contains('invalid loginid') ||
        lower.contains('loginid') &&
            (lower.contains('invalid') || lower.contains('incorrect'))) {
      return 'Please enter a valid 12-digit Aadhaar number.';
    }

    if (lower.contains('invalid mobile number') ||
        lower.contains('invalid mobile')) {
      return 'Please enter a valid 10-digit mobile number.';
    }

    if (lower.contains('otp validation failed') ||
        (lower.contains('uidai error code') && lower.contains('otp'))) {
      return 'OTP verification failed. Please enter the correct OTP and try again.';
    }

    if (lower.contains('expired') ||
        lower.contains('otp is either expired or incorrect') ||
        lower.contains('expired or incorrect')) {
      return 'Your OTP has expired. Please request a new OTP and try again.';
    }

    if (lower.contains('aadhaar number is incorrect') ||
        lower.contains('invalid aadhaar') ||
        lower.contains('aadhaar validation') ||
        lower.contains('aadhaar number is invalid')) {
      return 'Please enter a valid 12-digit Aadhaar number.';
    }

    if (lower.contains('abha address already exists') ||
        lower.contains('unique abha address') ||
        lower.contains('already exists')) {
      return 'This ABHA Address is already in use. Please choose another ABHA Address or create a unique custom ABHA Address.';
    }

    return rawMessage;
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
          : response?.toString() ?? '',
      buttonText: buttonText,
      barrierDismissible: barrierDismissible,
    );
  }
}
