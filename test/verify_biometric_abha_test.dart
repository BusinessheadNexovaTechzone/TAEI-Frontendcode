import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/nurse_triage/views/verify_abha.dart';
import 'package:taei_gov/src/nurse_triage/views/verify_biometric_abha.dart';

void main() {
  testWidgets('renders Face as a standalone verification method',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VerifyBiometricAbhaScreen(method: VerifyBiometricMethod.face),
        ),
      ),
    );

    expect(find.text('Face Verification'), findsOneWidget);
    expect(find.text('Aadhaar Number'), findsOneWidget);
    expect(find.text('Mobile Number'), findsOneWidget);
    expect(find.text('Continue with Face Verification'), findsOneWidget);
  });

  testWidgets('renders Fingerprint as a standalone verification method',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VerifyBiometricAbhaScreen(
            method: VerifyBiometricMethod.fingerprint,
          ),
        ),
      ),
    );

    expect(find.text('Fingerprint Verification'), findsOneWidget);
    expect(find.text('Continue with Fingerprint Verification'), findsOneWidget);
  });

  testWidgets('Verify ABHA exposes Face and Fingerprint as top-level methods',
      (tester) async {
    Get.put(LoginController());
    await tester.pumpWidget(const MaterialApp(home: VerifyAbhaScreen()));
    await tester.pump();

    expect(find.text('Mobile Number'), findsAtLeastNWidgets(1));
    expect(find.text('Aadhaar Number'), findsAtLeastNWidgets(1));
    expect(find.text('ABHA Number'), findsAtLeastNWidgets(1));
    expect(find.text('ABHA Address'), findsAtLeastNWidgets(1));
    expect(find.text('Face'), findsOneWidget);
    expect(find.text('Fingerprint'), findsOneWidget);
  });
}