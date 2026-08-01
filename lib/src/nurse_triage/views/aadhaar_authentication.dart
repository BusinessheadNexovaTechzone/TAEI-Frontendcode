import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AadhaarAuthenticationStep extends StatelessWidget {
  const AadhaarAuthenticationStep({
    super.key,
    required this.formKey,
    required this.theme,
    required this.primaryColor,
    required this.borderColor,
    required this.secondaryColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.surfaceColor,
    required this.otpDigitControllers,
    required this.otpFocusNodes,
    required this.onOtpDigitChanged,
    required this.mobileController,
    required this.resendSeconds,
    required this.onResendOtp,
    required this.onVerify,
    required this.isSubmitting,
    required this.otpComplete,
    required this.mobileComplete,
    required this.formatResendTimer,
    required this.buildMaskedMobileNumber,
    required this.isValidMobile,
  });

  final GlobalKey<FormState> formKey;
  final ThemeData theme;
  final Color primaryColor;
  final Color borderColor;
  final Color secondaryColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color surfaceColor;
  final List<TextEditingController> otpDigitControllers;
  final List<FocusNode> otpFocusNodes;
  final void Function(int index, String value) onOtpDigitChanged;
  final TextEditingController mobileController;
  final int resendSeconds;
  final Future<void> Function() onResendOtp;
  final Future<void> Function() onVerify;
  final bool isSubmitting;
  final bool otpComplete;
  final bool mobileComplete;
  final String Function() formatResendTimer;
  final String Function() buildMaskedMobileNumber;
  final bool Function(String? value) isValidMobile;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final digitWidth = ((screenWidth - 80) / 6).clamp(40.0, 56.0);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirm OTP',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            if (buildMaskedMobileNumber().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: secondaryColor, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'OTP sent to Aadhaar registered mobile number ending with ${buildMaskedMobileNumber()}.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'OTP Verification *',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            FormField<String>(
              validator: (value) {
                if (otpDigitControllers
                        .map((controller) => controller.text)
                        .join()
                        .length !=
                    6) {
                  return 'OTP must contain exactly 6 digits.';
                }
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        final isActive =
                            otpDigitControllers[index].text.isEmpty;
                        return SizedBox(
                          width: digitWidth,
                          height: 52,
                          child: TextFormField(
                            controller: otpDigitControllers[index],
                            focusNode: otpFocusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isActive ? borderColor : primaryColor,
                                  width: 1.2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: isActive ? borderColor : primaryColor,
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: primaryColor, width: 2),
                              ),
                            ),
                            onChanged: (value) =>
                                onOtpDigitChanged(index, value),
                          ),
                        );
                      }),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          field.errorText ?? 'OTP is required.',
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'Didn\'t receive OTP?',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: secondaryTextColor),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: resendSeconds == 0
                      ? () async {
                          await onResendOtp();
                        }
                      : null,
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(resendSeconds == 0 ? 'Resend OTP' : 'Resend OTP'),
                ),
              ],
            ),
            if (resendSeconds > 0)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${formatResendTimer()} Remaining',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: secondaryTextColor),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              'Mobile Number *',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                prefixIcon: Container(
                  width: 54,
                  alignment: Alignment.center,
                  child: const Text('+91',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                hintText: 'Enter 10-digit mobile number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
              validator: (value) {
                if (!isValidMobile(value)) {
                  return 'Mobile Number must contain exactly 10 digits.';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.info_outline, color: secondaryColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'It is preferable to use your Aadhaar-linked mobile number. If you choose a different mobile number, it will be verified again and used for all future ABHA communications.',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: secondaryTextColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: isSubmitting || !otpComplete || !mobileComplete
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        await onVerify();
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Verify & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
