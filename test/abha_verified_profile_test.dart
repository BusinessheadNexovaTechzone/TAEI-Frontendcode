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

    test(
        'prefers numeric birth date parts over localized DOB and calculates age',
        () {
      final now = DateTime.now();
      var expectedAge = now.year - 2002;
      if (now.month < 9 || (now.month == 9 && now.day < 29)) {
        expectedAge--;
      }

      final profile = AbhaVerifiedProfile.fromResponse({
        'dob': 'பிறந்த தேதி',
        'yearOfBirth': '2002',
        'dayOfBirth': '29',
        'monthOfBirth': '09',
        'age': '99',
      });

      expect(profile.dateOfBirth, '29-09-2002');
      expect(profile.age, '$expectedAge years');
    });
  });
}
