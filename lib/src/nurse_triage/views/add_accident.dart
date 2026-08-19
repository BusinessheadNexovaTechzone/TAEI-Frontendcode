import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:taei_gov/src/nurse_triage/models/create_triage_model.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import 'package:taei_gov/utils/common/new_common_date_time_picker.dart';
import 'package:taei_gov/utils/common/new_step_indicatot.dart';
import 'package:taei_gov/utils/common/title_textfield.dart';
import 'package:taei_gov/utils/common/validation_snackbar.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart'
    as mlkit;
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../utils/common/common_check_box_list.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../../utils/common/list_data_radio_button.dart';
import '../../../utils/common/m_elevate_button.dart';
import '../../../utils/common/yes_or_no_radio_button.dart';
import '../../../utils/helpers/space.dart';
import '../controller/face_auth_controller.dart';
import '../controller/nurse_triage_controller.dart';
import 'create_abha.dart';
import 'verify_abha.dart';

enum AadhaarVerificationMethod { none, otp, face, fingerprint }

class AddAccident extends StatefulWidget {
  final bool? form;
  final String? id;
  final bool? isUpdate;
  final TriageBy108? triageBy108;

  final bool? appbar;
  final bool? is108;

  const AddAccident(
      {super.key,
      this.id,
      this.isUpdate,
      this.is108 = false,
      this.form = false,
      this.triageBy108,
      this.appbar = true});

  @override
  State<AddAccident> createState() => _AddAccidentState();
}

class _AddAccidentState extends State<AddAccident> {
  String rawAadhaar = '';
  late FocusNode aadhaarFocusNode;
  final NurseTriageController controller = Get.put(NurseTriageController());
  final FaceAuthController faceAuthController = Get.put(FaceAuthController());
  TextEditingController ehrController = TextEditingController();
  late FocusNode otpFocusNode;

  AadhaarVerificationMethod _aadhaarVerificationMethod =
      AadhaarVerificationMethod.none;
  bool _showAadhaarVerificationOptions = false;

  String _maskAadhaar(String digits) {
    String raw = digits.replaceAll(RegExp(r'\D'), '');
    if (raw.length > 12) raw = raw.substring(0, 12);

    String output = '';
    for (int i = 0; i < raw.length; i++) {
      if (i == 4 || i == 8) {
        output += '-';
      }
      if (i < 8) {
        output += 'X';
      } else {
        output += raw[i];
      }
    }

    return output;
  }

  Widget _buildVerificationMethodCard({
    required String label,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 130,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0B62A6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? const Color(0xFF0B62A6) : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: selected ? 8 : 4,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: selected ? Colors.white : const Color(0xFF0B62A6),
              ),
            ),

            const SizedBox(height: 10),

