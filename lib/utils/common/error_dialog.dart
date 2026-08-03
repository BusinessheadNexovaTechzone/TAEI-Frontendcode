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
    // Priority-based extraction: return backend message exactly as received.
    if (payload == null) return '';

    // If payload is a Map, inspect keys in the requested priority.
    if (payload is Map) {
      final map = Map<String, dynamic>.from(payload);

      // 1) error.message
      final nestedError = map['error'];
      if (nestedError != null) {
        if (nestedError is Map) {
          final nestedMessage = _stringFrom(nestedError['message']);
          if (nestedMessage.isNotEmpty) return nestedMessage;
        }
        // if error is a plain string
        final nestedAsString = _stringFrom(nestedError);
        if (nestedAsString.isNotEmpty) return nestedAsString;
      }

      // 2) message
      final message = _stringFrom(map['message']);
      if (message.isNotEmpty) return message;

      // 3) loginId
      final loginId = _stringFrom(map['loginId']);
      if (loginId.isNotEmpty) return loginId;

      // 4) mobile
      final mobile = _stringFrom(map['mobile']);
      if (mobile.isNotEmpty) return mobile;
    }

    // 5) Fallback: return the first meaningful string found anywhere in the payload.
    return extractErrorMessage(payload);
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
