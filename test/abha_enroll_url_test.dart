import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/constants/urls.dart';

void main() {
  test('face enroll URL uses the enroll endpoint', () {
    expect(Urls.createAbhaUsingFace, endsWith('/api/abha/face/enroll'));
  });
}
