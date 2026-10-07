import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/models/abha_verified_profile.dart';

void main() {
  group('ABHA profile normalization', () {
    test('keeps ABHA and residential addresses separate', () {
      final profiles = AbhaVerifiedProfile.fromResponseList({
        'result': {
          'ABHAProfile': {
            'name': 'Asha Patient',
            'preferredAbhaAddress': 'asha@abdm',
            'address': '12 Main Street',
          },
        },
      });

      expect(profiles.single.name, 'Asha Patient');
      expect(profiles.single.abhaAddress, 'asha@abdm');
      expect(profiles.single.address, '12 Main Street');
    });

    test('does not treat a residential address as an ABHA address', () {
      final profiles = AbhaVerifiedProfile.fromResponseList({
        'result': {
          'ABHAProfile': {
            'patientName': 'Asha Patient',
            'residentialAddress': '12 Main Street',
          },
        },
      });

      expect(profiles.single.name, 'Asha Patient');
      expect(profiles.single.abhaAddress, 'Not Available');
      expect(profiles.single.address, '12 Main Street');
    });
  });
}
