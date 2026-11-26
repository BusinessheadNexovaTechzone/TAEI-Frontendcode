import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/nurse_triage/services/verify_service.dart';

class _FakeVerifyAbhaService extends VerifyAbhaService {
  String? accountDetailsToken;
  int accountDetailsCalls = 0;
  Map<String, dynamic>? accountDetails;

  @override
  Future<Map<String, dynamic>?> getAbhaAccountDetails({
    required String accessToken,
  }) async {
    accountDetailsCalls++;
    accountDetailsToken = accessToken;
    return accountDetails;
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.put(LoginController());
  });

  tearDown(Get.reset);

  group('ABHA creation profile details', () {
    test('fetches details with X-Token and preserves profile identifiers',
        () async {
      final service = _FakeVerifyAbhaService()
        ..accountDetails = {
          'ABHANumber': '91-1234-5678-9012',
          'name': 'Fetched Profile',
          'mobile': '9000000000',
        };
      final controller = NurseTriageController(verifyAbhaService: service);

      final profile = await controller.fetchCreatedAbhaProfileDetails(
        {
          'profileId': 42,
          'tokens': {
            'tToken': 'transaction-token',
            'xToken': 'account-token',
          },
          'result': {
            'ABHAProfile': {
              'name': 'Enrollment Profile',
              'preferredAbhaAddress': 'created@sbx',
            },
          },
        },
        preserveEnrollmentAddress: true,
      );

      expect(service.accountDetailsCalls, 1);
      expect(service.accountDetailsToken, 'account-token');
      expect(controller.verifiedAbhaAccessToken, 'account-token');
      expect(controller.currentProfileId.value, '42');
      expect(profile?['result']?['ABHAProfile']?['name'], 'Fetched Profile');
      expect(
        profile?['result']?['ABHAProfile']?['preferredAbhaAddress'],
        'created@sbx',
      );
    });

    test('does not reuse a stale token for a new enrollment', () async {
      final service = _FakeVerifyAbhaService();
      final controller = NurseTriageController(verifyAbhaService: service)
        ..verifiedAbhaAccessToken = 'stale-token';

      final profile =
          await controller.fetchCreatedAbhaProfileDetails({'profileId': 42});

      expect(profile, isNull);
      expect(service.accountDetailsCalls, 0);
      expect(controller.verifiedAbhaAccessToken, isNull);
    });

    test('reuses the current flow token after address creation', () async {
      final service = _FakeVerifyAbhaService()
        ..accountDetails = {
          'result': {
            'ABHAProfile': {
              'profileId': 45,
              'name': 'Address Profile',
            },
          },
        };
      final controller = NurseTriageController(verifyAbhaService: service)
        ..verifiedAbhaAccessToken = 'current-flow-token';

      final profile = await controller.fetchCreatedAbhaProfileDetails(
        {
          'result': {
            'ABHAProfile': {'preferredAbhaAddress': 'new@sbx'},
          },
        },
        useStoredAccessToken: true,
        preserveEnrollmentAddress: true,
      );

      expect(service.accountDetailsToken, 'current-flow-token');
      expect(controller.verifiedAbhaAccessToken, 'current-flow-token');
      expect(profile?['result']?['ABHAProfile']?['profileId'], 45);
      expect(
        profile?['result']?['ABHAProfile']?['preferredAbhaAddress'],
        'new@sbx',
      );
    });
  });
}
