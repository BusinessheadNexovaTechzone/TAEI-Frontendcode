import 'package:flutter/material.dart';

class CommunicationDetailsStep extends StatelessWidget {
  const CommunicationDetailsStep({
    super.key,
    required this.formKey,
    required this.theme,
    required this.primaryColor,
    required this.borderColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.fullNameController,
    required this.emailController,
    required this.skipContactDetails,
    required this.onSkipChanged,
    required this.onContinue,
    required this.buildInputDecoration,
    required this.validateFullName,
    required this.validateEmail,
  });

  final GlobalKey<FormState> formKey;
  final ThemeData theme;
  final Color primaryColor;
  final Color borderColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final bool skipContactDetails;
  final void Function(bool?) onSkipChanged;
  final VoidCallback onContinue;
  final InputDecoration Function(
      {String? labelText,
      String? hintText,
      String? counterText}) buildInputDecoration;
  final String? Function(String? value) validateFullName;
  final String? Function(String? value) validateEmail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contact Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primaryTextColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Complete your contact details to continue and receive your ABHA card.',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: secondaryTextColor),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: fullNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: buildInputDecoration(labelText: 'Full Name'),
                  validator: validateFullName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      buildInputDecoration(labelText: 'Email (optional)'),
                  validator: validateEmail,
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: skipContactDetails,
                  onChanged: onSkipChanged,
                  title: const Text('Skip for now'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        onContinue();
                      }
                    },
                    icon: const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Continue'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
