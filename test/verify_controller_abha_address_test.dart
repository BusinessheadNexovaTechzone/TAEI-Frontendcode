import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';

void main() {
  group('VerifyAbhaController ABHA address support', () {
    test('maps abha address methods to the correct login types', () {
      final controller = VerifyAbhaController();

      expect(
        controller.resolveLoginType(method: 'abha-address-mobile'),
        'abha-address-mobile-otp',
      );
      expect(
        controller.resolveLoginType(method: 'abha-address-aadhaar'),
        'abha-address-aadhaar-otp',
      );
    });

    test('validates abha address format', () {
      final controller = VerifyAbhaController();

      expect(controller.validateInput(method: 'abha-address-mobile', value: 'lavanya@abdm'), isTrue);
      expect(controller.validateInput(method: 'abha-address-mobile', value: 'patient123@sbx'), isTrue);
      expect(controller.validateInput(method: 'abha-address-aadhaar', value: 'john@abdm'), isTrue);
      expect(controller.validateInput(method: 'abha-address-mobile', value: 'lavanya'), isFalse);
      expect(controller.validateInput(method: 'abha-address-mobile', value: '@abdm'), isFalse);
      expect(controller.validateInput(method: 'abha-address-mobile', value: 'lavanya@'), isFalse);
      expect(controller.validateInput(method: 'abha-address-mobile', value: ''), isFalse);
    });
  });
}
