import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/models/update_mobile_verify_otp_response.dart';

void main() {
  group('UpdateMobileVerifyOtpResponse', () {
    test('recognizes successful mobile verification message without authResult',
        () {
      final response = UpdateMobileVerifyOtpResponse.fromJson({
        'message': 'Mobile number verified successfully.',
      });

      expect(response.isSuccess, isTrue);
    });

    test('does not treat failed mobile verification as success', () {
      final response = UpdateMobileVerifyOtpResponse.fromJson({
        'message': 'Mobile number verification failed.',
      });

      expect(response.isSuccess, isFalse);
    });

    test('continues to recognize successful authResult', () {
      final response = UpdateMobileVerifyOtpResponse.fromJson({
        'authResult': 'SUCCESS',
      });

      expect(response.isSuccess, isTrue);
    });
  });
}
