import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/views/update_mobile_otp_dialog.dart';

void main() {
  Widget buildDialog({
    required Future<bool> Function(String otp) onVerify,
    required Future<bool> Function() onResend,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: UpdateMobileOtpDialog(
          flowId: 'test-flow',
          onVerify: onVerify,
          onResend: onResend,
        ),
      ),
    );
  }

  testWidgets('limits mobile OTP resend requests to three attempts',
      (tester) async {
    var resendCount = 0;
    await tester.pumpWidget(
      buildDialog(
        onVerify: (_) async => false,
        onResend: () async {
          resendCount++;
          return true;
        },
      ),
    );

    expect(find.text('Attempt 1/3'), findsOneWidget);
    expect(
        tester.widget<TextButton>(find.byType(TextButton)).onPressed, isNull);

    await tester.pump(const Duration(seconds: 60));
    await tester.tap(find.text('Resend OTP'));
    await tester.pump();
    await tester.pump();

    expect(resendCount, 1);
    expect(find.text('Attempt 2/3'), findsOneWidget);

    await tester.pump(const Duration(seconds: 60));
    await tester.tap(find.text('Resend OTP'));
    await tester.pump();
    await tester.pump();

    expect(resendCount, 2);
    expect(find.text('Attempt 3/3'), findsOneWidget);
    expect(find.text('Resend limit reached'), findsOneWidget);
    expect(
        tester.widget<TextButton>(find.byType(TextButton)).onPressed, isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('locks mobile OTP verification after three incorrect attempts',
      (tester) async {
    var verificationCount = 0;
    await tester.pumpWidget(
      buildDialog(
        onVerify: (_) async {
          verificationCount++;
          return false;
        },
        onResend: () async => true,
      ),
    );

    final otpFields = find.byType(TextFormField);
    for (var attempt = 0; attempt < 3; attempt++) {
      for (var digit = 0; digit < 6; digit++) {
        await tester.enterText(otpFields.at(digit), '$digit');
        await tester.pump();
      }
      await tester.tap(find.text('Verify'));
      await tester.pump();
      await tester.pump();
    }

    expect(verificationCount, 3);
    expect(
      find.textContaining('invalid OTP 3 times'),
      findsOneWidget,
    );
    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).onPressed,
        isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
