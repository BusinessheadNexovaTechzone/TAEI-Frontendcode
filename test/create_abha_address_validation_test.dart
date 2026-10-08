import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/utils/create_abha_validation.dart';

void main() {
  group('ABHA address username validation', () {
    test('accepts an 8 to 18 character username', () {
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('sant2002'),
        isNull,
      );
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('santhoshp200209'),
        isNull,
      );
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('abcdefgh1234567890'),
        isNull,
      );
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('abcdefgh12345678901'),
        contains('8 to 18'),
      );
    });

    test('validates the username portion of a suggested ABHA address', () {
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername(
          'santhoshp200209@sbx',
        ),
        isNull,
      );
    });

    test('allows one dot and one underscore only between characters', () {
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('santhosh.p_2002'),
        isNull,
      );
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('.santhosh'),
        isNotNull,
      );
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('santhosh_'),
        isNotNull,
      );
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('san.th.osh'),
        isNotNull,
      );
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('san_th_osh'),
        isNotNull,
      );
    });

    test('rejects spaces and unsupported username characters', () {
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('san thosh'),
        contains('Spaces'),
      );
      expect(
        CreateAbhaValidation.validateAbhaAddressUsername('san-thosh'),
        isNotNull,
      );
    });
  });
}
