import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:taei_gov/constants/urls.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/services/abha_error_message_service.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';
import 'package:taei_gov/utils/helpers/http_helper.dart';

class AbhaAddressCreationStep extends StatefulWidget {
  const AbhaAddressCreationStep({
    super.key,
    required this.formKey,
    required this.theme,
    required this.primaryColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.healthIdController,
    required this.onCreate,
    required this.isSubmitting,
    required this.buildInputDecoration,
    required this.validateHealthId,
    this.verificationResponse,
  });

  final GlobalKey<FormState> formKey;
  final ThemeData theme;
  final Color primaryColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final TextEditingController healthIdController;
  final Future<void> Function() onCreate;
  final bool isSubmitting;
  final InputDecoration Function(
      {String? labelText,
      String? hintText,
      String? counterText}) buildInputDecoration;
  final String? Function(String? value) validateHealthId;
  final Map<String, dynamic>? verificationResponse;

  @override
  State<AbhaAddressCreationStep> createState() =>
      _AbhaAddressCreationStepState();
}

class _AbhaAddressCreationStepState extends State<AbhaAddressCreationStep> {
  final _client = CustomHttpHelper();
  final _controller = Get.find<NurseTriageController>();

  bool _isLoadingSuggestions = true;
  bool _createCustomAddress = false;
  bool _isCreatingAddress = false;
  String? _selectedSuggestion;
  List<String> _suggestions = <String>[];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  Future<void> _loadSuggestions() async {
    final txnId = _controller.aadhaarTxnId.value;
    if (txnId.trim().isEmpty) {
      setState(() {
        _isLoadingSuggestions = false;
        _errorMessage = 'Missing transaction ID for address suggestions.';
      });
      return;
    }

    try {
      final response = await _client.get(
        Uri.parse(Urls.abhaAddressSuggestions),
        headers: {
          'Transaction_Id': txnId,
        },
      );

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        final values =
            decoded['abhaAddressList'] as List<dynamic>? ?? <dynamic>[];
        setState(() {
          _suggestions = values.map((e) => e.toString()).toList();
          _isLoadingSuggestions = false;
          _errorMessage = '';
          if (_suggestions.isNotEmpty) {
            _selectedSuggestion = _suggestions.first;
          }
        });
        return;
      }

      setState(() {
        _isLoadingSuggestions = false;
        _errorMessage = AbhaErrorMessageService.map(
          {'statusCode': response.statusCode},
          context: 'abhaAddress',
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingSuggestions = false;
        _errorMessage = 'Unable to load ABHA address suggestions right now.';
      });
    }
  }

  Future<void> _createAbhaAddress() async {
    if (_isCreatingAddress || widget.isSubmitting) return;

    final txnId = _controller.aadhaarTxnId.value;
    if (txnId.trim().isEmpty) {
      await CommonErrorDialog.show(
        context,
        message: AbhaErrorMessageService.map(
          {'message': 'Invalid Transaction Id'},
          context: 'abhaAddressCreate',
        ),
      );
      return;
    }

    final address = _createCustomAddress
      ? widget.healthIdController.text
      : (_selectedSuggestion ?? '');

    if (address.isEmpty) {
      await CommonErrorDialog.show(
        context,
        message: 'Please enter an ABHA Address.',
      );
      return;
    }

    final validationMessage = _validateAddressUsername(address);
    if (validationMessage != null) {
      await CommonErrorDialog.show(context, message: validationMessage);
      return;
    }

    try {
      setState(() => _isCreatingAddress = true);
      final response = await _client.post(
        Uri.parse(Urls.abhaAddressCreate),
        headers: {
          'Content-Type': 'application/json',
          'Transaction_Id': txnId,
        },
        body: jsonEncode({
          'txnId': txnId,
          'abhaAddress': address,
          'preferred': 1,
        }),
      );

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body) as Map<String, dynamic>;
        decoded['statusCode'] = response.statusCode;
        if (AbhaErrorMessageService.isFailure(decoded)) {
          await CommonErrorDialog.showFromResponse(
            context,
            response: decoded,
          );
          return;
        }
        final payload = decoded['result'] ?? decoded['data'] ?? decoded;
        if (payload is Map<String, dynamic>) {
          _controller.aadhaarProfileData.value = payload;
        }
        final result = await _controller.showAadhaarSuccessDialog(
          payload,
          returnToCaller: true,
        );
        if (mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop(result);
        }
        return;
      }

