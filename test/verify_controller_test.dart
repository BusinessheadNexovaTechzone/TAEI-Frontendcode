import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/controller/verify_controller.dart';
import 'package:taei_gov/src/nurse_triage/models/abha_verified_profile.dart';
import 'package:taei_gov/src/nurse_triage/utils/abha_otp_utils.dart';

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

    test('normalizes a direct verification response into the unified ABHA profile', () {
      final profile = AbhaVerifiedProfile.fromResponse({
        'ABHANumber': '91-6470-7346-6839',
        'preferredAbhaAddress': 'pushpa_abha1@sbx',
        'name': 'Pushpa',
        'gender': 'F',
        'dob': '27-12-2002',
        'verifiedStatus': 'VERIFIED',
        'verificationType': 'AADHAAR',
        'status': 'ACTIVE',
        'profilePhoto': 'data:image/jpeg;base64,/9j/4AAQSkZJRg==',
      });

      expect(profile.abhaNumber, '91-6470-7346-6839');
      expect(profile.abhaAddress, 'pushpa_abha1@sbx');
      expect(profile.name, 'Pushpa');
      expect(profile.dateOfBirth, '27-12-2002');
      expect(profile.gender, 'Female');
      expect(profile.verificationStatus, 'VERIFIED');
      expect(profile.verificationType, 'AADHAAR');
      expect(profile.status, 'ACTIVE');
      expect(profile.profilePhoto, '/9j/4AAQSkZJRg==');
      expect(profile.mobile, 'Not Available');

      final now = DateTime.now();
      var expectedAge = now.year - 2002;
      if (now.month < 12 || (now.month == 12 && now.day < 27)) {
        expectedAge--;
      }
      expect(profile.age, '$expectedAge years');
    });

    test('handles nested and split date-of-birth response data', () {
      final profile = AbhaVerifiedProfile.fromResponse({
        'result': {
          'name': 'Raj',
          'dayOfBirth': '27',
          'monthOfBirth': '12',
          'yearOfBirth': '2002',
          'gender': 'M',
          'mobile': '9876543210',
          'verifiedStatus': 'VERIFIED',
          'verificationMethod': 'MOBILE',
          'accountStatus': 'ACTIVE',
        },
      });

      expect(profile.name, 'Raj');
      expect(profile.dateOfBirth, '27-12-2002');
      expect(profile.gender, 'Male');
      expect(profile.mobile, '9876543210');
      expect(profile.verificationStatus, 'VERIFIED');
      expect(profile.verificationType, 'MOBILE');
      expect(profile.status, 'ACTIVE');
    });

    test('normalizes every profile in a multi-profile response independently', () {
      final profiles = AbhaVerifiedProfile.fromResponseList({
        'result': {
          'ABHAProfile': [
            {
              'id': 46,
              'name': 'First User',
              'ABHANumber': '91-1111-1111-1111',
              'preferredAbhaAddress': 'first@sbx',
              'gender': 'F',
              'dob': '01-01-2000',
              'mobile': '9000000001',
            },
            {
              'id': 47,
              'name': 'Second User',
              'ABHANumber': '91-2222-2222-2222',
              'preferredAbhaAddress': 'second@sbx',
              'gender': 'M',
              'dob': '02-02-2001',
              'mobile': '9000000002',
            },
            {
              'id': 48,
              'name': 'Third User',
              'ABHANumber': '91-3333-3333-3333',
              'preferredAbhaAddress': 'third@sbx',
              'gender': 'O',
            },
          ],
        },
      });

      expect(profiles, hasLength(3));
      expect(profiles[0].profileId, 46);
      expect(profiles[0].name, 'First User');
      expect(profiles[0].mobile, '9000000001');
      expect(profiles[1].profileId, 47);
      expect(profiles[1].name, 'Second User');
      expect(profiles[1].gender, 'Male');
      expect(profiles[2].profileId, 48);
      expect(profiles[2].name, 'Third User');
      expect(profiles[2].abhaAddress, 'third@sbx');
    });

    test('extracts profileId from nested ABHA verification payloads', () {
      expect(
        extractAbhaProfileId({
          'result': {
            'ABHAProfile': {'profileId': 42},
          },
        }),
        42,
      );

      expect(
        extractAbhaProfileId({
          'data': {
            'profile': {'id': 88},
          },
        }),
        88,
      );

      expect(
        extractAbhaProfileId({
          'abhaProfileId': 130,
        }),
        130,
      );
    });
  });
}
