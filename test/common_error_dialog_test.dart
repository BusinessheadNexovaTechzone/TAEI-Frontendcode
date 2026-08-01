import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';

void main() {
  group('CommonErrorDialog backend error extraction', () {
    test('prefers error.message over other fields', () {
      final payload = {
        'error': {
          'code': 'ABDM-1204',
          'message':
              'UIDAI Error code : 998 : Aadhaar number is incorrect. Resident shall use correct Aadhaar.'
        },
        'message': 'Should not show this',
        'loginId': 'Should not show this',
      };

      expect(
        CommonErrorDialog.extractErrorMessage(payload),
        'UIDAI Error code : 998 : Aadhaar number is incorrect. Resident shall use correct Aadhaar.',
      );
    });

    test('falls back to message, loginId, mobile, and finally any field', () {
      expect(
        CommonErrorDialog.extractErrorMessage({
          'message':
              'Please enter a valid OTP. Entered OTP is either expired or incorrect.'
        }),
        'Please enter a valid OTP. Entered OTP is either expired or incorrect.',
      );

      expect(
        CommonErrorDialog.extractErrorMessage(
            {'loginId': 'Please enter a valid 12-digit Aadhaar number'}),
        'Please enter a valid 12-digit Aadhaar number',
      );

      expect(
        CommonErrorDialog.extractErrorMessage(
            {'mobile': 'Invalid Mobile Number'}),
        'Invalid Mobile Number',
      );

      expect(
        CommonErrorDialog.extractErrorMessage({'detail': 'Something failed'}),
        'Something failed',
      );
    });

    test('maps invalid loginId Aadhaar backend payload to friendly user prompt',
        () {
      final payload = {
        'loginId': 'Invalid LoginId',
      };

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(payload),
        'Please enter a valid 12-digit Aadhaar number.',
      );
    });
  });
}
