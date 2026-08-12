import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConsentCollectionStep extends StatelessWidget {
  const ConsentCollectionStep({
    super.key,
    required this.formKey,
    required this.theme,
    required this.primaryColor,
    required this.borderColor,
    required this.secondaryColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.surfaceColor,
    required this.aadhaarPartControllers,
    required this.aadhaarFocusNodes,
    required this.aadhaarVisible,
    required this.onToggleAadhaarVisibility,
    required this.onAadhaarPartChanged,
    required this.consentAccepted,
    required this.onConsentChanged,
    required this.selectedAuthMethod,
    required this.onAuthMethodChanged,
    required this.captchaQuestion,
    required this.captchaAnswer,
    required this.captchaController,
    required this.onRefreshCaptcha,
    required this.isSubmitting,
    required this.canProceed,
    required this.onCancel,
    required this.onNext,
    required this.isValidAadhaar,
    required this.buildInputDecoration,
    required this.shouldShowAadhaarError,
    required this.shouldShowConsentError,
    required this.shouldShowAuthMethodError,
    required this.shouldShowCaptchaError,
    required this.onAadhaarFieldChanged,
    required this.onCaptchaChanged,
    this.otpHintText,
  });

  final GlobalKey<FormState> formKey;
  final ThemeData theme;
  final Color primaryColor;
  final Color borderColor;
  final Color secondaryColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color surfaceColor;
  final List<TextEditingController> aadhaarPartControllers;
  final List<FocusNode> aadhaarFocusNodes;
  final bool aadhaarVisible;
  final VoidCallback onToggleAadhaarVisibility;
  final void Function(int index, String value) onAadhaarPartChanged;
  final bool consentAccepted;
  final void Function(bool?) onConsentChanged;
  final String? selectedAuthMethod;
  final void Function(String?) onAuthMethodChanged;
  final String captchaQuestion;
  final String captchaAnswer;
  final TextEditingController captchaController;
  final VoidCallback onRefreshCaptcha;
  final bool isSubmitting;
  final bool canProceed;
  final VoidCallback onCancel;
  final Future<void> Function() onNext;
  final bool Function(String? value) isValidAadhaar;
  final InputDecoration Function(
      {String? labelText,
      String? hintText,
      String? counterText}) buildInputDecoration;
  final bool shouldShowAadhaarError;
  final bool shouldShowConsentError;
  final bool shouldShowAuthMethodError;
  final bool shouldShowCaptchaError;
  final VoidCallback onAadhaarFieldChanged;
  final VoidCallback onCaptchaChanged;
  final String? otpHintText;

  @override
  Widget build(BuildContext context) {
    final aadhaarValue =
        aadhaarPartControllers.map((controller) => controller.text).join();
    final aadhaarDigits = aadhaarValue.replaceAll(RegExp(r'\D'), '');
    final captchaSum = captchaQuestion
        .split(' = ?')[0]
        .split(' + ')
        .fold<int>(0, (value, item) {
      final number = int.tryParse(item) ?? 0;
      return value + number;
    }).toString();

    final canContinue = aadhaarDigits.length == 12 &&
        consentAccepted &&
        selectedAuthMethod != null &&
        (captchaController.text.trim() == captchaSum);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
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
                  'Aadhaar Number *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                FormField<String>(
                  validator: (value) {
                    if (!shouldShowAadhaarError) return null;
                    if (!isValidAadhaar(aadhaarPartControllers
                        .map((controller) => controller.text)
                        .join())) {
                      return 'Aadhaar Number must contain exactly 12 digits.';
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: aadhaarPartControllers[0],
                                focusNode: aadhaarFocusNodes[0],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                obscureText: !aadhaarVisible,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                onChanged: (value) {
                                  onAadhaarPartChanged(0, value);
                                  onAadhaarFieldChanged();
                                },
                                decoration:
                                    buildInputDecoration(hintText: '0000'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child:
                                  Text('-', style: theme.textTheme.titleMedium),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: aadhaarPartControllers[1],
                                focusNode: aadhaarFocusNodes[1],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                obscureText: !aadhaarVisible,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                onChanged: (value) {
                                  onAadhaarPartChanged(1, value);
                                  onAadhaarFieldChanged();
                                },
                                decoration:
                                    buildInputDecoration(hintText: '0000'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 6),
                              child:
                                  Text('-', style: theme.textTheme.titleMedium),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: aadhaarPartControllers[2],
                                focusNode: aadhaarFocusNodes[2],
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                obscureText: !aadhaarVisible,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                onChanged: (value) {
                                  onAadhaarPartChanged(2, value);
                                  onAadhaarFieldChanged();
                                },
                                decoration:
                                    buildInputDecoration(hintText: '0000'),
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              onPressed: onToggleAadhaarVisibility,
                              icon: Icon(
                                aadhaarVisible
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: primaryColor,
                              ),
                              tooltip: aadhaarVisible
                                  ? 'Hide Aadhaar'
                                  : 'Show Aadhaar',
                            ),
                          ],
                        ),
                        if (field.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              field.errorText ?? 'Aadhaar Number is required.',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 8),
                        if (otpHintText != null && otpHintText!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline,
                                    color: secondaryColor, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    otpHintText!,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: secondaryColor, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Please ensure your Aadhaar-linked mobile number is active because OTP verification will be sent to the registered mobile number.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Terms and Conditions *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' I am voluntarily sharing my Aadhaar Number / Virtual ID issued by the Unique Identification Authority of India ("UIDAI"), and my demographic information for the purpose of creating an      Ayushman Bharat Health Account number ("ABHA number") and Ayushman Bharat Health Account address ("ABHA Address"). I authorize NHA to use my Aadhaar number / Virtual ID for performing   Aadhaar based authentication with UIDAI as per the provisions of the Aadhaar (Targeted Delivery of Financial and other Subsidies, Benefits and Services) Act, 2016 for the aforesaid purpose. I understand that UIDAI will share my e-KYC details, or response of "Yes" with NHA upon successful authentication.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: secondaryTextColor,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FormField<bool>(
                        validator: (value) {
                          if (!shouldShowConsentError) return null;
                          if (!consentAccepted) {
                            return 'Please accept the Terms and Conditions.';
                          }
                          return null;
                        },
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: consentAccepted,
                                onChanged: onConsentChanged,
                                title: const Text('I Agree'),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: primaryColor,
                              ),
                              if (field.hasError)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 4),
                                  child: Text(
                                    field.errorText ??
                                        'Please accept the Terms and Conditions.',
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Authentication Type *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedAuthMethod,
                  decoration: buildInputDecoration(
                      labelText: 'Select Authentication Type'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Aadhaar OTP', child: Text('Aadhaar OTP')),
                    // DropdownMenuItem(
                    //     value: 'Fingerprint Authentication',
                    //     child: Text('Fingerprint Authentication')),
                    DropdownMenuItem(
                        value: 'Face Authentication',
                        child: Text('Face Authentication')),
                  ],
                  onChanged: onAuthMethodChanged,
                  validator: (value) {
                    if (!shouldShowAuthMethodError) return null;
                    if (value == null || value.isEmpty) {
                      return 'Please select an authentication method.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Human Verification *',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF7F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Solve the captcha below to continue.',
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(color: secondaryTextColor),
                            ),
                          ),
                          IconButton(
                            onPressed: onRefreshCaptcha,
                            icon: Icon(Icons.refresh_rounded,
                                color: primaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.security_rounded, color: primaryColor),
                            const SizedBox(width: 10),
                            Text(
                              '$captchaQuestion = ?',
                              style: theme.textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: captchaController,
                        keyboardType: TextInputType.number,
                        decoration:
                            buildInputDecoration(labelText: 'Enter Answer'),
                        onChanged: (_) => onCaptchaChanged(),
                        validator: (value) {
                          if (!shouldShowCaptchaError) return null;
                          if ((value ?? '').trim().isEmpty) {
                            return 'Answer is required.';
                          }
                          if ((value ?? '').trim() != captchaAnswer) {
                            return 'Please enter the correct captcha answer.';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: isSubmitting ? null : onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryTextColor,
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: isSubmitting || !canProceed
                          ? null
                          : () async {
                              await onNext();
                            },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(isSubmitting ? 'Please wait...' : 'Next'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ), // Column
          ), // Form
        ), // Container
      ), // ConstrainedBox
    ); // Center
  }
}
