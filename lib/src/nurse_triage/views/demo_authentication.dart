import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/nurse_triage/controller/demo_auth_controller.dart';
import 'package:taei_gov/src/nurse_triage/controller/nurse_triage_controller.dart';
import 'package:taei_gov/src/nurse_triage/models/lgd_models.dart';
import 'package:taei_gov/utils/common/error_dialog.dart';

class DemoAuthenticationScreen extends StatefulWidget {
  const DemoAuthenticationScreen({super.key});

  @override
  State<DemoAuthenticationScreen> createState() => _DemoAuthenticationScreenState();
}

class _DemoAuthenticationScreenState extends State<DemoAuthenticationScreen> {
  final _formKey = GlobalKey<FormState>();
  final DemoAuthController _demoController = Get.put(DemoAuthController());
  final NurseTriageController _nurseController =
      Get.isRegistered<NurseTriageController>()
          ? Get.find<NurseTriageController>()
          : Get.put(NurseTriageController());

  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();

  String? _selectedGender;
  bool _consentAccepted = false;
  bool _isSubmitting = false;
  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    final aadhaar = (_nurseController.createTriageModel.value?.triage?.aadhaar ?? '')
        .replaceAll(RegExp(r'\D'), '');
    if (aadhaar.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) return;
        await CommonErrorDialog.show(
          context,
          message:
              'Aadhaar information is unavailable. Please restart the ABHA enrollment process.',
        );
        if (mounted) {
          Navigator.of(context).maybePop();
        }
      });
    }
    _didInit = true;
  }

  @override
  void dispose() {
    _dobController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  String get _aadhaarValue {
    final aadhaar = (_nurseController.createTriageModel.value?.triage?.aadhaar ?? '')
        .replaceAll(RegExp(r'\D'), '');
    if (aadhaar.isEmpty) return '';
    if (aadhaar.length <= 4) return aadhaar;
    final visible = aadhaar.substring(aadhaar.length - 4);
    return '${'*' * (aadhaar.length - 4)} $visible';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked == null) return;

    final formatted = DateFormat('dd-MM-yyyy').format(picked);
    _dobController.text = formatted;
  }

  Map<String, dynamic> _buildExistingProfilePayload(Map<String, dynamic> response) {
    final result = response['result'];
    final profileMap = result is Map ? Map<String, dynamic>.from(result as Map) : <String, dynamic>{};
    final profileId = response['profileId'];
    final parsedProfileId = int.tryParse(profileId?.toString() ?? '');

    final normalizedProfile = <String, dynamic>{
      ...profileMap,
      if (parsedProfileId != null) 'profileId': parsedProfileId,
      if (parsedProfileId != null) 'id': parsedProfileId,
      if (profileMap['ABHANumber'] == null &&
          profileMap['abhaNumber'] == null &&
          profileMap['healthIdNumber'] != null)
        'ABHANumber': profileMap['healthIdNumber'],
      if (profileMap['ABHANumber'] == null &&
          profileMap['abhaNumber'] == null &&
          profileMap['healthIdNumber'] != null)
        'abhaNumber': profileMap['healthIdNumber'],
      if (profileMap['mobile'] == null && profileMap['mobileNumber'] != null)
        'mobile': profileMap['mobileNumber'],
    };

    return {
      'result': {
        'ABHAProfile': normalizedProfile,
        'profileId': parsedProfileId,
        'id': parsedProfileId,
      },
      'profileId': parsedProfileId,
      'ABHAProfile': normalizedProfile,
      'id': parsedProfileId,
    };
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final aadhaar = (_nurseController.createTriageModel.value?.triage?.aadhaar ?? '')
        .replaceAll(RegExp(r'\D'), '');

    if (aadhaar.isEmpty) {
      await CommonErrorDialog.show(
        context,
        message: 'Aadhaar information is unavailable. Please restart the ABHA enrollment process.',
      );
      return;
    }

    if (!_consentAccepted) {
      await CommonErrorDialog.show(
        context,
        message: 'Please accept the consent to continue.',
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await _demoController.submitDemoAuth(
      aadhaar: aadhaar,
      stateName: _demoController.selectedStateName.value ?? '',
      districtName: _demoController.selectedDistrictName.value ?? '',
      dateOfBirth: _dobController.text,
      gender: _selectedGender ?? '',
      name: _nameController.text,
      mobile: _mobileController.text,
      pinCode: _pinCodeController.text,
      consentAccepted: _consentAccepted,
    );

    if (!mounted) return;

    if (!success) {
      final message = _demoController.errorMessage.value.isNotEmpty
          ? _demoController.errorMessage.value
          : 'Demo authentication failed. Please try again.';
      await CommonErrorDialog.show(context, message: message);
      setState(() => _isSubmitting = false);
      return;
    }

    final response = _demoController.responseData.value;
    final profileId = _demoController.profileId.value;

    if (response == null || profileId == null || profileId <= 0) {
      await CommonErrorDialog.show(
        context,
        message: 'ABHA profile was created, but the profile ID could not be retrieved.',
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final profilePayload = _buildExistingProfilePayload(response);
    _nurseController.aadhaarProfileData.value = profilePayload;
    _nurseController.currentProfileId.value = profileId.toString();
    _nurseController.createTriageModel.value?.triage?.abhaProfileId = profileId;
    _nurseController.createTriageModel.refresh();

    final debugProfilePayload = profilePayload['result']?['ABHAProfile'];
    debugPrint('[ABHA][DEMO-AUTH] SUCCESS');
    debugPrint('[ABHA][DEMO-AUTH] PROFILE ID: $profileId');
    debugPrint('[ABHA][DEMO-AUTH] Profile data received: ${debugProfilePayload != null ? debugProfilePayload.keys.toList() : 'none'}');
    debugPrint('[ABHA][DEMO-AUTH] OPENING EXISTING ABHA PROFILE');

    await _nurseController.showAadhaarSuccessDialog(profilePayload, showDialog: true);

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.of(context).maybePop();
    }
  }

  InputDecoration _buildInputDecoration({String? labelText, String? hintText}) {
    final borderColor = const Color(0xFFE0E0E0);
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade600),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade600, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Demo Authentication'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Authentication',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Verify your identity using Aadhaar demographic information.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF616161),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Aadhaar Number',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        readOnly: true,
                        initialValue: _aadhaarValue,
                        decoration: _buildInputDecoration(
                          labelText: 'Aadhaar Number',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'This Aadhaar number will be used for Demo Authentication.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF616161),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'State',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => DropdownButtonFormField<String>(
                          value: _demoController.selectedStateName.value,
                          validator: (value) => _demoController.validateState(value),
                          decoration: _buildInputDecoration(
                            labelText: 'State *',
                          ),
                          items: _demoController.availableStates
                              .map((state) => DropdownMenuItem(
                                    value: state.name,
                                    child: Text(state.name),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              _demoController.selectState(value);
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'District',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () {
                          final isStateSelected = _demoController.selectedStateName.value != null &&
                              _demoController.selectedStateName.value!.isNotEmpty;
                          return DropdownButtonFormField<String>(
                            value: _demoController.selectedDistrictName.value,
                            validator: (value) => _demoController.validateDistrict(value),
                            decoration: _buildInputDecoration(
                              labelText: 'District *',
                            ).copyWith(
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                              ),
                            ),
                            disabledHint: !isStateSelected
                                ? const Text('Please select State first')
                                : const Text('Select District'),
                            items: _demoController.availableDistricts
                                .map((district) => DropdownMenuItem(
                                      value: district.name,
                                      child: Text(district.name),
                                    ))
                                .toList(),
                            onChanged: isStateSelected
                                ? (value) {
                                    if (value != null) {
                                      _demoController.selectDistrict(value);
                                    }
                                  }
                                : null,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _dobController,
                        readOnly: true,
                        validator: (value) => _demoController.validateDob(value),
                        decoration: _buildInputDecoration(
                          labelText: 'Date of Birth *',
                          hintText: 'DD-MM-YYYY',
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today_rounded),
                            onPressed: _pickDate,
                          ),
                        ),
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedGender,
                        validator: (value) => _demoController.validateGender(value),
                        decoration: _buildInputDecoration(
                          labelText: 'Gender *',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'M', child: Text('Male')),
                          DropdownMenuItem(value: 'F', child: Text('Female')),
                          DropdownMenuItem(value: 'O', child: Text('Other')),
                        ],
                        onChanged: (value) => setState(() => _selectedGender = value),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) => _demoController.validateName(value),
                        decoration: _buildInputDecoration(
                          labelText: 'Full Name *',
                          hintText: 'Jeeva Suresh',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        validator: (value) => _demoController.validateMobile(value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: _buildInputDecoration(
                          labelText: 'Mobile Number',
                          hintText: '9047234229',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _pinCodeController,
                        keyboardType: TextInputType.number,
                        validator: (value) => _demoController.validatePinCode(value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: _buildInputDecoration(
                          labelText: 'PIN Code',
                          hintText: '632514',
                        ),
                      ),
                      const SizedBox(height: 20),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _consentAccepted,
                        onChanged: (value) => setState(() => _consentAccepted = value ?? false),
                        title: const Text(
                          'I consent to the collection and processing of my information for ABHA authentication/enrollment.',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: _isSubmitting ? null : () => Navigator.of(context).maybePop(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _isSubmitting ? null : _submit,
                            icon: _isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.arrow_forward_rounded),
                            label: Text(
                              _isSubmitting ? 'Authenticating...' : 'Continue',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
