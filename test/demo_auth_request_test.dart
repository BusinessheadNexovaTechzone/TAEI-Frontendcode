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
  group('Tamil Nadu district codes', () {
    test('uses census 2011 codes, including reorganized districts', () {
      final codesByName = {
        for (final district in tamilNaduDistricts) district.name: district.code,
      };

      expect(codesByName, {
        'Ariyalur': 615,
        'Chengalpattu': 603,
        'Chennai': 602,
        'Coimbatore': 631,
        'Cuddalore': 616,
        'Dharmapuri': 629,
        'Dindigul': 611,
        'Erode': 609,
        'Kallakurichi': 606,
        'Kancheepuram': 603,
        'Kanniyakumari': 628,
        'Karur': 612,
        'Krishnagiri': 630,
        'Madurai': 622,
        'Mayiladuthurai': 617,
        'Nagapattinam': 617,
        'Namakkal': 608,
        'Perambalur': 614,
        'Pudukkottai': 620,
        'Ramanathapuram': 625,
        'Ranipet': 604,
        'Salem': 607,
        'Sivaganga': 621,
        'Tenkasi': 627,
        'Thanjavur': 619,
        'Theni': 623,
        'The Nilgiris': 610,
        'Thiruvallur': 601,
        'Thiruvarur': 618,
        'Thoothukkudi': 626,
        'Tiruchirappalli': 613,
        'Tirunelveli': 627,
        'Tirupathur': 604,
        'Tiruppur': 632,
        'Tiruvannamalai': 605,
        'Vellore': 604,
        'Viluppuram': 606,
        'Virudhunagar': 624,
      });
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
      consentAccepted: true,
    );

    expect(success, isTrue);
    expect(service.requestBody, {
      'aadhaar': '123456789012',
      'stateCode': '33',
      'districtCode': '604',
      'dateOfBirth': '24-04-2003',
      'gender': 'M',
      'name': 'Test Patient',
      'mobile': '9000000000',
      'pinCode': '632514',
    });
  });
}
