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

    test('maps Aadhaar errors to a friendly prompt', () {
      final payload = {
        'loginId': 'Invalid LoginId',
      };

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(payload),
        'The Aadhaar number you entered appears to be incorrect.\n\nPlease check your 12-digit Aadhaar number and try again.',
      );
    });

    test(
        'maps mobile, OTP, ABHA, address, transaction, face, fingerprint, network, server and unknown errors',
        () {
      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'Invalid Mobile Number'}),
        'The mobile number you entered is invalid.\n\nPlease enter a valid 10-digit mobile number linked to your Aadhaar or ABHA account.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'Mobile number is invalid'}),
        'The mobile number you entered is invalid.\n\nPlease enter a valid 10-digit mobile number linked to your Aadhaar or ABHA account.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'OTP validation failed'}),
        'The OTP you entered is incorrect or has expired.\n\nPlease check the OTP and try again, or request a new OTP.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage({'message': 'Wrong OTP'}),
        'The OTP you entered is incorrect or has expired.\n\nPlease check the OTP and try again, or request a new OTP.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'Invalid ABHA Number'}),
        'The ABHA number you entered is invalid.\n\nPlease check your 14-digit ABHA number and try again.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'ABHA Address already exists'}),
        'This ABHA Address is already in use.\n\nPlease choose another unique ABHA Address.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'Invalid Transaction Id'}),
        'Your session has expired.\n\nPlease start the verification process again.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'Face Verification Failed'}),
        'Face verification could not be completed.\n\nPlease scan your face again and ensure your face is clearly visible.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'Fingerprint Capture Failed'}),
        'Fingerprint capture was unsuccessful.\n\nPlease place your finger properly on the scanner and try again.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'SocketException'}),
        'Unable to connect to the server.\n\nPlease check your internet connection and try again.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'Internal Server Error'}),
        'Something went wrong on the server.\n\nPlease try again after a few moments.',
      );

      expect(
        CommonErrorDialog.extractFriendlyErrorMessage(
            {'message': 'This is completely unexpected'}),
        'Unable to complete your request.\n\nPlease try again or contact your system administrator if the problem continues.',
      );
    });
  });
}
