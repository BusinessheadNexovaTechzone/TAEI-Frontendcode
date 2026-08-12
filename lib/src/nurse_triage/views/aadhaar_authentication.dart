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
    required this.onOtpKey,
    required this.mobileController,
    required this.resendSeconds,
    required this.onResendOtp,
    required this.resendAttempts,
    required this.maxResendAttempts,
    required this.onVerify,
    required this.isSubmitting,
    required this.otpComplete,
    required this.mobileComplete,
    required this.otpDeliveryMessage,
    required this.formatResendTimer,
    required this.buildMaskedMobileNumber,
    required this.isValidMobile,
    required this.shouldShowOtpError,
    required this.shouldShowMobileError,
    required this.onOtpFieldChanged,
    required this.onMobileFieldChanged,
    this.title,
    this.description,
    this.buttonLabel,
    this.showMobileNumberField = true,
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
  final void Function(int index, RawKeyEvent event) onOtpKey;
  final TextEditingController mobileController;
  final int resendSeconds;
  final int resendAttempts;
  final int maxResendAttempts;
  final Future<void> Function() onResendOtp;
  final Future<void> Function() onVerify;
  final bool isSubmitting;
  final bool otpComplete;
  final bool mobileComplete;
  final String otpDeliveryMessage;
  final String Function() formatResendTimer;
  final String Function() buildMaskedMobileNumber;
  final bool Function(String? value) isValidMobile;
  final bool shouldShowOtpError;
  final bool shouldShowMobileError;
  final VoidCallback onOtpFieldChanged;
  final VoidCallback onMobileFieldChanged;
  final String? title;
  final String? description;
  final String? buttonLabel;
  final bool showMobileNumberField;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final digitWidth = ((screenWidth - 80) / 6).clamp(40.0, 56.0);
    final headingTitle = title ?? 'Confirm OTP';
    final messageText = description ??
        (otpDeliveryMessage.isNotEmpty
            ? otpDeliveryMessage
            : 'OTP Verification *');
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
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              headingTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 20),
            Text(
              messageText,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.visible,
              style: theme.textTheme.titleSmall?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: secondaryTextColor,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            FormField<String>(
              validator: (value) {
                if (!shouldShowOtpError) return null;
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
                        final isActive = otpDigitControllers[index].text.isEmpty;
                        return SizedBox(
                          width: digitWidth,
                          height: 52,
                          child: Focus(
                            onKey: (node, event) {
                              onOtpKey(index, event);
                              return KeyEventResult.ignored;
                            },
                            child: TextFormField(
                              controller: otpDigitControllers[index],
                              focusNode: otpFocusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              maxLengthEnforcement: MaxLengthEnforcement.enforced,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
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
                              onChanged: (value) {
                                onOtpDigitChanged(index, value);
                                onOtpFieldChanged();
                              },
                            ),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Row(
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
                        child: const Text('Resend OTP'),
                      ),
                    ],
                  ),
                ),
                if (resendAttempts > 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 2),
                    child: Text(
                      'Attempt $resendAttempts/$maxResendAttempts',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
            if (showMobileNumberField) ...[
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
                onChanged: (_) => onMobileFieldChanged(),
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
                  if (!shouldShowMobileError) return null;
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
            ],
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: isSubmitting || !otpComplete || (showMobileNumberField && !mobileComplete)
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
                child: Text(buttonLabel ?? 'Verify & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
