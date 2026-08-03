import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';

void main() {
  group('VerifyAbhaController', () {
    test('accepts only 14-digit ABHA numbers for ABHA-based OTP methods', () {
      final controller = VerifyAbhaController();

      expect(
        controller.validateInput(
          method: 'abha-aadhaar',
          value: '12345678901234',
        ),
        isTrue,
      );
      expect(
        controller.validateInput(
          method: 'abha-abha',
          value: ' 12345678901234 ',
        ),
        isTrue,
      );
      expect(
        controller.validateInput(
          method: 'abha-aadhaar',
          value: '1234567890123',
        ),
        isFalse,
      );
      expect(
        controller.validateInput(
          method: 'abha-aadhaar',
          value: 'abc123',
        ),
        isFalse,
      );
    });

    test('normalizes ABHA input by stripping whitespace and non-digits', () {
      final controller = VerifyAbhaController();

      expect(
        controller.normalizeInput(' 1234-5678-9012-34 '),
        '12345678901234',
      );
      expect(
        controller.normalizeInput('abc12345678901234xyz'),
        '12345678901234',
      );
    });
  });
}
