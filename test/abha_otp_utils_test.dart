import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_otp_utils.dart';

void main() {
  group('existing ABHA account detection', () {
    test('recognizes Aadhaar OTP and biometric existing-account responses', () {
      expect(
        isExistingAbhaAccountResponse({
          'result': {
            'message': 'This account already exist',
            'isNew': false,
          },
        }),
        isTrue,
      );
      expect(
        isExistingAbhaAccountResponse({
          'data': {
            'isNew': 'false',
            'ABHAProfile': {'abhaAddress': 'existing@abdm'},
          },
        }),
        isTrue,
      );
    });

    test(
        'does not classify a new profile or address conflict as an existing account',
        () {
      expect(
        isExistingAbhaAccountResponse({
          'result': {
            'message': 'Account created successfully',
            'isNew': true,
            'ABHAProfile': {'abhaAddress': ''},
          },
        }),
        isFalse,
      );
      expect(
        isExistingAbhaAccountResponse({
          'message': 'ABHA address already exists',
        }),
        isFalse,
      );
    });
  });
}