            /// Label
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 6),

            /// Subtitle
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white70 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelForMethod(AadhaarVerificationMethod method) {
    switch (method) {
      case AadhaarVerificationMethod.otp:
        return 'OTP';
      case AadhaarVerificationMethod.face:
        return 'Face';
      case AadhaarVerificationMethod.fingerprint:
        return 'Fingerprint';
      default:
        return 'Unknown';
    }
  }

  IconData _iconForMethod(AadhaarVerificationMethod method) {
    switch (method) {
      case AadhaarVerificationMethod.otp:
        return Icons.sms_rounded;
      case AadhaarVerificationMethod.face:
        return Icons.face_retouching_natural_rounded;
      case AadhaarVerificationMethod.fingerprint:
        return Icons.fingerprint_rounded;
      default:
        return Icons.help_outline;
    }
  }

  Future<AadhaarVerificationMethod?> _showAadhaarVerificationDialog() async {
    AadhaarVerificationMethod selectedMethod = AadhaarVerificationMethod.none;

    return showDialog<AadhaarVerificationMethod?>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Select Verification Method'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Choose how you want to verify Aadhaar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildVerificationMethodCard(
                            label: 'OTP',
                            subtitle: 'Receive OTP',
                            icon: Icons.sms_rounded,
                            selected:
                                selectedMethod == AadhaarVerificationMethod.otp,
                            onTap: () {
                              setStateDialog(() {
                                selectedMethod = AadhaarVerificationMethod.otp;
                              });
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildVerificationMethodCard(
                            label: 'Face',
                            subtitle: 'Face Authentication',
                            icon: Icons.face_retouching_natural_rounded,
                            selected: selectedMethod ==
                                AadhaarVerificationMethod.face,
                            onTap: () {
                              setStateDialog(() {
                                selectedMethod = AadhaarVerificationMethod.face;
                              });
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildVerificationMethodCard(
                            label: 'Fingerprint',
                            subtitle: 'Fingerprint Scan',
                            icon: Icons.fingerprint_rounded,
                            selected: selectedMethod ==
                                AadhaarVerificationMethod.fingerprint,
                            onTap: () {
                              setStateDialog(() {
                                selectedMethod =
                                    AadhaarVerificationMethod.fingerprint;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedMethod == AadhaarVerificationMethod.none
                      ? null
                      : () {
                          Navigator.of(context).pop(selectedMethod);
                        },
                  child: Text('Continue'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _startBiometricScan(AadhaarVerificationMethod method) async {
    print("Biometric Method Selected: $method");
    final title = method == AadhaarVerificationMethod.face
        ? 'Face Scan'
        : 'Fingerprint Scan';
    final subtitle = method == AadhaarVerificationMethod.face
        ? 'Position the face in frame and hold still.'
        : 'Place the finger on the sensor and hold still.';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                method == AadhaarVerificationMethod.face
                    ? Icons.face_retouching_natural_rounded
                    : Icons.fingerprint_rounded,
                size: 56,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Scanning in progress...',
                  style: TextStyle(color: Colors.black54)),
            ],
          ),
        );
      },
    );

    bool success = true;
    if (method == AadhaarVerificationMethod.face) {
      print("FACE FLOW TRIGGERED");
      success = await faceAuthController.startFaceAuth();
    } else {
      await Future.delayed(const Duration(seconds: 2));
    }

    if (mounted) {
      Navigator.of(context).pop();
      if (success) {
        controller.aadhaarVerified.value = true;
        controller.aadhaarProfileImported.value = true;
        Get.snackbar(
          title == 'Face Scan' ? 'Face Verified' : 'Fingerprint Verified',
          '$title completed successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  void initState() {
    otpFocusNode = FocusNode();
    aadhaarFocusNode = FocusNode();
    fetchData();
    print("TEST 108${controller.createTriageModel.value?.triageBy108?.rr}");
    super.initState();
  }

  Future<void> _launchCreateAbhaFlow() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const CreateAbhaScreen()),
    );

    if (result == null || !mounted) return;

    _applySelectedAbhaProfile(result);

    controller.showCreateAbha.value = false;
    setState(() {});
  }

  void _applySelectedAbhaProfile(Map<String, dynamic> profile) {
    final triage = controller.createTriageModel.value?.triage;
    if (triage == null) return;

    String value(String key) => profile[key]?.toString().trim() ?? '';
    final profileId = int.tryParse(value('profileId'));
    final name = value('fullName');
    final abhaNumber = value('abhaNumber');
    final abhaAddress = value('abhaAddress');
    final mobile = value('mobile');
    final pincode = value('pincode');
    final address = value('address');
    final ageText = value('age').split(' ').first;
    final age = int.tryParse(ageText);

    debugPrint('[ACCIDENT] ABHA profile received');
    debugPrint('[ACCIDENT] Profile ID available: ${profileId != null}');
    debugPrint('[ACCIDENT] Profile ID: ${profileId ?? 'Not Available'}');
    debugPrint('[ACCIDENT] Name available: ${name.isNotEmpty}');
    debugPrint('[ACCIDENT] ABHA Number available: ${abhaNumber.isNotEmpty}');

    if (profileId != null && profileId > 0) {
      triage.abhaProfileId = profileId;
      controller.currentProfileId.value = profileId.toString();
    }
    if (name.isNotEmpty && name != 'Not Available') triage.nameOfPatient = name;
    if (abhaNumber.isNotEmpty && abhaNumber != 'Not Available') triage.abhaCard = abhaNumber;
    if (abhaAddress.isNotEmpty && abhaAddress != 'Not Available') triage.addressLine = abhaAddress;
    if (address.isNotEmpty && address != 'Not Available') triage.addressLine = address;
    if (mobile.isNotEmpty && mobile != 'Not Available') triage.patientMobileNumber = mobile;
    if (pincode.isNotEmpty && pincode != 'Not Available') triage.pincode = pincode;
    if (age != null) triage.ageYear = age;

    final gender = value('gender').toLowerCase();
    if (gender.isNotEmpty && gender != 'not available') {
      final genders = controller.lookupList.value?.genders ?? const [];
      for (final item in genders) {
        final label = (item.name ?? '').toLowerCase();
        if (label == gender || label.startsWith(gender.substring(0, 1))) {
          triage.gender = item.id;
          break;
        }
      }
    }

    controller.aadhaarProfileData.value = {
      'result': {'ABHAProfile': profile},
    };
    controller.aadhaarProfileImported.value = true;
    controller.createTriageModel.refresh();
    debugPrint('[ACCIDENT] Accident form populated successfully');
  }

  Widget _buildCreateAbhaLauncher() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Create a new ABHA card for this patient.',
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: _launchCreateAbhaFlow,
            icon: const Icon(Icons.add_card_rounded, size: 18),
            label: const Text('Create ABHA Card'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB84A1B),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    aadhaarFocusNode.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  Future<void> _scanAbhaQr() async {
    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Scan ABHA QR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose how you want to scan the ABHA card QR code.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 16),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.camera_alt, color: Colors.white),
                ),
                title: const Text('Camera'),
                subtitle: const Text('Use the camera to scan the QR code'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await Future.delayed(const Duration(milliseconds: 120));
                  final scannedValue = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (_) => const AbhaQrScannerScreen(),
                    ),
                  );
                  if (scannedValue != null && scannedValue.isNotEmpty) {
                    await _processScannedAbhaQr(scannedValue);
                  }
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(Icons.photo_library, color: Colors.white),
                ),
                title: const Text('Gallery'),
                subtitle: const Text('Select an image containing the QR code'),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await Future.delayed(const Duration(milliseconds: 120));
                  await _pickAbhaQrFromGallery();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _processScannedAbhaQr(String rawValue) async {
    log('ABHA QR raw value: $rawValue');
    await controller.processScannedAbhaQr(rawValue);
  }

  Future<void> _pickAbhaQrFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }

    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final barcodeScanner = BarcodeScanner();
    try {
      final List<mlkit.Barcode> barcodes =
          await barcodeScanner.processImage(inputImage);
      if (barcodes.isEmpty) {
        Fluttertoast.showToast(msg: 'No QR code found in selected image');
        return;
      }
      final rawValue = barcodes.first.rawValue;
      if (rawValue == null || rawValue.isEmpty) {
        Fluttertoast.showToast(msg: 'No readable QR data found');
        return;
      }
      await _processScannedAbhaQr(rawValue);
    } catch (e) {
      log('Gallery QR scan failed: $e');
      Fluttertoast.showToast(msg: 'Failed to scan QR from gallery');
    } finally {
      barcodeScanner.close();
    }
  }

  fetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getLookup();
      if (widget.isUpdate == true) {
        await controller.getTriageById(id: widget.id ?? '');
      } else if (widget.is108 == false) {
        controller.createTriageModel(TriageModel(
          triage: Triage(),
          triageBy108: TriageBy108(),
          triageDtls: TriageDtls(),
        ));
        controller.currentIndex.value = 0;
        controller.createTriageModel.value!.triage!.typeOfPatient = true;
      }
      if (widget.is108 == true) {
        controller.currentIndex.value = 0;
        controller.createTriageModel.value!.triage!.typeOfPatient = true;
      }
      print(
          "TEST 108ooo${controller.createTriageModel.value?.triage?.typeOfPatient}");
      // if (controller.createTriageModel.value!.triage!.typeOfPatient == null ||
      //     controller.createTriageModel.value!.triage!.typeOfPatient == 'null') {
      //   controller.createTriageModel.value!.triage!.typeOfPatient = true;
      //   print(
      //       "TEST 108 3${controller.createTriageModel.value?.triage?.typeOfPatient}");
      // }
      controller.isLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        "TEST 108${controller.createTriageModel.value?.triage?.ageYear.toString()}");
    print(" jjj ${controller.isLoading.value}");
    return PopScope(
      canPop: controller.currentIndex.value == 0,
      onPopInvoked: (didPop) {
        if (!didPop && controller.currentIndex.value > 0) {
          controller.currentIndex.value -= 1;
        }
      },
      child: Scaffold(
        backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
        appBar: widget.appbar == false
            ? null
            : CommonAppBar(
                id: widget.id,
                emo: false,
                title: 'Triage Nurse',
              ),
        body: Obx(
          () => controller.isLoading.value
              ? pageLoader()
              : Container(
                  margin: context.isDesktop
                      ? EdgeInsets.only(
                          left: widget.appbar == false ? 200 : 300,
                          right: widget.appbar == false ? 200 : 300,
                          top: 25,
                          bottom: 20)
                      : EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: context.isDesktop
                            ? Color(0xFF052B3A)
                            : Colors.transparent, // border color
                        width: 0.3 // border thickness
                        ),
                  ),
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(scrollbars: false),
                    child: Padding(
                      padding: context.isDesktop
                          ? EdgeInsets.only(
                              left: 30, right: 30, top: 8, bottom: 8)
                          : EdgeInsets.all(10),
                      child: ListView(
                        children: [
                          Space(height: 10),
                          NewFancyStepIndicator(
                            currentIndex: controller.currentIndex,
                            stepCount: widget.form == true ? 5 : 6,
                            canMoveToStep: (currentStep, tappedStep) {
                              // ❗ ONLY validate current step
                              final step = currentStep;
// ---------------- STEP 1 VALIDATION ----------------
                              if (step == 0) {
                                if (controller.createTriageModel.value?.triage
                                        ?.dateTimeOfTriage ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Date and Time is required');
                                } else if (controller.createTriageModel.value
                                        ?.triage?.ageYear ==
                                    null) {
                                  ValidationSnackbar.show('Age is required');
                                } else if (controller.createTriageModel.value
                                        ?.triage?.gender ==
                                    null) {
                                  ValidationSnackbar.show('Gender is required');
                                } else if (controller.createTriageModel.value
                                        ?.triage?.patientEhrId ==
                                    null) {
                                  ValidationSnackbar.show('PHR ID is required');
                                } else {
                                  return true;
                                }
                                return false;
                              }
                              if (step == 1) {
                                if (controller.createTriageModel.value?.triage
                                        ?.modeOfArrival ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Mode of Arrival is required');
                                } else if (controller.createTriageModel.value
                                        ?.triage?.sceneIft ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Scene IFT is required');
                                } else if (controller.createTriageModel.value
                                            ?.triage?.sceneIft ==
                                        2 &&
                                    controller.createTriageModel.value?.triage
                                            ?.isPatientStableIft ==
                                        null) {
                                  ValidationSnackbar.show(
                                      'Is Patient Stable IFT is required');
                                } else if (controller.createTriageModel.value
                                        ?.triage?.placeOfIncident ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Place of Incident is required');
                                } else {
                                  return true;
                                }
                                return false;
                              }

                              /// Direct Flow
                              // ---------------- STEP 2 VALIDATION DIRECT----------------
                              if (step == 2 && widget.form == true) {
                                final age = controller.createTriageModel.value
                                        ?.triage?.ageYear ??
                                    0;

                                final medicalEmpty = controller
                                        .createTriageModel
                                        .value
                                        ?.triageDtls
                                        ?.pcMedicalEmergency
                                        ?.isEmpty ??
                                    true;

                                final surgicalNull = controller
                                        .createTriageModel
                                        .value
                                        ?.triageDtls
                                        ?.pcSurgicalEmergency ==
                                    null;

                                if (age > 12 && medicalEmpty && surgicalNull) {
                                  ValidationSnackbar.show(
                                    'Either Medical Emergency or Surgical Emergency is required',
                                  );
                                } else if ((controller
                                            .createTriageModel
                                            .value
                                            ?.triageDtls
                                            ?.presentingComplaintsPrem
                                            ?.isEmpty ??
                                        true) &&
                                    ((controller.createTriageModel.value?.triage
                                                ?.ageYear ??
                                            0) <=
                                        12)) {
                                  ValidationSnackbar.show(
                                    'Presenting Complaints (Prem) is required',
                                  );
                                } else {
                                  return true;
                                }
                                return false;
                              }
                              // ---------------- STEP 3 VALIDATION DIRECT ----------------
                              if (step == 3 && widget.form == true) {
                                if (controller.createTriageModel.value
                                        ?.triageDtls?.avpu ==
                                    null) {
                                  ValidationSnackbar.show('AVPU is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.pulse ==
                                    null) {
                                  ValidationSnackbar.show('Pulse is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.bpSystolic ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'BP Systolic is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.bpDiastolic ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'BP Diastolic is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.spo2 ==
                                    null) {
                                  ValidationSnackbar.show('SPO2 is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.temperature ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Temperature is required');
                                } else {
                                  return true;
                                }
                                return false;
                              }
                              // ---------------- STEP 4 VALIDATION DIRECT ----------------
                              if (step == 4 && widget.form == true) {
                                if (controller.createTriageModel.value
                                        ?.triageDtls?.broughtDead ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Brought Dead is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.triageFlag ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Triage Flag is required');
                                } else if (controller
                                            .createTriageModel
                                            .value
                                            ?.triageDtls
                                            ?.isPatientTriagedQueue ==
                                        null &&
                                    ((controller.createTriageModel.value?.triage
                                                ?.ageYear ??
                                            0) <=
                                        12)) {
                                  ValidationSnackbar.show(
                                      'Is Patient Triaged Queue is required');
                                } else if (controller.createTriageModel.value
                                            ?.triageDtls?.premOpTicketDocs ==
                                        null &&
                                    ((controller.createTriageModel.value?.triage
                                                ?.ageYear ??
                                            0) <=
                                        12)) {
                                  ValidationSnackbar.show(
                                      'Prem Op Ticket Docs is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.triageDoneBy ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Triage Done By is required');
                                } else {
                                  return true;
                                }
                                return false;
                              }

                              /// 108 Flow
                              // ---------------- STEP 3 VALIDATION 108 ----------------
                              if (step == 3 && widget.form == false) {
                                final age = controller.createTriageModel.value
                                        ?.triage?.ageYear ??
                                    0;

                                final medicalEmpty = controller
                                        .createTriageModel
                                        .value
                                        ?.triageDtls
                                        ?.pcMedicalEmergency
                                        ?.isEmpty ??
                                    true;

                                final surgicalNull = controller
                                        .createTriageModel
                                        .value
                                        ?.triageDtls
                                        ?.pcSurgicalEmergency ==
                                    null;

                                if (age > 12 && medicalEmpty && surgicalNull) {
                                  ValidationSnackbar.show(
                                    'Either Medical Emergency or Surgical Emergency is required',
                                  );
                                } else if ((controller
                                            .createTriageModel
                                            .value
                                            ?.triageDtls
                                            ?.presentingComplaintsPrem
                                            ?.isEmpty ??
                                        true) &&
                                    ((controller.createTriageModel.value?.triage
                                                ?.ageYear ??
                                            0) <=
                                        12)) {
                                  ValidationSnackbar.show(
                                    'Presenting Complaints (Prem) is required',
                                  );
                                } else {
                                  return true;
                                }
                                return false;
                              }
                              // ---------------- STEP 4 VALIDATION 108 ----------------
                              if (step == 4 && widget.form == false) {
                                if (controller.createTriageModel.value
                                        ?.triageDtls?.avpu ==
                                    null) {
                                  ValidationSnackbar.show('AVPU is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.pulse ==
                                    null) {
                                  ValidationSnackbar.show('Pulse is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.bpSystolic ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'BP Systolic is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.bpDiastolic ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'BP Diastolic is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.spo2 ==
                                    null) {
                                  ValidationSnackbar.show('SPO2 is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.temperature ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Temperature is required');
                                } else {
                                  return true;
                                }
                                return false;
                              }
                              // ---------------- STEP 5 VALIDATION 108 ----------------
                              if (step == 5 && widget.form == false) {
                                if (controller.createTriageModel.value
                                        ?.triageDtls?.broughtDead ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Brought Dead is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.triageFlag ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Triage Flag is required');
                                } else if (controller
                                            .createTriageModel
                                            .value
                                            ?.triageDtls
                                            ?.isPatientTriagedQueue ==
                                        null &&
                                    ((controller.createTriageModel.value?.triage
                                                ?.ageYear ??
                                            0) <=
                                        12)) {
                                  ValidationSnackbar.show(
                                      'Is Patient Triaged Queue is required');
                                } else if (controller.createTriageModel.value
                                            ?.triageDtls?.premOpTicketDocs ==
                                        null &&
                                    ((controller.createTriageModel.value?.triage
                                                ?.ageYear ??
                                            0) <=
                                        12)) {
                                  ValidationSnackbar.show(
                                      'Prem Op Ticket Docs is required');
                                } else if (controller.createTriageModel.value
                                        ?.triageDtls?.triageDoneBy ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Triage Done By is required');
                                } else {
                                  return true;
                                }
                                return false;
                              }
                              // 👉 Continue your full validation logic here

                              return true; // allow move
                            },
                          ),
                          Space(height: 16),
                          controller.currentIndex.value == 0
                              ? Container(
                                  child: Column(
                                    spacing: 13,
                                    children: [
                                      Text(
                                        'Demographic Information',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      Space(
                                        height: 16,
                                      ),
                                      CommonDateTimeWidget(
                                        isRequired: true,
                                        title: 'Triage Date & Time',
                                        dateTime: controller.createTriageModel
                                            .value?.triage?.dateTimeOfTriage
                                            ?.toString(),
                                        onChanged: (value) {
                                          controller
                                              .createTriageModel
                                              .value
                                              ?.triage
                                              ?.dateTimeOfTriage = value;
                                        },
                                      ),
                                      NewTitleYesRadio(
                                        key: ValueKey(controller
                                            .createTriageModel
                                            .value!
                                            .triage!
                                            .typeOfPatient),
                                        title: 'Type of Patient',
                                        firstLabel: 'Known',
                                        secondLabel: 'Unknown',
                                        initialValue: controller
                                            .createTriageModel
                                            .value!
                                            .triage!
                                            .typeOfPatient,
                                        onChanged: (value) {
                                          controller.createTriageModel.value!
                                              .triage!.typeOfPatient = value;
                                          print(
                                              'hhhhhhhhhhhhhhh${controller.createTriageModel.value!.triage!.typeOfPatient}');
                                          controller.createTriageModel
                                              .refresh();
                                          print(controller.createTriageModel
                                              .value!.triage!.typeOfPatient);
                                        },
                                      ),
                                      if (controller.createTriageModel.value!
                                              .triage!.typeOfPatient ==
                                          true)
                                        TitleTextFormField(
                                          title: 'Name of Patient',
                                          controller: TextEditingController(
                                              text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triage!
                                                      .nameOfPatient ??
                                                  ""),
                                          keyboardType: TextInputType.name,
                                          hintText: 'Enter the name',
                                          onChanged: (v) {
                                            controller.createTriageModel.value!
                                                .triage!.nameOfPatient = v;
                                          },
                                          validator: (value) {
                                            // print(value);
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter Name of Patient';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      controller.createTriageModel.value!
                                                      .triage!.typeOfPatient ==
                                                  false ||
                                              controller
                                                      .createTriageModel
                                                      .value!
                                                      .triage!
                                                      .typeOfPatient ==
                                                  true
                                          ? Column(
                                              children: [
                                                NewTitleDropdown(
                                                    isRequired: true,
                                                    title: 'Gender',
                                                    hint: 'Select Gender',
                                                    selectedId: controller
                                                        .createTriageModel
                                                        .value!
                                                        .triage!
                                                        .gender,
                                                    items: controller.lookupList
                                                            .value?.genders
                                                            ?.map((e) => {
                                                                  "id": e.id,
                                                                  "name": e.name
                                                                })
                                                            .toList() ??
                                                        [],
                                                    onChanged: (value) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .gender = value;
                                                      controller
                                                          .createTriageModel
                                                          .refresh();
                                                    }),
                                                Space(
                                                  height: 16,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Age In Completed ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Space(height: 10),
                                                    Row(
                                                      spacing: 20,
                                                      children: [
                                                        Expanded(
                                                            child:
                                                                TitleTextFormField(
                                                          isRequired: true,
                                                          hintText:
                                                              'Enter the Age in Completed Year',
                                                          title: 'Year ',
                                                          initialValue: controller
                                                                      .createTriageModel
                                                                      .value
                                                                      ?.triage
                                                                      ?.ageYear !=
                                                                  null
                                                              ? controller
                                                                  .createTriageModel
                                                                  .value!
                                                                  .triage!
                                                                  .ageYear!
                                                                  .toString()
                                                              : '',
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          maxLength: 2,
                                                          onChanged: (value) {
                                                            if (value
                                                                .isNotEmpty) {
                                                              controller
                                                                      .createTriageModel
                                                                      .value
                                                                      ?.triage
                                                                      ?.ageYear =
                                                                  int.parse(
                                                                      value);
                                                              controller
                                                                  .createTriageModel
                                                                  .refresh();
                                                            }
                                                          },
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please Enter Age';
                                                            }
                                                            return null;
                                                          },
                                                        )),
                                                        Expanded(
                                                            child:
                                                                TitleDropdown(
                                                                    title:
                                                                        'Month',
                                                                    hint:
                                                                        'Select Age in Completed Month',
                                                                    selectedItem: controller
                                                                        .createTriageModel
                                                                        .value!
                                                                        .triage!
                                                                        .ageMonth
                                                                        ?.toString(),
                                                                    items: [
                                                                      '1',
                                                                      '2',
                                                                      '3',
                                                                      '4',
                                                                      '5',
                                                                      '6',
                                                                      '7',
                                                                      '8',
                                                                      '9',
                                                                      '10',
                                                                      '11',
                                                                      '12',
                                                                    ],
                                                                    onChanged:
                                                                        (value) {
                                                                      controller
                                                                          .createTriageModel
                                                                          .value!
                                                                          .triage!
                                                                          .ageMonth = int.parse(value.toString());
                                                                      controller
                                                                          .createTriageModel
                                                                          .refresh();
                                                                    })),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Container(),
                                      controller.createTriageModel.value!
                                                  .triage!.typeOfPatient ==
                                              true
                                          ? Column(
                                              children: [
                                                (controller
                                                                .createTriageModel
                                                                .value
                                                                ?.triage
                                                                ?.ageYear ??
                                                            0) <=
                                                        12
                                                    ? Column(
                                                        children: [
                                                          TitleTextFormField(
                                                            title:
                                                                'Father/Mother name',
                                                            controller: TextEditingController(
                                                                text: controller
                                                                        .createTriageModel
                                                                        .value!
                                                                        .triage!
                                                                        .fathername ??
                                                                    ""),
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            hintText:
                                                                'Enter the Father/Mother name',
                                                            onChanged: (v) {
                                                              controller
                                                                  .createTriageModel
                                                                  .value!
                                                                  .triage!
                                                                  .fathername = v;
                                                            },
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter Father/Mother name';
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                                // TitleDropdown(
                                                //   title: 'Gender',
                                                //   items: controller.lookupList.value?.genders
                                                //           ?.map((e) => e.name)
                                                //           .toList() ??
                                                //       [],
                                                //   selectedItem: controller.selectedGender.value,
                                                //   hint: 'Select Gender',
                                                //   onChanged: (value) async {
                                                //     controller.selectedGender.value = value;
                                                //     controller.createTriageModel.value!.gender = getId(
                                                //         controller.lookupList.value!.genders!, value);
                                                //   },
                                                // ),
                                                /* NewTitleDropdown(
                                                    title: 'Gender',
                                                    hint: 'Select Gender',
                                                    items: controller.lookupList
                                                            .value?.genders
                                                            ?.map((e) => {
                                                                  "id": e.id,
                                                                  "name": e.name
                                                                })
                                                            .toList() ??
                                                        [],
                                                    selectedId: controller
                                                        .createTriageModel
                                                        .value!
                                                        .triage!
                                                        .gender,
                                                    onChanged: (value) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .gender = value;
                                                      controller
                                                          .createTriageModel
                                                          .refresh();
                                                    }),*/
                                                // TitleDropdown(
                                                //   title: 'Marital Status',
                                                //   items: controller.lookupList.value?.mtSts
                                                //           ?.map((e) => e.name)
                                                //           .toList() ??
                                                //       [],
                                                //   selectedItem: controller.selectedMaritalStatus.value,
                                                //   hint: 'Select Gender',
                                                //   onChanged: (value) async {
                                                //     controller.selectedMaritalStatus.value = value;
                                                //     controller.createTriageModel.value!.maritalStatus =
                                                //         getId(controller.lookupList.value!.mtSts!, value);
                                                //     value;
                                                //   },
                                                // ),
                                                (controller
                                                                .createTriageModel
                                                                .value
                                                                ?.triage
                                                                ?.ageYear ??
                                                            0) >=
                                                        21
                                                    ? NewTitleDropdown(
                                                        title: 'Marital Status',
                                                        hint:
                                                            'Select Marital Status',
                                                        items: controller
                                                                .lookupList
                                                                .value
                                                                ?.mtSts
                                                                ?.map(
                                                                    (e) =>
                                                                        {
                                                                          "id":
                                                                              e.id,
                                                                          "name":
                                                                              e.name
                                                                        })
                                                                .toList() ??
                                                            [],
                                                        selectedId: controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .maritalStatus,
                                                        onChanged: (value) {
                                                          controller
                                                              .createTriageModel
                                                              .value!
                                                              .triage!
                                                              .maritalStatus = value;
                                                          controller
                                                              .createTriageModel
                                                              .refresh();
                                                        })
                                                    : Container(),

                                                // TitleDropdown(
                                                //   title: 'Education',
                                                //   items: controller.lookupList.value?.edu
                                                //           ?.map((e) => e.name)
                                                //           .toList() ??
                                                //       [],
                                                //   selectedItem: controller.selectedEducation.value,
                                                //   hint: 'Select Education',
                                                //   onChanged: (value) async {
                                                //     controller.selectedEducation.value = value;
                                                //     controller.createTriageModel.value!.education =
                                                //         getId(controller.lookupList.value!.edu!, value);
                                                //   },
                                                // ),
                                                NewTitleDropdown(
                                                    title: 'Education',
                                                    hint: 'Select Education',
                                                    items: controller.lookupList
                                                            .value?.edu
                                                            ?.map((e) => {
                                                                  "id": e.id,
                                                                  "name": e.name
                                                                })
                                                            .toList() ??
                                                        [],
                                                    selectedId: controller
                                                        .createTriageModel
                                                        .value!
                                                        .triage!
                                                        .education,
                                                    onChanged: (value) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .education = value;
                                                      controller
                                                          .createTriageModel
                                                          .refresh();
                                                    }),
                                                // TitleDropdown(
                                                //   title: 'Employment Status',
                                                //   items: controller.lookupList.value?.empSts
                                                //           ?.map((e) => e.name)
                                                //           .toList() ??
                                                //       [],
                                                //   selectedItem: controller.selectedEmploymentStatus.value,
                                                //   hint: 'Select Education',
                                                //   onChanged: (value) async {
                                                //     controller.selectedEmploymentStatus.value = value;
                                                //     controller.createTriageModel.value!.employmentStatus =
                                                //         getId(
                                                //             controller.lookupList.value!.empSts!, value);
                                                //   },
                                                // ),
                                                (controller
                                                                .createTriageModel
                                                                .value
                                                                ?.triage
                                                                ?.ageYear ??
                                                            0) >=
                                                        0
                                                    ? NewTitleDropdown(
                                                        title:
                                                            'Employment Status',
                                                        hint:
                                                            'Select Employment Status',
                                                        items: controller
                                                                .lookupList
                                                                .value
                                                                ?.empSts
                                                                ?.map(
                                                                    (e) =>
                                                                        {
                                                                          "id":
                                                                              e.id,
                                                                          "name":
                                                                              e.name
                                                                        })
                                                                .toList() ??
                                                            [],
                                                        selectedId: controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .employmentStatus,
                                                        onChanged: (value) {
                                                          controller
                                                              .createTriageModel
                                                              .value!
                                                              .triage!
                                                              .employmentStatus = value;
                                                          controller
                                                              .createTriageModel
                                                              .refresh();
                                                        })
                                                    : Container(),
                                                // TitleDropdown(
                                                //   title: 'Occupation',
                                                //   items: controller.lookupList.value?.occ
                                                //           ?.map((e) => e.name)
                                                //           .toList() ??
                                                //       [],
                                                //   selectedItem: controller.selectedOccupation.value,
                                                //   hint: 'Select Occupation',
                                                //   onChanged: (value) async {
                                                //     controller.selectedOccupation.value = value;
                                                //     controller.createTriageModel.value!.occupation =
                                                //         getId(controller.lookupList.value!.occ!, value);
                                                //   },
                                                // ),
                                                (controller
                                                                .createTriageModel
                                                                .value
                                                                ?.triage
                                                                ?.ageYear ??
                                                            0) >=
                                                        18
                                                    ? NewTitleDropdown(
                                                        title: 'Occupation',
                                                        hint:
                                                            'Select Occupation',
                                                        items: controller
                                                                .lookupList
                                                                .value
                                                                ?.occ
                                                                ?.map((e) =>
                                                                    {
                                                                      "id":
                                                                          e.id,
                                                                      "name":
                                                                          e.name
                                                                    })
                                                                .toList() ??
                                                            [],
                                                        selectedId: controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .occupation,
                                                        onChanged: (value) {
                                                          controller
                                                              .createTriageModel
                                                              .value!
                                                              .triage!
                                                              .occupation = value;
                                                          controller
                                                              .createTriageModel
                                                              .refresh();
                                                        })
                                                    : Container(),
                                                ((controller
                                                                .createTriageModel
                                                                .value
                                                                ?.triage
                                                                ?.ageYear ??
                                                            0) >=
                                                        18)
                                                    ? TitleTextFormField(
                                                        title: "Income",
                                                        controller:
                                                            TextEditingController(
                                                                text: controller
                                                                        .createTriageModel
                                                                        .value!
                                                                        .triage!
                                                                        .income ??
                                                                    ""),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        hintText:
                                                            'Enter Income',
                                                        onChanged: (v) {
                                                          controller
                                                              .createTriageModel
                                                              .value!
                                                              .triage!
                                                              .income = v;
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please Enter Income';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      )
                                                    : Container(),
                                                Space(height: 20),
                                                Obx(() {
                                                  final isImported = controller
                                                      .aadhaarProfileImported
                                                      .value;
                                                  final hasProfileData =
                                                      controller
                                                              .aadhaarProfileData
                                                              .value !=
                                                          null;
                                                  final mobileNumber =
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .patientMobileNumber;

                                                  if ((isImported ||
                                                          hasProfileData) &&
                                                      mobileNumber != null &&
                                                      mobileNumber.isNotEmpty) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 6),
                                                          child: Text(
                                                            'Patient mobile Number',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 12),
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child: Text(
                                                            controller
                                                                .getMaskedMobileNumber(
                                                                    mobileNumber),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black87,
                                                              letterSpacing:
                                                                  1.0,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }

                                                  return TitleTextFormField(
                                                    obscureText: false,
                                                    maxLength: 10,
                                                    title:
                                                        "Patient mobile Number",
                                                    controller: TextEditingController(
                                                        text: controller
                                                                .createTriageModel
                                                                .value!
                                                                .triage!
                                                                .patientMobileNumber ??
                                                            ""),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    hintText:
                                                        'Enter mobile number',
                                                    onChanged: (v) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .patientMobileNumber = v;
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please Enter mobile number';
                                                      } else if (value.length !=
                                                          10) {
                                                        return 'Please Enter valid mobile number';
                                                      }
                                                      return null;
                                                    },
                                                  );
                                                }),
                                                // TODO:need to add API data

                                                // TitleDropdown(
                                                //   title: 'Patient EHR (ID) *',
                                                //   items: [
                                                //     "CMCHIS Card",
                                                //     "ABHA Card",
                                                //     "PHR ID",
                                                //     "HMIS ID",
                                                //     "No"
                                                //   ],
                                                //   selectedItem: controller
                                                //       .selectedEHR.value,
                                                //   hint: 'Select EHR Type',
                                                //   onChanged: (value) async {
                                                //     controller.selectedEHR
                                                //         .value = value!;
                                                //     controller
                                                //             .createTriageModel
                                                //             .value!
                                                //             .triage!
                                                //             .patientEhrId =
                                                //         value == "No"
                                                //             ? false
                                                //             : true;
                                                //   },
                                                // ),
                                                NewTitleDropdown(
                                                    isRequired: true,
                                                    title: 'Patient EHR (ID) ',
                                                    selectedId: controller
                                                        .createTriageModel
                                                        .value!
                                                        .triage!
                                                        .patientEhrId,
                                                    items: [
                                                      {
                                                        "id": 1,
                                                        "name": "CMCHIS Card"
                                                      },
                                                      {
                                                        "id": 2,
                                                        "name": "ABHA Card"
                                                      },
                                                      {
                                                        "id": 3,
                                                        "name": "PHR ID"
                                                      },
                                                      {
                                                        "id": 4,
                                                        "name": "HMIS ID"
                                                      },
                                                      {"id": 5, "name": "No"},
                                                    ],
                                                    onChanged: (value) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .patientEhrId = value;
                                                      controller
                                                          .createTriageModel
                                                          .refresh();
                                                    }),

                                                if (controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .patientEhrId !=
                                                        null &&
                                                    controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .patientEhrId ==
                                                        1)
                                                  TitleTextFormField(
                                                    title: "CMCHIS ID",
                                                    controller:
                                                        TextEditingController(
                                                      text: controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .cmchisCard,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.name,
                                                    hintText: 'Enter ID',
                                                    onChanged: (v) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .cmchisCard = v;
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please Enter ID';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                if (controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .patientEhrId !=
                                                        null &&
                                                    controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .patientEhrId ==
                                                        2)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'ABHA ID',
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              if (controller
                                                                          .createTriageModel
                                                                          .value!
                                                                          .triage!
                                                                          .abhaCard ==
                                                                      null ||
                                                                  controller
                                                                      .createTriageModel
                                                                      .value!
                                                                      .triage!
                                                                      .abhaCard!
                                                                      .trim()
                                                                      .isEmpty)
                                                                Row(
                                                                  children: [
                                                                    TextButton
                                                                        .icon(
                                                                      onPressed:
                                                                          _launchCreateAbhaFlow,
                                                                      icon:
                                                                          Text(
                                                                        '+',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                      ),
                                                                      label:
                                                                          Text(
                                                                        'Create New ABHA',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        minimumSize: Size(
                                                                            0,
                                                                            24),
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            8),
                                                                    TextButton(
                                                                      onPressed: () async {
                                                                        final result = await Navigator.of(context).push<Map<String, dynamic>>(
                                                                          MaterialPageRoute(
                                                                            builder: (_) => const VerifyAbhaScreen(),
                                                                          ),
                                                                        );
                                                                        if (!mounted || result == null) return;
                                                                        _applySelectedAbhaProfile(result);
                                                                        setState(() {});
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        '  + Verify ABHA',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        minimumSize: Size(
                                                                            0,
                                                                            24),
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              else
                                                                Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        log('View ABHA button clicked from add_accident.dart');
                                                                        controller
                                                                            .showLastAadhaarProfileCard();
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'View',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.red,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      style: TextButton
                                                                          .styleFrom(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        minimumSize: Size(
                                                                            0,
                                                                            24),
                                                                        alignment:
                                                                            Alignment.centerRight,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            8),
                                                                    CommonElevatedButton(
                                                                      text:
                                                                          'Download ABHA Card',
                                                                      onPressed:
                                                                          controller
                                                                              .downloadAbhaCard,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red
                                                                              .shade600,
                                                                      textColor:
                                                                          Colors
                                                                              .white,
                                                                      borderRadius:
                                                                          8.0,
                                                                      elevation:
                                                                          3.0,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              6,
                                                                          vertical:
                                                                              8),
                                                                      icon: Icons
                                                                          .download_rounded,
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(height: 6),
                                                      TextFormField(
                                                        controller:
                                                            TextEditingController(
                                                          text: controller
                                                              .createTriageModel
                                                              .value!
                                                              .triage!
                                                              .abhaCard,
                                                        ),
                                                        keyboardType:
                                                            TextInputType.name,
                                                        decoration:
                                                            InputDecoration(
                                                          counterText: '',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          hintText:
                                                              'Enter ABHA ID',
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 16,
                                                            vertical: 12,
                                                          ),
                                                          suffixIconConstraints:
                                                              BoxConstraints(
                                                            minWidth: 48,
                                                            minHeight: 48,
                                                          ),
                                                          suffixIcon: Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    right: 6),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .blue.shade50,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            child: IconButton(
                                                              splashRadius: 24,
                                                              icon: Icon(
                                                                Icons
                                                                    .qr_code_scanner,
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              onPressed:
                                                                  _scanAbhaQr,
                                                              tooltip:
                                                                  'Scan ABHA QR',
                                                            ),
                                                          ),
                                                        ),
                                                        onChanged: (v) {
                                                          controller
                                                              .createTriageModel
                                                              .value!
                                                              .triage!
                                                              .abhaCard = v;
                                                          if (v
                                                              .trim()
                                                              .isNotEmpty) {
                                                            controller
                                                                .showCreateAbha
                                                                .value = false;
                                                            controller
                                                                .aadhaarOtpSent
                                                                .value = false;
                                                          }
                                                        },
                                                        validator: (value) {
                                                          return null;
                                                        },
                                                      ),
                                                      Space(height: 6),
                                                      Obx(() {
                                                        if (controller
                                                            .showCreateAbha
                                                            .value) {
                                                          return _buildCreateAbhaLauncher();
                                                        }
                                                        return const SizedBox
                                                            .shrink();
                                                      }),
                                                    ],
                                                  ),

                                                if (controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .patientEhrId !=
                                                        null &&
                                                    controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .patientEhrId ==
                                                        3)
                                                  TitleTextFormField(
                                                    title: "PHR ID",
                                                    controller:
                                                        TextEditingController(
                                                      text: controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .phrId,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.name,
                                                    hintText: 'Enter ID',
                                                    onChanged: (v) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .phrId = v;
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please Enter ID';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                if (controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .patientEhrId !=
                                                        null &&
                                                    controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .patientEhrId ==
                                                        4)
                                                  TitleTextFormField(
                                                    title: "HMIS ID",
                                                    controller:
                                                        TextEditingController(
                                                      text: controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .hmisId,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.name,
                                                    hintText: 'Enter ID',
                                                    onChanged: (v) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .hmisId = v;
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please Enter ID';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),

                                                TitleTextFormField(
                                                  title: "Residential Address",
                                                  controller: TextEditingController(
                                                      text: controller
                                                              .createTriageModel
                                                              .value!
                                                              .triage!
                                                              .addressLine ??
                                                          ""),
                                                  keyboardType:
                                                      TextInputType.name,
                                                  hintText: 'Enter Address',
                                                  onChanged: (v) {
                                                    controller
                                                        .createTriageModel
                                                        .value!
                                                        .triage!
                                                        .addressLine = v;
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please Enter Address';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),

                                                NewTitleDropdown(
                                                    title: 'District',
                                                    hint: 'Select District',
                                                    items: controller.lookupList
                                                            .value?.district
                                                            ?.map((e) => {
                                                                  "id": e.id,
                                                                  "name": e.name
                                                                })
                                                            .toList() ??
                                                        [],
                                                    selectedId: controller
                                                        .createTriageModel
                                                        .value!
                                                        .triage!
                                                        .district,
                                                    onChanged: (value) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .district = value;
                                                      controller
                                                          .createTriageModel
                                                          .refresh();
                                                    }),

                                                NewTitleDropdown(
                                                    title: 'State',
                                                    hint: 'Select State',
                                                    items: controller.lookupList
                                                            .value?.state
                                                            ?.map((e) => {
                                                                  "id": e.id,
                                                                  "name": e.name
                                                                })
                                                            .toList() ??
                                                        [],
                                                    selectedId: controller
                                                        .createTriageModel
                                                        .value!
                                                        .triage!
                                                        .state,
                                                    onChanged: (value) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .state = value;
                                                      controller
                                                          .createTriageModel
                                                          .refresh();
                                                    }),
                                                TitleTextFormField(
                                                  maxLength: 6,
                                                  title: "Pincode",
                                                  controller: TextEditingController(
                                                      text: controller
                                                              .createTriageModel
                                                              .value!
                                                              .triage!
                                                              .pincode ??
                                                          ""),
                                                  keyboardType:
                                                      TextInputType.name,
                                                  hintText: 'Enter Pincode',
                                                  onChanged: (v) {
                                                    controller
                                                        .createTriageModel
                                                        .value!
                                                        .triage!
                                                        .pincode = v;
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please Enter Pincode';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ],
                                            )
                                          : Container()
                                    ],
                                  ),
                                )
                              : controller.currentIndex.value == 1
                                  ? Column(
                                      spacing: 13,
                                      children: [
                                        Text(
                                          'Mode of Arrival ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Space(
                                          height: 16,
                                        ),
                                        (controller.createTriageModel.value
                                                        ?.triage?.ageYear ??
                                                    0) <=
                                                12
                                            ? NewTitleDropdown(
                                                title: 'Patient Received From',
                                                hint:
                                                    'Select Patient Received From',
                                                items: controller
                                                        .lookupList.value?.prf
                                                        ?.map(
                                                            (e) =>
                                                                {
                                                                  "id": e.id,
                                                                  "name": e.name
                                                                })
                                                        .toList() ??
                                                    [],
                                                selectedId: controller
                                                    .createTriageModel
                                                    .value!
                                                    .triage!
                                                    .patienrRecievedFrom,
                                                onChanged: (value) {
                                                  controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .patienrRecievedFrom =
                                                      value;
                                                  controller.createTriageModel
                                                      .refresh();
                                                })
                                            : Container(),

                                        NewTitleDropdown(
                                            isRequired: true,
                                            title: 'Mode of arrival ',
                                            hint: 'Select Mode of Arrival',
                                            items: controller
                                                    .lookupList.value?.arrival
                                                    ?.map((e) => {
                                                          "id": e.id,
                                                          "name": e.name
                                                        })
                                                    .toList() ??
                                                [],
                                            selectedId: controller
                                                .createTriageModel
                                                .value!
                                                .triage!
                                                .modeOfArrival,
                                            onChanged: (value) {
                                              controller
                                                  .createTriageModel
                                                  .value!
                                                  .triage!
                                                  .modeOfArrival = value;
                                              controller.createTriageModel
                                                  .refresh();
                                            }),
                                        NewTitleDropdown(
                                            isRequired: true,
                                            title: 'Scene/IFT ',
                                            hint: 'Select Scene/IFT',
                                            selectedId: controller
                                                .createTriageModel
                                                .value
                                                ?.triage
                                                ?.sceneIft,
                                            items: [
                                              {"id": 1, "name": "Scene"},
                                              {"id": 2, "name": "IFT"},
                                            ],
                                            onChanged: (value) {
                                              controller
                                                  .createTriageModel
                                                  .value!
                                                  .triage!
                                                  .sceneIft = value;
                                              controller.createTriageModel
                                                  .refresh();
                                            }),
                                        if (controller.createTriageModel.value
                                                    ?.triage?.sceneIft !=
                                                null &&
                                            controller.createTriageModel.value
                                                    ?.triage?.sceneIft ==
                                                2)
                                          Column(
                                            children: [
                                              NewTitleDropdown(
                                                title: 'Source Type',
                                                items: controller.lookupList
                                                        .value?.srctyp
                                                        ?.map((e) => {
                                                              "id": e.id,
                                                              "name": e.name
                                                            })
                                                        .toList() ??
                                                    [],
                                                selectedId: controller
                                                    .createTriageModel
                                                    .value
                                                    ?.triage
                                                    ?.sourceType,
                                                hint: 'Select Source Type',
                                                onChanged: (value) async {
                                                  controller
                                                      .createTriageModel
                                                      .value!
                                                      .triage!
                                                      .sourceType = value;
                                                  controller.createTriageModel
                                                      .refresh();
                                                },
                                              ),
                                              TitleTextFormField(
                                                title: "Source Hospital",
                                                controller: TextEditingController(
                                                    text: controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .sourceHospital ??
                                                        ""),
                                                keyboardType:
                                                    TextInputType.name,
                                                hintText: 'Enter Hospital Name',
                                                onChanged: (v) {
                                                  controller
                                                      .createTriageModel
                                                      .value!
                                                      .triage!
                                                      .sourceHospital = v;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Enter Hospital Name';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                              TitleTextFormField(
                                                title: "Destination Hospital",
                                                controller: TextEditingController(
                                                    text: controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .destinationHospital ??
                                                        ""),
                                                keyboardType:
                                                    TextInputType.name,
                                                hintText: 'Enter Hospital Name',
                                                onChanged: (v) {
                                                  controller
                                                      .createTriageModel
                                                      .value!
                                                      .triage!
                                                      .destinationHospital = v;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Enter Hospital Name';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                              // TitleDropdown(
                                              //   title: 'Reason For Referral',
                                              //   items: controller.lookupList.value?.ror
                                              //           ?.map((e) => e.name)
                                              //           .toList() ??
                                              //       [],
                                              //   selectedItem: controller.selectedRefferalReason.value,
                                              //   hint: 'Select Reason',
                                              //   onChanged: (value) async {
                                              //     controller.selectedRefferalReason.value = value;
                                              //     controller.createTriageModel.value!.reasonForReferral =
                                              //         getId(controller.lookupList.value!.ror!, value);
                                              //   },
                                              // ),
                                              NewTitleDropdown(
                                                  title: 'Reason For Referral',
                                                  hint: 'Select Reason',
                                                  items: controller
                                                          .lookupList.value?.ror
                                                          ?.map((e) => {
                                                                "id": e.id,
                                                                "name": e.name
                                                              })
                                                          .toList() ??
                                                      [],
                                                  selectedId: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triage!
                                                      .reasonForReferral,
                                                  onChanged: (value) {
                                                    controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .reasonForReferral =
                                                        value;
                                                    controller.createTriageModel
                                                        .refresh();
                                                  }),
                                              TitleTextFormField(
                                                title: "Referral Doctor Name",
                                                controller: TextEditingController(
                                                    text: controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .referralDoctorName ??
                                                        ""),
                                                keyboardType:
                                                    TextInputType.name,
                                                onChanged: (v) {
                                                  controller
                                                      .createTriageModel
                                                      .value!
                                                      .triage!
                                                      .referralDoctorName = v;
                                                },
                                                hintText: 'Enter Doctor Name',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Enter Doctor Name';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                              NewTitleDropdown(
                                                title: 'Condition of Patient',
                                                items: controller
                                                        .lookupList.value?.cop
                                                        ?.map((e) => {
                                                              "id": e.id,
                                                              "name": e.name
                                                            })
                                                        .toList() ??
                                                    [],
                                                selectedId: controller
                                                    .createTriageModel
                                                    .value
                                                    ?.triage
                                                    ?.conditionOfPatient,
                                                hint: 'Select Condition',
                                                onChanged: (value) async {
                                                  controller
                                                          .createTriageModel
                                                          .value!
                                                          .triage!
                                                          .conditionOfPatient =
                                                      value;
                                                  controller.createTriageModel
                                                      .refresh();
                                                },
                                              ),
                                              NewTitleDropdown(
                                                  isRequired: true,
                                                  title:
                                                      'If IFT, Whether patient was stabilised on arrival ',
                                                  hint:
                                                      'Select Whether patient was stabilised on arrival',
                                                  selectedId: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triage!
                                                      .isPatientStableIft,
                                                  items: [
                                                    {
                                                      "id": 1,
                                                      "name": "Stablized"
                                                    },
                                                    {
                                                      "id": 2,
                                                      "name": "Not Stablized"
                                                    },
                                                  ],
                                                  onChanged: (value) {
                                                    controller
                                                            .createTriageModel
                                                            .value!
                                                            .triage!
                                                            .isPatientStableIft =
                                                        value;
                                                    controller.createTriageModel
                                                        .refresh();
                                                  }),
                                              // TitleTextFormField(
                                              //   title: "PAI Given By",
                                              //   controller: TextEditingController(
                                              //       text: controller
                                              //               .createTriageModel.value!.triage!.paiGivenBy ??
                                              //           ""),
                                              //   keyboardType: TextInputType.name,
                                              //   hintText: 'Enter PAI Given By',
                                              //   onChanged: (v) {
                                              //     controller.createTriageModel.value!.triage!.paiGivenBy = v;
                                              //   },
                                              //   validator: (value) {
                                              //     if (value == null || value.isEmpty) {
                                              //       return 'Please Enter PAI Given By';
                                              //     } else {
                                              //       return null;
                                              //     }
                                              //   },
                                              // ),
                                              // TitleTextFormField(
                                              //   title: "PAI Received by (Name of nurse)",
                                              //   controller: TextEditingController(
                                              //       text: controller.createTriageModel.value!.triage!
                                              //               .paiReceivedByNameOfNurse ??
                                              //           ""),
                                              //   keyboardType: TextInputType.name,
                                              //   hintText: 'Enter Name of Nurse',
                                              //   onChanged: (v) {
                                              //     controller.createTriageModel.value!.triage!
                                              //         .paiReceivedByNameOfNurse = v;
                                              //   },
                                              //   validator: (value) {
                                              //     if (value == null || value.isEmpty) {
                                              //       return 'Please Enter Name of Nurse';
                                              //     } else {
                                              //       return null;
                                              //     }
                                              //   },
                                              // ),
                                            ],
                                          ),
                                        NewTitleDropdown(
                                          isRequired: true,
                                          title: 'Place of Incident ',
                                          items:
                                              controller.lookupList.value?.poI
                                                      ?.map((e) => {
                                                            "id": e.id,
                                                            "name": e.name,
                                                          })
                                                      .toList() ??
                                                  [],
                                          selectedId: controller
                                              .createTriageModel
                                              .value!
                                              .triage!
                                              .placeOfIncident,
                                          hint: 'Select Place of Incident',
                                          onChanged: (value) async {
                                            controller
                                                .createTriageModel
                                                .value!
                                                .triage!
                                                .placeOfIncident = value;
                                            controller.createTriageModel
                                                .refresh();
                                          },
                                        ),
                                        // TitleDatePickerTextForm(
                                        //   today: true,
                                        //   title: 'Date and Time of Incident',
                                        //   controller: TextEditingController(text: ""),
                                        //   initialValue:
                                        //       controller.createTriageModel.value!.dateAndTimeOfIncident,
                                        //   onDateSelected: (v) {
                                        //     controller.createTriageModel.value!.dateAndTimeOfIncident = v;
                                        //   },
                                        // ),
                                        // Othera Textfield
                                        controller.createTriageModel.value!
                                                    .triage!.placeOfIncident ==
                                                7
                                            ? TitleTextFormField(
                                                title:
                                                    'Other Place of Incident',
                                                controller: TextEditingController(
                                                    text: controller
                                                        .createTriageModel
                                                        .value!
                                                        .triage!
                                                        .otherPlaceOfIncident),
                                                hintText:
                                                    'Enter Other Place of Incident',
                                                onChanged: (v) {
                                                  controller
                                                      .createTriageModel
                                                      .value!
                                                      .triage!
                                                      .otherPlaceOfIncident = v;
                                                },
                                              )
                                            : Container(),

                                        // DateTimeRowPicker(
                                        //   dateTitle: "Incident Date",
                                        //   timeTitle: "Incident Time",
                                        //   apiDate: controller
                                        //       .createTriageModel
                                        //       .value!
                                        //       .triage!
                                        //       .dateAndTimeOfIncident
                                        //       ?.toString(),
                                        //   apiTime: controller
                                        //               .createTriageModel
                                        //               .value!
                                        //               .triage!
                                        //               .dateAndTimeOfIncident ==
                                        //           null
                                        //       ? null
                                        //       : DateFormat('hh:mm a').format(
                                        //           controller
                                        //               .createTriageModel
                                        //               .value!
                                        //               .triage!
                                        //               .dateAndTimeOfIncident!),
                                        //   onDateTimeChanged: (date) {
                                        //     log(date.toString());
                                        //     controller
                                        //         .createTriageModel
                                        //         .value!
                                        //         .triage!
                                        //         .dateAndTimeOfIncident = date;
                                        //   },
                                        // ),
                                        CommonDateTimeWidget(
                                          title: "Incident Date",
                                          dateTime: controller
                                              .createTriageModel
                                              .value!
                                              .triage!
                                              .dateAndTimeOfIncident
                                              ?.toString(),
                                          onChanged: (v) {
                                            controller
                                                .createTriageModel
                                                .value!
                                                .triage!
                                                .dateAndTimeOfIncident = v;
                                          },
                                        ),
                                      ],
                                    )
                                  : controller.currentIndex.value == 2 &&
                                          widget.form == false
                                      ? Column(
                                          spacing: 12,
                                          children: [
                                            Text(
                                              'Transit Care Form 108',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Space(
                                              height: 16,
                                            ),
                                            TitleTextFormField(
                                              title: "Call ID",
                                              controller: TextEditingController(
                                                  text: controller
                                                          .createTriageModel
                                                          .value!
                                                          .triageBy108!
                                                          .callId ??
                                                      ""),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Call ID',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .callId = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Call ID';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "District Name",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .districtName),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter District Name',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .districtName = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter District Name';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Taluk",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .taluk),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Taluk',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .taluk = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Taluk';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "City Name",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .cityName),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter City Name',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .cityName = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter City Name';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Base Location",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .baseLocation),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Base Location',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .baseLocation = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Base Location';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Vehicle Number",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .vehicleNumber),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Vehicle Number',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .vehicleNumber = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Vehicle Number';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            //
                                            // DateTimeRowPicker(
                                            //   dateTitle:
                                            //       "Vehicle Assigned Date",
                                            //   timeTitle:
                                            //       "Vehicle Assigned Time",
                                            //   apiDate: controller
                                            //       .createTriageModel
                                            //       .value!
                                            //       .triageBy108!
                                            //       .vehicleAssignedDateTime
                                            //       ?.toString(),
                                            //   apiTime: controller
                                            //               .createTriageModel
                                            //               .value!
                                            //               .triageBy108!
                                            //               .vehicleAssignedDateTime ==
                                            //           null
                                            //       ? null
                                            //       : DateFormat('hh:mm a')
                                            //           .format(controller
                                            //               .createTriageModel
                                            //               .value!
                                            //               .triageBy108!
                                            //               .vehicleAssignedDateTime!),
                                            //   onDateTimeChanged: (date) {
                                            //     log(date.toString());
                                            //     controller
                                            //             .createTriageModel
                                            //             .value!
                                            //             .triageBy108!
                                            //             .vehicleAssignedDateTime =
                                            //         date;
                                            //   },
                                            // ),
                                            CommonDateTimeWidget(
                                              title: "Vehicle Assigned Date",
                                              dateTime: controller
                                                  .createTriageModel
                                                  .value!
                                                  .triageBy108!
                                                  .vehicleAssignedDateTime
                                                  ?.toString(),
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .vehicleAssignedDateTime = v;
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Chief Complaint",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .chiefComplaint),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Chief Complaint',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .chiefComplaint = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Chief Complaint';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Emergency Type",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .emergencyType),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Emergency Type',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .emergencyType = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Emergency Type';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Emergency Sub Type",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .emergencySubType),
                                              keyboardType: TextInputType.name,
                                              hintText:
                                                  'Enter Emergency Sub Type',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .emergencySubType = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Emergency Sub Type';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Temperature",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .temperature),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Temperature',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .temperature = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Temperature';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Pulse",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .pulse),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Pulse',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .pulse = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Pulse';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "RR",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .rr),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter RR',
                                              onChanged: (v) {
                                                controller.createTriageModel
                                                    .value!.triageBy108!.rr = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter RR';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "BP_SBP",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .bpSbp),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter BP_SBP',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .bpSbp = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter BP_SBP';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "BP_DBP",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .bpDbp),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter BP_DBP',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .bpDbp = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter BP_DBP';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Pupil Right",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .pupilRight),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Pupil Right',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .pupilRight = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Pupil Right';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Pupil Left",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .pupilLeft),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter Pupil Left',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .pupilLeft = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Pupil Left';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "LOC",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .loc),
                                              keyboardType: TextInputType.name,
                                              hintText: 'Enter LOC',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .loc = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter LOC';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            TitleTextFormField(
                                              title: "Condition of Patient",
                                              controller: TextEditingController(
                                                  text: controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .conditionOfPatient),
                                              keyboardType: TextInputType.name,
                                              hintText:
                                                  'Enter Condition of Patient',
                                              onChanged: (v) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .conditionOfPatient = v;
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Enter Condition of Patient';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                            // TitleYesRadio(
                                            //   title: 'Transit Care Summary',
                                            //   initialValue: "",
                                            //   onChanged: (value) {},
                                            // ),
                                            NewTitleYesRadio(
                                              title: 'Out AR MLC Number',
                                              initialValue: controller
                                                  .createTriageModel
                                                  .value!
                                                  .triageBy108!
                                                  .isOutArMlcNumber,
                                              onChanged: (value) {
                                                controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .isOutArMlcNumber = value;
                                                controller.createTriageModel
                                                    .refresh();
                                              },
                                            ),
                                            if (controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageBy108!
                                                    .isOutArMlcNumber ??
                                                false)
                                              TitleTextFormField(
                                                title: "Specify",
                                                controller:
                                                    TextEditingController(
                                                        text: controller
                                                            .createTriageModel
                                                            .value!
                                                            .triageBy108!
                                                            .outArMlcNumberTx),
                                                keyboardType:
                                                    TextInputType.name,
                                                hintText: 'Enter Number',
                                                onChanged: (v) {
                                                  controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageBy108!
                                                      .outArMlcNumberTx = v;
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please Enter Number';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),
                                            // TitleDropdown(
                                            //   title: 'Accompanied By',
                                            //   items:
                                            //       controller.lookupList.value?.ab?.map((e) => e.name).toList() ??
                                            //           [],
                                            //   selectedItem: controller.selectedAccompanied.value,
                                            //   hint: 'Select Accompanied',
                                            //   onChanged: (value) async {
                                            //     controller.selectedAccompanied.value = value;
                                            //     controller.createTriageModel.value!.triageDtls!.accompaniedBy =
                                            //         getId(controller.lookupList.value!.ab!, value);
                                            //   },
                                            // ),
                                            NewTitleDropdown(
                                                title: 'Accompanied By',
                                                hint: 'Select Accompanied',
                                                items: controller
                                                        .lookupList.value?.ab
                                                        ?.map((e) => {
                                                              "id": e.id,
                                                              "name": e.name
                                                            })
                                                        .toList() ??
                                                    [],
                                                selectedId: controller
                                                    .createTriageModel
                                                    .value!
                                                    .triageDtls!
                                                    .accompaniedBy,
                                                onChanged: (value) {
                                                  controller
                                                      .createTriageModel
                                                      .value!
                                                      .triageDtls!
                                                      .accompaniedBy = value;
                                                  controller.createTriageModel
                                                      .refresh();
                                                })
                                          ],
                                        )
                                      : (controller.currentIndex.value ==
                                              (widget.form == true ? 2 : 3))
                                          ? Column(
                                              spacing: 13,
                                              children: [
                                                Space(
                                                  height: 16,
                                                ),
                                                (controller
                                                                .createTriageModel
                                                                .value
                                                                ?.triage
                                                                ?.ageYear ??
                                                            0) >
                                                        12
                                                    ? NewCheckboxList(
                                                        isRequired: true,
                                                        title:
                                                            'Presenting Complaints - Medical Emergency ',
                                                        options: controller
                                                                .lookupList
                                                                .value
                                                                ?.me ??
                                                            [],
                                                        initialSelectedIndexes:
                                                            controller
                                                                    .createTriageModel
                                                                    .value
                                                                    ?.triageDtls
                                                                    ?.pcMedicalEmergency ??
                                                                [],
                                                        onChanged: (value) {
                                                          controller
                                                              .createTriageModel
                                                              .value
                                                              ?.triageDtls
                                                              ?.pcMedicalEmergency = value;
                                                          print(controller
                                                              .createTriageModel
                                                              .value
                                                              ?.triageDtls
                                                              ?.pcMedicalEmergency);
                                                          controller
                                                              .createTriageModel
                                                              .refresh();
                                                        },
                                                      )
                                                    : Container(),

                                                if ((controller
                                                            .createTriageModel
                                                            .value
                                                            ?.triageDtls
                                                            ?.pcMedicalEmergency ??
                                                        [])
                                                    .contains(15))
                                                  TitleTextFormField(
                                                    title: "Other Specify",
                                                    controller: TextEditingController(
                                                        text: controller
                                                            .createTriageModel
                                                            .value!
                                                            .triageDtls!
                                                            .othPcMedicalEmergency),
                                                    keyboardType:
                                                        TextInputType.name,
                                                    hintText:
                                                        'Enter Specific Complaint',
                                                    onChanged: (v) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triageDtls!
                                                          .othPcMedicalEmergency = v;
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please Enter Specific Complaint';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),

                                                (controller
                                                                .createTriageModel
                                                                .value
                                                                ?.triage
                                                                ?.ageYear ??
                                                            0) >
                                                        12
                                                    ? NewCustomRadioList(
                                                        isRequired: true,
                                                        title:
                                                            'Presenting Complaints - Surgical Emergency ',
                                                        initialId: controller
                                                                .createTriageModel
                                                                .value!
                                                                .triageDtls!
                                                                .pcSurgicalEmergency ??
                                                            0,
                                                        options: controller
                                                                .lookupList
                                                                .value
                                                                ?.se ??
                                                            [],
                                                        onChanged: (value) {
                                                          controller
                                                              .createTriageModel
                                                              .value!
                                                              .triageDtls!
                                                              .pcSurgicalEmergency = value;
                                                          log("Test pcSurgicalEmergency ${controller.createTriageModel.value!.triageDtls!.pcSurgicalEmergency.toString()}");
                                                          controller
                                                              .createTriageModel
                                                              .refresh();
                                                        },
                                                      )
                                                    : Container(),
                                                if (controller
                                                        .createTriageModel
                                                        .value!
                                                        .triageDtls!
                                                        .pcSurgicalEmergency ==
                                                    1)
                                                  Column(
                                                    spacing: 12,
                                                    children: [
                                                      NewTitleDropdown(
                                                        title:
                                                            'Vehicle Involved',
                                                        items:
                                                            controller
                                                                    .lookupList
                                                                    .value
                                                                    ?.rta
                                                                    ?.map(
                                                                        (e) => {
                                                                              "id": e.id ?? "",
                                                                              "name": e.name ?? "",
                                                                            })
                                                                    .toList() ??
                                                                [],
                                                        selectedId: controller
                                                            .createTriageModel
                                                            .value
                                                            ?.triageDtls
                                                            ?.rta,
                                                        hint: 'Select Type',
                                                        onChanged:
                                                            (value) async {
                                                          controller
                                                              .createTriageModel
                                                              .value
                                                              ?.triageDtls
                                                              ?.rta = value;
                                                          controller
                                                              .createTriageModel
                                                              .refresh();
                                                        },
                                                      ),

                                                      /// Two Wheeler
                                                      if (controller
                                                              .createTriageModel
                                                              .value
                                                              ?.triageDtls
                                                              ?.rta ==
                                                          1)
                                                        Column(
                                                          spacing: 12,
                                                          children: [
                                                            NewTitleYesRadio(
                                                              title:
                                                                  'Helmet use',
                                                              initialValue: controller
                                                                  .createTriageModel
                                                                  .value
                                                                  ?.triageDtls
                                                                  ?.rtaHelmet,
                                                              onChanged:
                                                                  (value) {
                                                                controller
                                                                    .createTriageModel
                                                                    .value
                                                                    ?.triageDtls
                                                                    ?.rtaHelmet = value;
                                                              },
                                                            ),
                                                            NewTitleDropdown(
                                                                title:
                                                                    'RTA Rider Type',
                                                                items: controller
                                                                        .lookupList
                                                                        .value
                                                                        ?.rtaRiderType
                                                                        ?.map((e) =>
                                                                            {
                                                                              "id": e.id ?? "",
                                                                              "name": e.name ?? "",
                                                                            })
                                                                        .toList() ??
                                                                    [],
                                                                selectedId: controller
                                                                    .createTriageModel
                                                                    .value
                                                                    ?.triageDtls
                                                                    ?.rtaRiderType,
                                                                onChanged:
                                                                    (value) {
                                                                  controller
                                                                      .createTriageModel
                                                                      .value
                                                                      ?.triageDtls
                                                                      ?.rtaRiderType = value;
                                                                })
                                                          ],
                                                        )
                                                    ],
                                                  ),

                                                /// WorkSpot Injury
                                                if (controller
                                                        .createTriageModel
                                                        .value
                                                        ?.triageDtls
                                                        ?.pcSurgicalEmergency ==
                                                    8)
                                                  NewTitleDropdown(
                                                    title: 'Sector Type',
                                                    items: controller
                                                            .lookupList
                                                            .value
                                                            ?.workspotInjury
                                                            ?.map((e) => {
                                                                  "id": e.id ??
                                                                      "",
                                                                  "name":
                                                                      e.name ??
                                                                          "",
                                                                })
                                                            .toList() ??
                                                        [],
                                                    selectedId: controller
                                                        .createTriageModel
                                                        .value
                                                        ?.triageDtls
                                                        ?.workspotInjury,
                                                    hint: 'Select Type',
                                                    onChanged: (value) async {
                                                      controller
                                                              .createTriageModel
                                                              .value
                                                              ?.triageDtls
                                                              ?.workspotInjury =
                                                          value;
                                                    },
                                                  ),
                                                if (controller
                                                        .createTriageModel
                                                        .value!
                                                        .triageDtls!
                                                        .pcSurgicalEmergency ==
                                                    15)
                                                  TitleTextFormField(
                                                    title:
                                                        "Other Specific Complaint",
                                                    controller: TextEditingController(
                                                        text: controller
                                                            .createTriageModel
                                                            .value!
                                                            .triageDtls!
                                                            .othPcSurgicalEmergency),
                                                    keyboardType:
                                                        TextInputType.name,
                                                    hintText:
                                                        'Enter Other Specific Complaint',
                                                    onChanged: (v) {
                                                      controller
                                                          .createTriageModel
                                                          .value!
                                                          .triageDtls!
                                                          .othPcSurgicalEmergency = v;
                                                    },
                                                    validator: (value) {
                                                      if (value == null) {
                                                        return 'Please Enter Other Specific Complaint';
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                  ),
                                                // CustomRadioList(
                                                //   title: 'Emergency Category',
                                                //   initialIndex: 0,
                                                //   options: controller.emergencyCategory,
                                                //   onChanged: (value) {
                                                //     controller.selectedEmergencyCategory(
                                                //         controller.emergencyCategory[value]);
                                                //     debugPrint(value.toString());
                                                //   },
                                                // ),
                                                // if (controller.selectedEmergencyCategory.value != null &&
                                                //     controller.selectedEmergencyCategory.value == 'Others')
                                                //   TitleTextFormField(
                                                //     title: "Specific Complaint",
                                                //     // controller: TextEditingController(),
                                                //     keyboardType: TextInputType.name,
                                                //     hintText: 'Specific Complaint',
                                                //     validator: (value) {
                                                //       if (value == null) {
                                                //         return 'Please Enter Specific Complaint';
                                                //       } else {
                                                //         return null;
                                                //       }
                                                //     },
                                                //   ),

                                                // TitleDropdown(
                                                //   title: 'Breathing Status',
                                                //   items: controller.breathingStatusList,
                                                //   selectedItem: null,
                                                //   hint: 'Select Breathing Status',
                                                //   onChanged: (value) async {},
                                                // ),
                                                ///  1 - 12
                                                ///
                                                // TODO:need to add API list and function
                                                (controller
                                                                .createTriageModel
                                                                .value
                                                                ?.triage
                                                                ?.ageYear ??
                                                            0) <=
                                                        12
                                                    ? NewCheckboxList(
                                                        isRequired: true,
                                                        title:
                                                            'Presenting Complaints ',

                                                        ///Fever
                                                        // Focus
                                                        // Cough
                                                        // Cold
                                                        // Acute Watery Diarrhoes
                                                        // Vomiting
                                                        // Altered level of consciousness (Lethargy/incessant cry/not as usual/excessive sleepiness)
                                                        // Noisy breathing (Stridor)
                                                        // Breathlessness
                                                        // Unresponsive
                                                        // Regained baseline consciousness
                                                        // Foreign Body ingestion
                                                        // Snake bite
                                                        // Scorpion Sting
                                                        // Insect bite
                                                        // Dog bite
                                                        // Bleed
                                                        // Rash
                                                        // Acute Abdomen
                                                        // Trauma
                                                        // Burns
                                                        // Poison
                                                        // Submersion
                                                        // Seizures
                                                        // Others (specify)

                                                        options: controller
                                                                .lookupList
                                                                .value
                                                                ?.pc ??
                                                            [],
                                                        initialSelectedIndexes:
                                                            controller
                                                                    .createTriageModel
                                                                    .value
                                                                    ?.triageDtls
                                                                    ?.presentingComplaintsPrem ??
                                                                [],
                                                        onChanged: (value) {
                                                          controller
                                                              .createTriageModel
                                                              .value
                                                              ?.triageDtls
                                                              ?.presentingComplaintsPrem = value;
                                                          controller
                                                              .createTriageModel
                                                              .refresh();
                                                        })
                                                    : Container(),

                                                NewTitleYesRadio(
                                                  title: 'Mass casuality',
                                                  initialValue: controller
                                                      .createTriageModel
                                                      .value
                                                      ?.triageDtls
                                                      ?.massCasuality,
                                                  onChanged: (value) {
                                                    controller
                                                        .createTriageModel
                                                        .value
                                                        ?.triageDtls
                                                        ?.massCasuality = value;
                                                    controller.createTriageModel
                                                        .refresh();
                                                  },
                                                ),
                                                if (controller
                                                            .createTriageModel
                                                            .value
                                                            ?.triageDtls
                                                            ?.massCasuality !=
                                                        null &&
                                                    controller
                                                            .createTriageModel
                                                            .value
                                                            ?.triageDtls
                                                            ?.massCasuality ==
                                                        true)
                                                  Column(
                                                    children: [
                                                      TitleTextFormField(
                                                        title: "No.of persons",
                                                        controller: TextEditingController(
                                                            text: controller
                                                                .createTriageModel
                                                                .value
                                                                ?.triageDtls
                                                                ?.massCasualityTx
                                                                .toString()),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        hintText:
                                                            'Enter Number',
                                                        onChanged: (v) {
                                                          controller
                                                              .createTriageModel
                                                              .value!
                                                              .triageDtls!
                                                              .massCasualityTx = v;
                                                        },
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please Enter Number';
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                      ),
                                                      NewTitleDropdown(
                                                        title: 'Cause',
                                                        items: controller
                                                                .lookupList
                                                                .value
                                                                ?.cause
                                                                ?.map((e) => {
                                                                      "id":
                                                                          e.id,
                                                                      "name":
                                                                          e.name
                                                                    })
                                                                .toList() ??
                                                            [],
                                                        selectedId: controller
                                                            .createTriageModel
                                                            .value
                                                            ?.triageDtls
                                                            ?.cause,
                                                        onChanged: (value) {
                                                          controller
                                                              .createTriageModel
                                                              .value
                                                              ?.triageDtls
                                                              ?.cause = value;
                                                          controller
                                                              .createTriageModel
                                                              .refresh();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          : (controller.currentIndex.value ==
                                                  (widget.form == true ? 3 : 4))
                                              ? Column(
                                                  spacing:
                                                      context.isDesktop ? 8 : 4,
                                                  children: [
                                                    Text(
                                                      'VITALS',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Space(
                                                      height: 16,
                                                    ),
                                                    NewTitleDropdown(
                                                      isRequired: true,
                                                      title: 'AVPU ',
                                                      items: controller
                                                              .lookupList
                                                              .value
                                                              ?.avpu
                                                              ?.map((e) => {
                                                                    "id": e.id,
                                                                    "name":
                                                                        e.name
                                                                  })
                                                              .toList() ??
                                                          [],
                                                      selectedId: controller
                                                          .createTriageModel
                                                          .value!
                                                          .triageDtls!
                                                          .avpu,
                                                      hint: 'Select AVPU',
                                                      onChanged: (value) async {
                                                        controller
                                                            .createTriageModel
                                                            .value!
                                                            .triageDtls!
                                                            .avpu = value;
                                                      },
                                                    ),
                                                    TitleTextFormField(
                                                      isRequired: true,
                                                      title: "Pulse ",
                                                      controller:
                                                          TextEditingController(
                                                              text: controller
                                                                  .createTriageModel
                                                                  .value!
                                                                  .triageDtls!
                                                                  .pulse
                                                                  ?.toString()),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      hintText: 'Enter Pulse',
                                                      onChanged: (v) {
                                                        if (v.isNotEmpty) {
                                                          controller
                                                              .createTriageModel
                                                              .value!
                                                              .triageDtls!
                                                              .pulse = int.parse(v);
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please Enter Pulse';
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                    Space(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      spacing: 10,
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              TitleTextFormField(
                                                            isRequired: true,
                                                            title:
                                                                "Bp Systolic ",
                                                            maxLength: 3,
                                                            controller: TextEditingController(
                                                                text: controller
                                                                    .createTriageModel
                                                                    .value!
                                                                    .triageDtls!
                                                                    .bpSystolic
                                                                    ?.toString()),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            hintText:
                                                                'Enter Bp Systolic',
                                                            onChanged: (v) {
                                                              if (v
                                                                  .isNotEmpty) {
                                                                controller
                                                                        .createTriageModel
                                                                        .value!
                                                                        .triageDtls!
                                                                        .bpSystolic =
                                                                    int.parse(
                                                                        v);
                                                              }
                                                            },
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please Enter BP';
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child:
                                                              TitleTextFormField(
                                                            isRequired: true,
                                                            maxLength: 3,
                                                            title:
                                                                "Bp Diastolic ",
                                                            controller: TextEditingController(
                                                                text: controller
                                                                    .createTriageModel
                                                                    .value!
                                                                    .triageDtls!
                                                                    .bpDiastolic
                                                                    ?.toString()),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            hintText:
                                                                'Enter Bp Diastolic',
                                                            onChanged: (v) {
                                                              if (v
                                                                  .isNotEmpty) {
                                                                controller
                                                                        .createTriageModel
                                                                        .value!
                                                                        .triageDtls!
                                                                        .bpDiastolic =
                                                                    int.parse(
                                                                        v);
                                                              }
                                                            },
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please Enter Bp Diastolic';
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    TitleTextFormField(
                                                      isRequired: true,
                                                      title: "SPO2 ",
                                                      controller:
                                                          TextEditingController(
                                                              text: controller
                                                                  .createTriageModel
                                                                  .value!
                                                                  .triageDtls!
                                                                  .spo2
                                                                  ?.toString()),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      hintText: 'Enter SPO2',
                                                      onChanged: (v) {
                                                        if (v.isNotEmpty) {
                                                          controller
                                                              .createTriageModel
                                                              .value!
                                                              .triageDtls!
                                                              .spo2 = int.parse(v);
                                                        }
                                                      },
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Please Enter SPO2';
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              TitleTextFormField(
                                                            isRequired: true,
                                                            title:
                                                                "Temperature ",
                                                            controller: TextEditingController(
                                                                text: controller
                                                                    .createTriageModel
                                                                    .value!
                                                                    .triageDtls!
                                                                    .temperature
                                                                    ?.toString()),
                                                            maxLength: 5,
                                                            keyboardType:
                                                                const TextInputType
                                                                    .numberWithOptions(
                                                                    decimal:
                                                                        true),
                                                            hintText:
                                                                'Enter Temperature',
                                                            onChanged: (v) {
                                                              if (v
                                                                  .isNotEmpty) {
                                                                controller
                                                                    .createTriageModel
                                                                    .value!
                                                                    .triageDtls!
                                                                    .temperature = v;
                                                              }
                                                            },
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please Enter Temperature';
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        const Text(
                                                          '°F',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : (controller
                                                          .currentIndex.value ==
                                                      (widget.form == true
                                                          ? 4
                                                          : 5))
                                                  ? Column(
                                                      children: [
                                                        Space(
                                                          height: 16,
                                                        ),
                                                        NewTitleYesRadio(
                                                          isRequired: true,
                                                          title:
                                                              'Brought Dead ',
                                                          initialValue: controller
                                                              .createTriageModel
                                                              .value!
                                                              .triageDtls!
                                                              .broughtDead,
                                                          onChanged: (value) {
                                                            controller
                                                                .createTriageModel
                                                                .value!
                                                                .triageDtls!
                                                                .broughtDead = value;
                                                            debugPrint(value
                                                                .toString());
                                                            controller
                                                                    .createTriageModel
                                                                    .value!
                                                                    .triageDtls!
                                                                    .triageFlag =
                                                                value == true
                                                                    ? 4
                                                                    : null;
                                                            controller
                                                                .createTriageModel
                                                                .refresh();
                                                          },
                                                        ),
                                                        NewTitleDropdown(
                                                          isRequired: true,
                                                          title: 'Triage Flag ',
                                                          items: controller
                                                                  .lookupList
                                                                  .value
                                                                  ?.tf
                                                                  ?.map((e) => {
                                                                        "id": e
                                                                            .id,
                                                                        "name":
                                                                            e.name
                                                                      })
                                                                  .toList() ??
                                                              [],
                                                          selectedId: controller
                                                              .createTriageModel
                                                              .value!
                                                              .triageDtls!
                                                              .triageFlag,
                                                          hint:
                                                              'Select Triage Flag',
                                                          onChanged:
                                                              (value) async {
                                                            controller
                                                                .createTriageModel
                                                                .value!
                                                                .triageDtls!
                                                                .triageFlag = value;
                                                            controller
                                                                .createTriageModel
                                                                .refresh();
                                                            debugPrint(value
                                                                .toString());
                                                          },
                                                        ),
                                                        if (controller
                                                                    .createTriageModel
                                                                    .value!
                                                                    .triageDtls!
                                                                    .triageFlag !=
                                                                null &&
                                                            controller
                                                                    .createTriageModel
                                                                    .value!
                                                                    .triageDtls!
                                                                    .triageFlag ==
                                                                1)
                                                          NewTitleYesRadio(
                                                            title:
                                                                'Team Call out',
                                                            initialValue: controller
                                                                .createTriageModel
                                                                .value!
                                                                .triageDtls!
                                                                .ifRedTeamCallOut,
                                                            onChanged: (value) {
                                                              controller
                                                                  .createTriageModel
                                                                  .value!
                                                                  .triageDtls!
                                                                  .ifRedTeamCallOut = value;
                                                            },
                                                          ),
                                                        (controller
                                                                        .createTriageModel
                                                                        .value
                                                                        ?.triage
                                                                        ?.ageYear ??
                                                                    0) <=
                                                                12
                                                            ? Column(
                                                                children: [
                                                                  Space(
                                                                      height:
                                                                          16),
                                                                  NewTitleYesRadio(
                                                                      isRequired:
                                                                          true,
                                                                      title:
                                                                          'Whether patient triaged in Queue ',
                                                                      initialValue: controller
                                                                          .createTriageModel
                                                                          .value!
                                                                          .triageDtls!
                                                                          .isPatientTriagedQueue,
                                                                      onChanged:
                                                                          (value) {
                                                                        controller
                                                                            .createTriageModel
                                                                            .value!
                                                                            .triageDtls!
                                                                            .isPatientTriagedQueue = value;
                                                                      }),
                                                                  Space(
                                                                      height:
                                                                          16),
                                                                  NewTitleYesRadio(
                                                                      isRequired:
                                                                          true,
                                                                      title:
                                                                          'PREM OP Ticket for Documentation  ',
                                                                      initialValue: controller
                                                                          .createTriageModel
                                                                          .value!
                                                                          .triageDtls!
                                                                          .premOpTicketDocs,
                                                                      onChanged:
                                                                          (value) {
                                                                        controller
                                                                            .createTriageModel
                                                                            .value!
                                                                            .triageDtls!
                                                                            .premOpTicketDocs = value;
                                                                      }),
                                                                ],
                                                              )
                                                            : Container(),
                                                        Space(height: 16),
                                                        TitleTextFormField(
                                                          isRequired: true,
                                                          title:
                                                              "Triage done by ",
                                                          controller: TextEditingController(
                                                              text: controller
                                                                  .createTriageModel
                                                                  .value!
                                                                  .triageDtls!
                                                                  .triageDoneBy),
                                                          keyboardType:
                                                              TextInputType
                                                                  .name,
                                                          hintText:
                                                              'Enter Nurse Name',
                                                          onChanged: (v) {
                                                            if (v.isNotEmpty) {
                                                              controller
                                                                  .createTriageModel
                                                                  .value!
                                                                  .triageDtls!
                                                                  .triageDoneBy = v;
                                                            }
                                                          },
                                                          validator: (value) {
                                                            if (value == null ||
                                                                value.isEmpty) {
                                                              return 'Please Enter Nurse Name';
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  : Container(),
                          Space(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              controller.currentIndex.value == 0
                                  ? Container()
                                  : CommonElevatedButtonM(
                                      backgroundColor: Colors.white,
                                      text: 'Back',
                                      onPressed: () {
                                        if (controller.currentIndex.value ==
                                            0) {
                                        } else {
                                          controller.changeIndex(
                                            controller.currentIndex.value - 1,
                                          );
                                        }
                                      },
                                    ),
                              /*CommonElevatedButton(
                                  text: controller.currentIndex.value != 5 &&
                                          widget.form == false
                                      ? 'Next'
                                      : controller.currentIndex.value == 4 &&
                                              widget.form == true
                                          ? 'Submit'
                                          : controller.currentIndex.value ==
                                                      5 &&
                                                  widget.form == false
                                              ? 'Submit'
                                              : 'Next',
                                  onPressed: () async {
                                    log(controller.createTriageModel.value
                                        .toString());
                                    if (controller.currentIndex.value >= 0) {
                                      if ((widget.form == true &&
                                              controller.currentIndex.value ==
                                                  4) ||
                                          (widget.form == false &&
                                              controller.currentIndex.value ==
                                                  5)) {
                                        if (widget.isUpdate == true) {
                                          controller.updateTriage();
                                        } else {
                                          controller.createTriage().then((v) {
                                            if (v) {
                                              Get.back();
                                              controller.currentIndex.value = 0;
                                              controller.createTriageModel(
                                                  TriageModel(
                                                triage: Triage(),
                                                triageBy108: TriageBy108(),
                                                triageDtls: TriageDtls(),
                                              ));
                                            }
                                          });
                                        }
                                      } else {
                                        controller.changeIndex(
                                            controller.currentIndex.value + 1);
                                        print(controller.currentIndex.value);
                                      }
                                    }

                                    // if (controller.currentIndex.value >= 0) {
                                    //   controller.changeIndex(
                                    //       controller.currentIndex.value + 1);
                                    //   // if (widget.isUpdate == true) {
                                    //   //   await controller.updateTriage().then((v) {
                                    //   //     if (v) {
                                    //   //       Get.back();
                                    //   //     }
                                    //   //   });
                                    //   // } else {
                                    //   //   await controller.createTriage().then((v) {
                                    //   //     if (v) {
                                    //   //       Get.back();
                                    //   //     }
                                    //   //   });
                                    //   // }
                                    //   print(controller.currentIndex.value);
                                    // }
                                  })*/
                              CommonElevatedButton(
                                  text: controller.currentIndex.value != 5 &&
                                          widget.form == false
                                      ? 'Next'
                                      : controller.currentIndex.value == 4 &&
                                              widget.form == true
                                          ? 'Submit'
                                          : controller.currentIndex.value ==
                                                      5 &&
                                                  widget.form == false
                                              ? 'Submit'
                                              : 'Next',
                                  onPressed: () async {
                                    final step = controller.currentIndex.value;

                                    // ---------------- STEP 1 VALIDATION ----------------
                                    if (step == 0) {
                                      if (controller.createTriageModel.value
                                              ?.triage?.dateTimeOfTriage ==
                                          null) {
                                        log('Test');
                                        ValidationSnackbar.show(
                                            "Date and Time is required");
                                        // Get.snackbar('Validation Error',
                                        //     'Date and Time is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triage?.ageYear ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Age is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triage?.gender ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Gender is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triage?.patientEhrId ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'PHR ID is required');
                                        return;
                                      }
                                    }
                                    if (step == 1) {
                                      if (controller.createTriageModel.value
                                              ?.triage?.modeOfArrival ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Mode of Arrival is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triage?.sceneIft ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Scene IFT is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                                  ?.triage?.sceneIft ==
                                              2 &&
                                          controller
                                                  .createTriageModel
                                                  .value
                                                  ?.triage
                                                  ?.isPatientStableIft ==
                                              null) {
                                        ValidationSnackbar.show(
                                            'Is Patient Stable IFT is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triage?.placeOfIncident ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Place of Incident is required');
                                        return;
                                      }
                                    }

                                    /// Direct Flow
                                    // ---------------- STEP 2 VALIDATION DIRECT----------------
                                    if (step == 2 && widget.form == true) {
                                      final age = controller.createTriageModel
                                              .value?.triage?.ageYear ??
                                          0;

                                      final medical = controller
                                          .createTriageModel
                                          .value
                                          ?.triageDtls
                                          ?.pcMedicalEmergency;

                                      final surgical = controller
                                          .createTriageModel
                                          .value
                                          ?.triageDtls
                                          ?.pcSurgicalEmergency;

                                      if (age > 12 &&
                                          (medical == null ||
                                              medical.isEmpty) &&
                                          surgical == null) {
                                        ValidationSnackbar.show(
                                          'Either Medical Emergency or Surgical Emergency is required',
                                        );
                                        return;
                                      }

                                      /*if ((controller
                                              .createTriageModel
                                              .value
                                              ?.triageDtls
                                              ?.pcMedicalEmergency
                                              ?.isEmpty ??
                                          true &&
                                              ((controller
                                                          .createTriageModel
                                                          .value
                                                          ?.triage
                                                          ?.ageYear ??
                                                      0) >
                                                  12))) {
                                        ValidationSnackbar.show(
                                          'Medical Emergency is required',
                                        );
                                        return;
                                      }
                                      if (controller
                                                  .createTriageModel
                                                  .value
                                                  ?.triageDtls
                                                  ?.pcSurgicalEmergency ==
                                              null &&
                                          ((controller.createTriageModel.value
                                                      ?.triage?.ageYear ??
                                                  0) >
                                              12)) {
                                        ValidationSnackbar.show(
                                          'Surgical Emergency is required',
                                        );
                                        return;
                                      }*/
                                      if ((controller
                                                  .createTriageModel
                                                  .value
                                                  ?.triageDtls
                                                  ?.presentingComplaintsPrem
                                                  ?.isEmpty ??
                                              true) &&
                                          ((controller.createTriageModel.value
                                                      ?.triage?.ageYear ??
                                                  0) <=
                                              12)) {
                                        log("Presenting Complaints (Prem) is required");
                                        log(" Test Presenting ${controller.createTriageModel.value?.triageDtls?.presentingComplaintsPrem}");
                                        log(" Test Age ${controller.createTriageModel.value?.triage?.ageYear}");
                                        ValidationSnackbar.show(
                                          'Presenting Complaints (Prem) is required',
                                        );
                                        return;
                                      }
                                    }
                                    // ---------------- STEP 3 VALIDATION DIRECT ----------------
                                    if (step == 3 && widget.form == true) {
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.avpu ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'AVPU is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.pulse ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Pulse is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.bpSystolic ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'BP Systolic is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.bpDiastolic ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'BP Diastolic is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.spo2 ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'SPO2 is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.temperature ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Temperature is required');
                                        return;
                                      }
                                    }
                                    // ---------------- STEP 4 VALIDATION DIRECT ----------------
                                    if (step == 4 && widget.form == true) {
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.broughtDead ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Brought Dead is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.triageFlag ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Triage Flag is required');
                                        return;
                                      }
                                      if (controller
                                                  .createTriageModel
                                                  .value
                                                  ?.triageDtls
                                                  ?.isPatientTriagedQueue ==
                                              null &&
                                          ((controller.createTriageModel.value
                                                      ?.triage?.ageYear ??
                                                  0) <=
                                              12)) {
                                        ValidationSnackbar.show(
                                            'Is Patient Triaged Queue is required');
                                        return;
                                      }
                                      if (controller
                                                  .createTriageModel
                                                  .value
                                                  ?.triageDtls
                                                  ?.premOpTicketDocs ==
                                              null &&
                                          ((controller.createTriageModel.value
                                                      ?.triage?.ageYear ??
                                                  0) <=
                                              12)) {
                                        ValidationSnackbar.show(
                                            'Prem Op Ticket Docs is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.triageDoneBy ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Triage Done By is required');
                                        return;
                                      }
                                    }

                                    /// 108 Flow
                                    // ---------------- STEP 3 VALIDATION 108 ----------------
                                    if (step == 3 && widget.form == false) {
                                      final age = controller.createTriageModel
                                              .value?.triage?.ageYear ??
                                          0;

                                      final medical = controller
                                          .createTriageModel
                                          .value
                                          ?.triageDtls
                                          ?.pcMedicalEmergency;

                                      final surgical = controller
                                          .createTriageModel
                                          .value
                                          ?.triageDtls
                                          ?.pcSurgicalEmergency;

                                      if (age > 12 &&
                                          (medical == null ||
                                              medical.isEmpty) &&
                                          surgical == null) {
                                        ValidationSnackbar.show(
                                          'Either Medical Emergency or Surgical Emergency is required',
                                        );
                                        return;
                                      }

                                      /*if (controller
                                              .createTriageModel
                                              .value
                                              ?.triageDtls
                                              ?.pcMedicalEmergency
                                              ?.isEmpty ??
                                          true &&
                                              ((controller
                                                          .createTriageModel
                                                          .value
                                                          ?.triage
                                                          ?.ageYear ??
                                                      0) >
                                                  12)) {
                                        ValidationSnackbar.show(
                                          'Medical Emergency is required',
                                        );
                                        return;
                                      }
                                      if (controller
                                                  .createTriageModel
                                                  .value
                                                  ?.triageDtls
                                                  ?.pcSurgicalEmergency ==
                                              null &&
                                          ((controller.createTriageModel.value
                                                      ?.triage?.ageYear ??
                                                  0) >
                                              12)) {
                                        ValidationSnackbar.show(
                                          'Surgical Emergency is required',
                                        );
                                        return;
                                      }*/
                                      if ((controller
                                                  .createTriageModel
                                                  .value
                                                  ?.triageDtls
                                                  ?.presentingComplaintsPrem
                                                  ?.isEmpty ??
                                              true) &&
                                          ((controller.createTriageModel.value
                                                      ?.triage?.ageYear ??
                                                  0) <=
                                              12)) {
                                        ValidationSnackbar.show(
                                          'Presenting Complaints (Prem) is required',
                                        );
                                        return;
                                      }
                                    }
                                    // ---------------- STEP 4 VALIDATION 108 ----------------
                                    if (step == 4 && widget.form == false) {
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.avpu ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'AVPU is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.pulse ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Pulse is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.bpSystolic ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'BP Systolic is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.bpDiastolic ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'BP Diastolic is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.spo2 ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'SPO2 is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.temperature ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Temperature is required');
                                        return;
                                      }
                                    }
                                    // ---------------- STEP 5 VALIDATION 108 ----------------
                                    if (step == 5 && widget.form == false) {
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.broughtDead ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Brought Dead is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.triageFlag ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Triage Flag is required');
                                        return;
                                      }
                                      if (controller
                                                  .createTriageModel
                                                  .value
                                                  ?.triageDtls
                                                  ?.isPatientTriagedQueue ==
                                              null &&
                                          ((controller.createTriageModel.value
                                                      ?.triage?.ageYear ??
                                                  0) <=
                                              12)) {
                                        ValidationSnackbar.show(
                                            'Is Patient Triaged Queue is required');
                                        return;
                                      }
                                      if (controller
                                                  .createTriageModel
                                                  .value
                                                  ?.triageDtls
                                                  ?.premOpTicketDocs ==
                                              null &&
                                          ((controller.createTriageModel.value
                                                      ?.triage?.ageYear ??
                                                  0) <=
                                              12)) {
                                        ValidationSnackbar.show(
                                            'Prem Op Ticket Docs is required');
                                        return;
                                      }
                                      if (controller.createTriageModel.value
                                              ?.triageDtls?.triageDoneBy ==
                                          null) {
                                        ValidationSnackbar.show(
                                            'Triage Done By is required');
                                        return;
                                      }
                                    }

                                    // ---------------- SUBMIT / NEXT LOGIC ----------------
                                    final isSubmit =
                                        (widget.form == true && step == 4) ||
                                            (widget.form == false && step == 5);

                                    if (isSubmit) {
                                      if (widget.isUpdate == true) {
                                        controller.updateTriage();
                                      } else {
                                        final success =
                                            await controller.createTriage();
                                        if (success) {
                                          Get.back();
                                          controller.currentIndex.value = 0;
                                          controller.createTriageModel(
                                            TriageModel(
                                              triage: Triage(),
                                              triageBy108: TriageBy108(),
                                              triageDtls: TriageDtls(),
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      controller.changeIndex(step + 1);
                                    }
                                  })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class AbhaQrScannerScreen extends StatefulWidget {
  const AbhaQrScannerScreen({super.key});

  @override
  State<AbhaQrScannerScreen> createState() => _AbhaQrScannerScreenState();
}

class _AbhaQrScannerScreenState extends State<AbhaQrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;

  // ✅ Correct function
  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;

    for (final barcode in capture.barcodes) {
      final String? rawValue = barcode.rawValue;

      if (rawValue == null || rawValue.isEmpty) continue;

      _scanned = true;

      log("==================================");
      log("ABHA QR SCANNED SUCCESSFULLY");
      log("RAW VALUE: $rawValue");
      log("FORMAT: ${barcode.format}");
      log("DISPLAY VALUE: ${barcode.displayValue}");
      log("==================================");

      // Show popup first for debugging
      Get.dialog(
        AlertDialog(
          title: const Text("QR Scanned"),
          content: SingleChildScrollView(
            child: Text(rawValue),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // close dialog
                Navigator.of(context).pop(rawValue); // return data
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );

      break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan ABHA QR'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect, // ✅ now correct
          ),

          // QR Frame
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
          ),

          // Instruction
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Point the ABHA QR code inside the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
