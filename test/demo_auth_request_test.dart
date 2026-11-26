import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/controller/demo_auth_controller.dart';
import 'package:taei_gov/src/nurse_triage/models/lgd_models.dart';
import 'package:taei_gov/src/nurse_triage/services/demo_auth_service.dart';

class _CapturingDemoAuthService extends DemoAuthService {
  Map<String, dynamic>? requestBody;

  @override
  Future<Map<String, dynamic>?> enrollByAadhaar({
    required Map<String, dynamic> body,
    String? flowId,
  }) async {
    requestBody = body;
    return {'profileId': 123};
  }
}

void main() {
  group('LGD state and district codes', () {
    test('includes states and union territories with district lists', () {
      expect(lgdStates, hasLength(36));
      expect(lgdStates.map((state) => state.code).toSet(), hasLength(36));
      expect(
        lgdStates.singleWhere((state) => state.name == 'Tamil Nadu').code,
        33,
      );
      var districtCount = 0;
      for (final state in lgdStates) {
        final districts = getDistrictsForState(state.name);
        expect(districts, isNotEmpty,
            reason: '${state.name} should have districts');
        expect(
          districts.every(
            (district) => district.code > 0 && district.code <= 640,
          ),
          isTrue,
          reason: '${state.name} should have Census district codes',
        );
        districtCount += districts.length;
      }
      expect(districtCount, 790);

      expect(
        tamilNaduDistricts
            .singleWhere((district) => district.name == 'Vellore')
            .code,
        605,
      );
      expect(
        getDistrictsForState('Tamil Nadu').map((district) => district.name),
        contains('Vellore'),
      );
      expect(
        getDistrictsForState('Karnataka').map((district) => district.name),
        contains('Bengaluru Urban'),
      );
      expect(
        getDistrictsForState('Telangana')
            .singleWhere(
              (district) => district.name == 'Bhadradri Kothagudem',
            )
            .code,
        541,
      );
    });
  });

  test('sends state and district code strings instead of names', () async {
    final service = _CapturingDemoAuthService();
    final controller = DemoAuthController(service: service);
    controller.selectState('Tamil Nadu');
    controller.selectDistrict('Vellore');

    final success = await controller.submitDemoAuth(
      aadhaar: '123456789012',
      stateName: 'Tamil Nadu',
      districtName: 'Vellore',
      dateOfBirth: '24-04-2003',
      gender: 'M',
      name: 'Test Patient',
      mobile: '9000000000',
      pinCode: '632514',
    );

    expect(success, isTrue);
    expect(service.requestBody, {
      'aadhaar': '123456789012',
      'stateCode': '33',
      'districtCode': '605',
      'dateOfBirth': '24-04-2003',
      'gender': 'M',
      'name': 'Test Patient',
      'mobile': '9000000000',
      'pinCode': '632514',
    });
  });

  test('sends Thiruvallur LGD code for ABHA demo authentication', () async {
    final service = _CapturingDemoAuthService();
    final controller = DemoAuthController(service: service);
    controller.selectState('Tamil Nadu');
    controller.selectDistrict('Thiruvallur');

    final success = await controller.submitDemoAuth(
      aadhaar: '123456789012',
      stateName: 'Tamil Nadu',
      districtName: 'Thiruvallur',
      dateOfBirth: '24-04-2003',
      gender: 'M',
      name: 'Test Patient',
    );

    expect(success, isTrue);
    expect(service.requestBody?['stateCode'], '33');
    expect(service.requestBody?['districtCode'], '589');
  });

  test('sends Census district codes for other states', () async {
    final service = _CapturingDemoAuthService();
    final controller = DemoAuthController(service: service);
    controller.selectState('Karnataka');
    controller.selectDistrict('Bengaluru Urban');

    final success = await controller.submitDemoAuth(
      aadhaar: '123456789012',
      stateName: 'Karnataka',
      districtName: 'Bengaluru Urban',
      dateOfBirth: '24-04-2003',
      gender: 'M',
      name: 'Test Patient',
    );

    expect(success, isTrue);
    expect(service.requestBody?['stateCode'], '29');
    expect(service.requestBody?['districtCode'], '572');
  });
}
