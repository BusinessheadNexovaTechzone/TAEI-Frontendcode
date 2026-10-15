import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taei_gov/src/nurse_triage/views/update_mobile_number_screen.dart';

void main() {
  Widget buildScreen({
    required Future<bool> Function(String mobile) onSendOtp,
    required Future<bool> Function(String otp) onVerify,
  }) {
    return MaterialApp(
      home: UpdateMobileNumberScreen(
        flowId: 'test-flow',
        currentMobile: '1234567890',
        onSendOtp: onSendOtp,
        onVerify: onVerify,
      ),
    );
  }

  Future<void> sendInitialOtp(WidgetTester tester) async {
    await tester.tap(find.text('Send OTP'));
    await tester.pump();
    await tester.pump();
    expect(find.text('OTP requests: 1/3'), findsOneWidget);
  }

  testWidgets('limits mobile OTP requests and restarts resend cooldown',
      (tester) async {
    var sendCount = 0;
    await tester.pumpWidget(
      buildScreen(
        onSendOtp: (_) async {
          sendCount++;
          return true;
        },
        onVerify: (_) async => false,
      ),
    );

    await sendInitialOtp(tester);
    var resendButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Resend OTP'),
    );
    expect(resendButton.onPressed, isNull);

    await tester.pump(const Duration(seconds: 60));
    await tester.tap(find.text('Resend OTP'));
    await tester.pump();
    await tester.pump();

    expect(sendCount, 2);
    expect(find.text('OTP requests: 2/3'), findsOneWidget);
    expect(find.text('Resend in 60s'), findsOneWidget);

    await tester.pump(const Duration(seconds: 60));
    await tester.tap(find.text('Resend OTP'));
    await tester.pump();
    await tester.pump();

    expect(sendCount, 3);
    expect(find.text('OTP requests: 3/3'), findsOneWidget);
    expect(find.text('Resend limit reached'), findsOneWidget);
    resendButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Resend limit reached'),
    );
    expect(resendButton.onPressed, isNull);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('locks mobile OTP verification after three incorrect attempts',
      (tester) async {
    var verificationCount = 0;
    await tester.pumpWidget(
      buildScreen(
        onSendOtp: (_) async => true,
        onVerify: (_) async {
          verificationCount++;
          return false;
        },
      ),
    );
    await sendInitialOtp(tester);

    final otpFields = find.byType(TextFormField);
    for (var attempt = 0; attempt < 3; attempt++) {
      for (var digit = 0; digit < 6; digit++) {
        await tester.enterText(otpFields.at(digit), '$digit');
        await tester.pump();
      }
      await tester.tap(find.text('Verify and Update'));
      await tester.pump();
      await tester.pump();
    }

    expect(verificationCount, 3);
    expect(find.textContaining('invalid OTP 3 times'), findsOneWidget);
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Verify and Update'),
          )
          .onPressed,
      isNull,
    );

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
