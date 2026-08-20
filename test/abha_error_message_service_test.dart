import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/services/abha_error_message_service.dart';

void main() {
  test('maps ABHA validation errors', () {
    expect(AbhaErrorMessageService.required('aadhaar'), 'Please enter your Aadhaar number.');
    expect(AbhaErrorMessageService.invalid('aadhaar', incomplete: true), 'Please enter a valid 12-digit Aadhaar number.');
    expect(AbhaErrorMessageService.invalid('mobile'), 'Please enter a valid 10-digit mobile number.');
    expect(AbhaErrorMessageService.invalid('otp', incomplete: true), 'Please enter the complete OTP.');
  });

  test('maps status and transport errors safely', () {
    expect(AbhaErrorMessageService.map({'statusCode': 401}), 'Your session has expired. Please try again.');
    expect(AbhaErrorMessageService.map({'statusCode': 503}), 'The service is temporarily unavailable. Please try again later.');
    expect(AbhaErrorMessageService.map(const TimeoutException('DioException')), 'The request is taking too long. Please check your connection and try again.');
    expect(AbhaErrorMessageService.map({'message': 'transactionId invalid'}, context: 'otp'), 'Something went wrong. Please try again.');
  });

  test('maps domain errors without exposing backend text', () {
    expect(AbhaErrorMessageService.map({'message': 'Wrong OTP'}, context: 'otp'), 'The OTP you entered is incorrect. Please check it and try again.');
    expect(AbhaErrorMessageService.map({'message': 'profile not found'}, context: 'profile'), 'We couldn\'t find your ABHA profile. Please try again.');
    expect(AbhaErrorMessageService.map({'message': 'backend failure'}, context: 'card'), 'We couldn\'t download your ABHA card. Please try again.');
  });
}