      final decoded = response.body.trim().isEmpty
          ? <String, dynamic>{}
          : jsonDecode(response.body);
        final payload = decoded is Map<String, dynamic>
          ? {...decoded, 'statusCode': response.statusCode}
          : {'message': decoded, 'statusCode': response.statusCode};
      await CommonErrorDialog.showFromResponse(
        context,
        response: payload,
      );
    } catch (_) {
      await CommonErrorDialog.show(
        context,
        message: AbhaErrorMessageService.map(
          const {'message': 'network error'},
          context: 'abhaAddressCreate',
        ),
      );
    } finally {
      if (mounted) setState(() => _isCreatingAddress = false);
    }
  }

  String? _validateAddressUsername(String value) {
    if (value.trim().isEmpty) return 'Please enter an ABHA Address.';
    final username = value;
    if (username.length < 8) {
      return 'ABHA Address must be at least 8 characters.';
    }
    if (username.length > 18) {
      return 'ABHA Address can contain a maximum of 18 characters.';
    }
    if (username.contains(' ')) {
      return 'Spaces are not allowed in an ABHA Address.';
    }
    if (!RegExp(r'^[A-Za-z0-9._]+$').hasMatch(username)) {
      return 'Only English letters, numbers, one dot (.) or one underscore (_) are allowed.';
    }
    if (username.startsWith('.')) return 'Dot (.) cannot be the first character.';
    if (username.startsWith('_')) {
      return 'Underscore (_) cannot be the first character.';
    }
    if (username.endsWith('.')) return 'Dot (.) cannot be the last character.';
    if (username.endsWith('_')) {
      return 'Underscore (_) cannot be the last character.';
    }
    if ('.'.allMatches(username).length > 1) {
      return 'Only one dot (.) is allowed in an ABHA Address.';
    }
    if ('_'.allMatches(username).length > 1) {
      return 'Only one underscore (_) is allowed in an ABHA Address.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16)
        ],
      ),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ABHA Address',
              style: widget.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: widget.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a suggested ABHA address or create a custom address to continue.',
              style: widget.theme.textTheme.bodyMedium
                  ?.copyWith(color: widget.secondaryTextColor),
            ),
            const SizedBox(height: 16),
            if (widget.verificationResponse != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F8FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Text(
                  'Verification data received. You can continue with ABHA address creation.',
                  style: widget.theme.textTheme.bodySmall
                      ?.copyWith(color: widget.secondaryTextColor),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (_isLoadingSuggestions)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else ...[
              ..._suggestions.map((suggestion) {
                final isSelected = _selectedSuggestion == suggestion;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? widget.primaryColor
                          : const Color(0xFFE0E0E0),
                    ),
                  ),
                  child: RadioListTile<String>(
                    value: suggestion,
                    groupValue: _selectedSuggestion,
                    onChanged: (value) {
                      setState(() {
                        _selectedSuggestion = value;
                        _createCustomAddress = false;
                      });
                    },
                    title: Text(suggestion),
                    activeColor: widget.primaryColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                );
              }).toList(),
            ],
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _createCustomAddress,
              onChanged: (value) {
                setState(() {
                  _createCustomAddress = value ?? false;
                  if (!_createCustomAddress) {
                    widget.healthIdController.clear();
                  }
                });
              },
              title: const Text('Create Custom ABHA Address'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: widget.healthIdController,
              enabled: _createCustomAddress,
              textCapitalization: TextCapitalization.none,
              decoration: widget.buildInputDecoration(
                labelText: 'Custom ABHA Address',
                hintText: 'create_custom_address',
              ),
              maxLength: 18,
              inputFormatters: [
                LengthLimitingTextInputFormatter(18),
              ],
              validator: _createCustomAddress
                  ? (value) => _validateAddressUsername(value ?? '')
                  : (_) => null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.isSubmitting || _isCreatingAddress
                    ? null
                    : _createAbhaAddress,
                icon: const Icon(Icons.check_circle_outline),
                label: Text(
                  _isCreatingAddress ? 'Please wait...' : 'Create ABHA Address',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
