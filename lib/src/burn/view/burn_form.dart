import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/burn/controller/burn_controller.dart';
import 'package:taei_gov/src/burn/models/create_burn_model.dart';
import 'package:taei_gov/src/hospital/controller/hospital_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_button.dart'
    hide CommonElevatedButtonM;
import 'package:taei_gov/utils/common/common_check_box_list.dart';
import 'package:taei_gov/utils/common/common_drop_down.dart';
import 'package:taei_gov/utils/common/injuries_parts_ui.dart';
import 'package:taei_gov/utils/common/new_common_date_time_picker.dart';
import 'package:taei_gov/utils/common/save_submit_dialog.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/step_indicator.dart';
import 'package:taei_gov/utils/common/title_textfield.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';
import '../../../utils/common/appbar.dart';
import '../../../utils/common/m_elevate_button.dart';
import '../../../utils/common/yes_or_no_radio_button.dart';

class BurnForm extends StatefulWidget {
  final String? burnId;
  final String? triageId;
  final bool isUpdate;

  const BurnForm(
      {super.key, this.triageId, this.isUpdate = false, this.burnId});

  @override
  State<BurnForm> createState() => _BurnFormState();
}

class _BurnFormState extends State<BurnForm> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  BurnController controller = Get.put(BurnController());
  HospitalController hospitalController = Get.put(HospitalController());
  bool insuranceCard = false;

  var formKey2 = GlobalKey<FormState>();

  var formKey3 = GlobalKey<FormState>();

  var formKey4 = GlobalKey<FormState>();
  String? surgical;

  var transferTo = [
    {"id": 1, "name": "WARD"},
    {"id": 2, "name": "ICU"},
    {"id": 3, "name": "No"}
  ];

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getLookup();
      await hospitalController.getHospitalListData();
      if (widget.isUpdate) {
        await controller.getBurnById(id: widget.burnId.toString());
      }
      controller.isLoading(false);
    });
  }

  bool validateBurnsForm({required bool outcome}) {
    final burns = controller.burnFormData.value;

    // Step 0: Visit & Admission Details Validation
    if (controller.currentIndex.value == 0) {
      if (burns.burns?.admitted == null) {
        showValidationError("Please specify if patient was admitted");
        return false;
      }

      // If admitted is "Yes", admission date is required
      if (burns.burns?.admissionDate == null &&
          burns.burns?.admissionDate == "") {
        showValidationError(
            "Admission date is required when patient is admitted");
        return false;
      }
    } else if (controller.currentIndex.value == 1) {
      // Step 1: Burn Injury Details Validation
      if (burns.burns?.typeOfBurn == null) {
        showValidationError("Type of Burn is required");
        return false;
      }

      // If type of burn is "Other", other specification is required
      if (burns.burns?.typeOfBurn == 10 &&
          (burns.burns?.othTypeOfBurn == null ||
              burns.burns!.othTypeOfBurn!.isEmpty)) {
        showValidationError(
            "Please specify the type of burn when selecting 'Other'");
        return false;
      }

      // Inhalation validation (only required for certain burn types)
      if (burns.burns?.typeOfBurn == 1 && burns.burns?.inhalation == null) {
        showValidationError(
            "Please specify inhalation status for this burn type");
        return false;
      }

      if (burns.burns?.modeOfInjury == null) {
        showValidationError("Mode of Injury is required");
        return false;
      }

      // If mode of injury is "Other", other specification is required
      if (burns.burns?.modeOfInjury == 4 &&
          (burns.burns?.othModeOfInjury == null ||
              burns.burns!.othModeOfInjury!.isEmpty)) {
        showValidationError(
            "Please specify mode of injury when selecting 'Other'");
        return false;
      }

      // TBSA validation
      if (burns.burns?.tbsaTotalPer == null ||
          burns.burns!.tbsaTotalPer!.isEmpty) {
        showValidationError("TBSA percentage is required");
        return false;
      }

      // Validate TBSA is a valid number
      final tbsa = double.tryParse(burns.burns!.tbsaTotalPer!);
      if (tbsa == null) {
        showValidationError("TBSA must be a valid number");
        return false;
      }

      if (tbsa < 0 || tbsa > 100) {
        showValidationError("TBSA must be between 0 and 100 percent");
        return false;
      }

      if (burns.burns?.associatedInjuries == null ||
          burns.burns!.associatedInjuries!.isEmpty) {
        showValidationError(
            "Please specify associated injuries (enter 'None' if none)");
        return false;
      }

      // Co-Morbidities validation
      if (burns.burns?.coMorbidities == null ||
          burns.burns!.coMorbidities!.isEmpty) {
        showValidationError("Co-morbidities selection is required");
        return false;
      }

      // If "Other" co-morbidity is selected, validate other specification
      if (burns.burns?.coMorbidities == null ||
          burns.burns!.coMorbidities!.isEmpty) {
        showValidationError("Please specify other co-morbidity details");
        return false;
      }
    } else if (controller.currentIndex.value == 2) {
      // Surgery - Emergency validation
      if (burns.burnsValues?.isSurgeryEmergency == null) {
        showValidationError("Emergency surgery status is required");
        return false;
      }

      if (burns.burnsValues?.isSurgeryEmergency == true &&
          burns.burnsValues?.surgeryEmergency == null) {
        showValidationError("Please specify emergency surgical procedure");
        return false;
      }

      if (burns.burnsValues?.surgeryEmergency != null &&
          burns.burnsValues?.surgeryPerformedDate == null) {
        showValidationError("Emergency surgery date/time is required");
        return false;
      }

      // Surgery - Elective validation
      if (burns.burnsValues?.isSurgeryElectivePerformed == null) {
        showValidationError("Elective surgery status is required");
        return false;
      }

      // Validate elective surgery details if performed
      if (burns.burnsValues?.isSurgeryElectivePerformed == true) {
        if (burns.burnsSurgeryElective == null ||
            burns.burnsSurgeryElective!.isEmpty) {
          showValidationError(
              "Please add at least one elective surgical procedure");
          return false;
        }

        for (var surgery in burns.burnsSurgeryElective!) {
          if (surgery.surgeryElective == null) {
            showValidationError(
                "Please specify elective surgical procedure type");
            return false;
          }

          if (surgery.surgeryElectiveDate == null) {
            showValidationError("Elective surgery date/time is required");
            return false;
          }
        }
      }

      if (burns.burnsValues?.complicationsHospitalStay == null ||
          burns.burnsValues!.complicationsHospitalStay!.isEmpty) {
        showValidationError(
            "Complications during hospital stay selection is required");
        return false;
      }

      // Multidisciplinary support validation
      if (burns.burnsValues?.multidisciplinarySupport == null ||
          burns.burnsValues!.multidisciplinarySupport!.isEmpty) {
        showValidationError("Multidisciplinary support selection is required");
        return false;
      }

      // If "Other" multidisciplinary support is selected, validate quantity
      if (burns.burnsValues!.multidisciplinarySupport!.contains(19) &&
          (burns.burnsValues?.othMultidisciplinarySupport == null ||
              burns.burnsValues!.othMultidisciplinarySupport!.isEmpty)) {
        showValidationError(
            "Please specify quantity for other multidisciplinary support");
        return false;
      }

      if (burns.burnsValues?.skinBankAvailable == null) {
        showValidationError("Skin bank availability status is required");
        return false;
      }

      if (burns.burnsValues?.hyperBaric == null) {
        showValidationError("Hyperbaric oxygen therapy status is required");
        return false;
      }
    } else if (controller.currentIndex.value == 3) {
      if (outcome == true) {
        // Step 3: Data Entry Details Validation
        if (burns.burnsOutcome?.outcome == null) {
          showValidationError("Patient outcome is required");
          return false;
        }

        switch (burns.burnsOutcome?.outcome) {
          case 1: // Discharged
          case 2: // Against Medical Advice (AMA)
          case 3: // Absconded
            if (burns.burnsOutcome?.dischargeDate == null) {
              showValidationError("Discharge/exit date is required");
              return false;
            }
            break;

          case 4: // Absconded (specific)
            if (burns.burnsOutcome?.abscondedDate == null) {
              showValidationError("Absconded date is required");
              return false;
            }
            break;

          case 5: // Death
            if (burns.burnsOutcome?.deathDate == null) {
              showValidationError("Date of death is required");
              return false;
            }
            break;

          case 7: // Patient Exit
            if (burns.burnsOutcome?.patientExitDate == null) {
              showValidationError("Patient exit date is required");
              return false;
            }
            break;

          case 6: // Referred
            if (burns.burnsOutcome?.hospitalType == null) {
              showValidationError("Hospital type is required for referral");
              return false;
            }

            if (burns.burnsOutcome?.hospitalType == 1) {
              // TAEI Hospital
              if (burns.burnsOutcome?.destinationTAEIHospitalId == null) {
                showValidationError("Destination TAEI hospital is required");
                return false;
              }
            } else if (burns.burnsOutcome?.hospitalType == 2) {
              // Non-TAEI Hospital
              if (burns.burnsOutcome?.destinationHospital == null ||
                  burns.burnsOutcome!.destinationHospital!.isEmpty) {
                showValidationError("Destination hospital name is required");
                return false;
              }
            }

            if (burns.burnsOutcome?.reasonForReferral == null) {
              showValidationError("Reason for referral is required");
              return false;
            }

            if (burns.burnsOutcome?.conditionOfPatient == null) {
              showValidationError(
                  "Condition of patient at referral is required");
              return false;
            }

            if (burns.burnsOutcome?.referringDoctorName == null ||
                burns.burnsOutcome!.referringDoctorName!.isEmpty) {
              showValidationError("Referring doctor name is required");
              return false;
            }

            if (burns.burnsOutcome?.documentedTaeiSheet == null) {
              showValidationError(
                  "Documentation in TAEI case sheet status is required");
              return false;
            }
            break;
        }

        if (burns.burnsValues?.surgeryPerformedDate != null &&
            burns.burns?.admissionDate != null) {
          showValidationError("Surgery date is a mandatory");
          return false;
        }
      }
    }
    return true;
  }

  void showValidationError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,

      // Mobile (Android/iOS)
      backgroundColor: const Color(0xFFD32F2F),
      // Material Design red 700
      textColor: Colors.white,

      // Web fix (very important!)
      webBgColor: "#d32f2f",
      // hex red
      webShowClose: false,

      fontSize: context.isDesktop ? 18.0 : 15.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("HHHHH${controller.burnFormData.value.burns?.othTypeOfBurn}");
        if (controller.currentIndex.value == 0) {
          return true;
        } else {
          controller.currentIndex.value--;
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
        appBar: CommonAppBar(
          title: 'Burns',
          id: widget.triageId.toString(),
        ),
        body: Obx(() => controller.isLoading.value
            ? pageLoader()
            : Container(
                margin: context.isDesktop
                    ? EdgeInsets.only(
                        left: 300, right: 300, top: 25, bottom: 20)
                    : EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: context.isDesktop
                          ? Color(0xFF052B3A)
                          : Colors.transparent,
                      width: 0.3),
                ),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: Padding(
                    padding: context.isDesktop
                        ? EdgeInsets.only(
                            left: 30, right: 30, top: 8, bottom: 8)
                        : EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        Center(
                          child: Text(
                            controller.currentIndex.value == 0
                                ? 'Visit & Admission Details'
                                : controller.currentIndex.value == 1
                                    ? 'Burn Injury Details'
                                    : controller.currentIndex.value == 2
                                        ? 'Management Details'
                                        : 'Data Entry Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Space(height: 20),
                        FancyStepIndicator(
                          currentIndex: controller.currentIndex,
                          stepCount: 4,
                        ),
                        Space(height: 26),
                        controller.currentIndex.value == 0
                            ? Column(
                                children: [
                                  NewTitleYesRadio(
                                    isRequired: true, // MANDATORY
                                    title: 'Admitted',
                                    initialValue: controller
                                        .burnFormData.value.burns?.admitted,
                                    onChanged: (value) {
                                      controller.burnFormData.value.burns
                                          ?.admitted = value;
                                      controller.burnFormData.refresh();
                                    },
                                  ),
                                  Space(height: 16),
                                  // Admission date is conditionally mandatory
                                  CommonDateTimeWidget(
                                    title: 'Admission Date',
                                    dateTime: controller
                                        .burnFormData.value.burns?.admissionDate
                                        ?.toString(),
                                    onChanged: (value) {
                                      controller.burnFormData.value.burns
                                          ?.admissionDate = value;
                                      controller.burnFormData.refresh();
                                    },
                                  ),
                                  Space(height: 20),
                                ],
                              )
                            : controller.currentIndex.value == 1
                                ? Column(spacing: 20, children: [
                                    NewTitleDropdown(
                                      isRequired: true, // MANDATORY
                                      title: 'Type Of Burn',
                                      hint: 'Select Type Of Burn',
                                      items: controller
                                              .lookupList.value?.typeOfBurn
                                              ?.map((e) => {
                                                    "id": e.id ?? "",
                                                    "name": e.name ?? "",
                                                  })
                                              .toList() ??
                                          [],
                                      selectedId: controller
                                          .burnFormData.value.burns?.typeOfBurn,
                                      onChanged: (value) {
                                        controller.burnFormData.value.burns
                                            ?.typeOfBurn = value;
                                        controller.burnFormData.refresh();
                                      },
                                    ),
                                    if (controller.burnFormData.value.burns
                                                ?.typeOfBurn !=
                                            null &&
                                        controller.burnFormData.value.burns
                                                ?.typeOfBurn ==
                                            1)
                                      NewTitleYesRadio(
                                        isRequired:
                                            true, // MANDATORY for burn type 1
                                        title: 'Inhalation',
                                        initialValue: controller.burnFormData
                                            .value.burns?.inhalation,
                                        onChanged: (value) {
                                          controller.burnFormData.value.burns
                                              ?.inhalation = value;
                                          controller.burnFormData.refresh();
                                        },
                                      ),
                                    if (controller.burnFormData.value.burns
                                                ?.typeOfBurn !=
                                            null &&
                                        controller.burnFormData.value.burns
                                                ?.typeOfBurn ==
                                            10)
                                      TitleTextFormField(
                                        isRequired:
                                            true, // MANDATORY when "Other" is selected
                                        title: 'Type Of Burn',
                                        hintText: "Enter Type Of Burn",
                                        controller: TextEditingController(
                                            text: controller.burnFormData.value
                                                .burns?.othTypeOfBurn),
                                        onChanged: (v) {
                                          controller.burnFormData.value.burns
                                              ?.othTypeOfBurn = v;
                                          controller.burnFormData.refresh();
                                        },
                                      ),
                                    NewTitleDropdown(
                                      isRequired: true, // MANDATORY
                                      title: 'Mode Of Injury',
                                      hint: "Select Mode of Injury",
                                      items: controller
                                              .lookupList.value?.modeOfInjury
                                              ?.map((e) => {
                                                    "id": e.id ?? "",
                                                    "name": e.name ?? "",
                                                  })
                                              .toList() ??
                                          [],
                                      selectedId: controller.burnFormData.value
                                          .burns?.modeOfInjury,
                                      onChanged: (value) {
                                        controller.burnFormData.value.burns
                                            ?.modeOfInjury = value;
                                        controller.burnFormData.refresh();
                                        controller.calculateTbsaTotal();
                                      },
                                    ),
                                    if (controller.burnFormData.value.burns
                                                ?.modeOfInjury !=
                                            null &&
                                        controller.burnFormData.value.burns
                                                ?.modeOfInjury ==
                                            4)
                                      TitleTextFormField(
                                        isRequired:
                                            true, // MANDATORY when "Other" is selected
                                        title: 'Other Mode Of Injury',
                                        hintText: "Enter Mode Of Injury",
                                        controller: TextEditingController(
                                            text: controller.burnFormData.value
                                                .burns?.othModeOfInjury),
                                        onChanged: (v) {
                                          controller.burnFormData.value.burns
                                              ?.othModeOfInjury = v;
                                          controller.burnFormData.refresh();
                                        },
                                      ),
                                    InjuryDropdownList(
                                      title: "TBSA",
                                      listData: [
                                        TitleDropdownItem(
                                          title: "Head",
                                          options: [
                                            1,
                                            2,
                                            3,
                                            4,
                                            5,
                                            6,
                                            7,
                                            8,
                                            9,
                                            10,
                                            11,
                                            12,
                                            13,
                                            14,
                                            15,
                                            16,
                                            17,
                                            18,
                                            19
                                          ].map((e) => e.toDouble()).toList(),
                                          selectedValue: controller.burnFormData
                                              .value.burnsTbsa?.head,
                                          onChanged: (val) {
                                            controller.burnFormData.value
                                                .burnsTbsa?.head = val;
                                            controller.calculateTbsaTotal();
                                            controller.burnFormData.refresh();
                                          },
                                        ),
                                        TitleDropdownItem(
                                          title: "Neck",
                                          options: [1.0, 2.0]
                                              .map((e) => e.toDouble())
                                              .toList(),
                                          selectedValue: controller.burnFormData
                                              .value.burnsTbsa?.neck,
                                          onChanged: (val) {
                                            controller.burnFormData.value
                                                .burnsTbsa?.neck = val;
                                            controller.burnFormData.refresh();
                                            controller.calculateTbsaTotal();
                                          },
                                        ),
                                        // ... other TBSA dropdown items
                                      ],
                                    ),
                                    Obx(
                                      () => TitleTextFormField(
                                        key: ValueKey(controller.burnFormData
                                            .value.burns?.tbsaTotalPer),
                                        isRequired: true, // MANDATORY
                                        title: 'Total Percentage Of TBSA',
                                        initialValue: controller.burnFormData
                                            .value.burns?.tbsaTotalPer,
                                        onChanged: (value) {
                                          controller.burnFormData.value.burns
                                              ?.tbsaTotalPer = value;
                                          controller.burnFormData.refresh();
                                        },
                                      ),
                                    ),
                                    NewTitleDropdown(
                                      isRequired: false, // MANDATORY
                                      title: 'Degree Of Burn',
                                      hint: 'Select Degree Of Burn',
                                      items: controller
                                              .lookupList.value?.degreeOfBurn
                                              ?.map((e) => {
                                                    "id": e.id ?? "",
                                                    "name": e.name ?? "",
                                                  })
                                              .toList() ??
                                          [],
                                      selectedId: controller.burnFormData.value
                                          .burns?.degreeOfBurn,
                                      onChanged: (value) {
                                        controller.burnFormData.value.burns
                                            ?.degreeOfBurn = value;
                                      },
                                    ),
                                    TitleTextFormField(
                                      isRequired: true, // MANDATORY
                                      hintText: 'Enter Associated Injury',
                                      title: 'Associated Injury',
                                      initialValue: controller.burnFormData
                                          .value.burns?.associatedInjuries,
                                      onChanged: (v) {
                                        controller.burnFormData.value.burns
                                            ?.associatedInjuries = v;
                                        controller.burnFormData.refresh();
                                      },
                                    ),
                                    NewCheckboxList(
                                      isRequired: true, // MANDATORY
                                      title: "Co-Morbidities",
                                      options: controller.lookupList.value
                                              ?.coMorbidities ??
                                          [],
                                      initialSelectedIndexes: controller
                                              .burnFormData
                                              .value
                                              .burns
                                              ?.coMorbidities ??
                                          [],
                                      onChanged: (v) {
                                        controller.burnFormData.value.burns
                                            ?.coMorbidities = v;
                                        controller.burnFormData.refresh();
                                      },
                                    ),
                                    if (controller.burnFormData.value.burns
                                                ?.coMorbidities !=
                                            null &&
                                        controller.burnFormData.value.burns!
                                            .coMorbidities!
                                            .contains(8))
                                      TitleTextFormField(
                                        isRequired:
                                            true, // MANDATORY when "Other" is selected
                                        title: "Other Specify",
                                        controller:
                                            TextEditingController(text: ''),
                                        keyboardType: TextInputType.name,
                                        hintText: 'Enter Specific Complaint',
                                        onChanged: (v) {
                                          // Update other co-morbidities field
                                        },
                                      ),
                                    NewTitleYesRadio(
                                      isRequired: false, // MANDATORY
                                      title: 'Is the Patient Pregnant',
                                      initialValue: controller
                                          .burnFormData.value.burns?.isPregnant,
                                      onChanged: (value) {
                                        controller.burnFormData.value.burns
                                            ?.isPregnant = value;
                                        controller.burnFormData.refresh();
                                      },
                                    ),
                                  ])
                                : controller.currentIndex.value == 2
                                    ? Column(
                                        spacing: 18,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          NewTitleYesRadio(
                                            title:
                                                'Fluid resuscitation given within One Hour of Incident',
                                            initialValue: controller
                                                .burnFormData
                                                .value
                                                .burns
                                                ?.isFluidResuscitationGiven,
                                            onChanged: (value) {
                                              controller
                                                      .burnFormData
                                                      .value
                                                      .burns
                                                      ?.isFluidResuscitationGiven =
                                                  value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          NewTitleYesRadio(
                                            title:
                                                'Patient on Mechanical Ventillation',
                                            initialValue: controller
                                                .burnFormData
                                                .value
                                                .burns
                                                ?.isMechanicalVentillation,
                                            onChanged: (value) {
                                              controller
                                                      .burnFormData
                                                      .value
                                                      .burns
                                                      ?.isMechanicalVentillation =
                                                  value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          NewTitleDropdown(
                                            isRequired: false, // MANDATORY
                                            title: 'Patient Sent To',
                                            hint: "Select Patient Sent To",
                                            items: controller.lookupList.value
                                                    ?.transferredTo
                                                    ?.map((e) => {
                                                          "id": e.id ?? "",
                                                          "name": e.name ?? "",
                                                        })
                                                    .toList() ??
                                                [],
                                            selectedId: controller
                                                .burnFormData
                                                .value
                                                .burnsOutcome
                                                ?.transferredTo,
                                            onChanged: (value) {
                                              controller
                                                  .burnFormData
                                                  .value
                                                  .burnsOutcome
                                                  ?.transferredTo = value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          if (controller
                                                          .burnFormData
                                                          .value
                                                          .burnsOutcome
                                                          ?.transferredTo !=
                                                      null &&
                                                  controller
                                                          .burnFormData
                                                          .value
                                                          .burnsOutcome
                                                          ?.transferredTo ==
                                                      1 ||
                                              controller
                                                      .burnFormData
                                                      .value
                                                      .burnsOutcome
                                                      ?.transferredTo ==
                                                  2)
                                            if (controller
                                                        .burnFormData
                                                        .value
                                                        .burnsOutcome
                                                        ?.transferredTo !=
                                                    null &&
                                                controller
                                                        .burnFormData
                                                        .value
                                                        .burnsOutcome
                                                        ?.transferredTo ==
                                                    1)
                                              CommonDateTimeWidget(
                                                isRequired:
                                                    false, // MANDATORY when transferred to ward
                                                title: "Ward Date",
                                                dateTime: controller
                                                    .burnFormData
                                                    .value
                                                    .burnsOutcome
                                                    ?.wardDatetime
                                                    .toString(),
                                                onChanged: (value) {
                                                  controller
                                                      .burnFormData
                                                      .value
                                                      .burnsOutcome
                                                      ?.wardDatetime = value;
                                                  controller.burnFormData
                                                      .refresh();
                                                },
                                              ),
                                          if (controller
                                                      .burnFormData
                                                      .value
                                                      .burnsOutcome
                                                      ?.transferredTo !=
                                                  null &&
                                              controller
                                                      .burnFormData
                                                      .value
                                                      .burnsOutcome
                                                      ?.transferredTo ==
                                                  2)
                                            CommonDateTimeWidget(
                                              isRequired:
                                                  true, // MANDATORY when transferred to ICU
                                              title: "ICU Date",
                                              dateTime: controller
                                                  .burnFormData
                                                  .value
                                                  .burnsOutcome
                                                  ?.icuDatetime
                                                  .toString(),
                                              onChanged: (value) {
                                                controller
                                                    .burnFormData
                                                    .value
                                                    .burnsOutcome
                                                    ?.icuDatetime = value;
                                                controller.burnFormData
                                                    .refresh();
                                              },
                                            ),
                                          NewTitleYesRadio(
                                            isRequired: false, // MANDATORY
                                            title:
                                                'Wound Management - Conservative',
                                            initialValue: controller
                                                .burnFormData
                                                .value
                                                .burnsValues
                                                ?.woundManagementConservative,
                                            onChanged: (value) {
                                              controller
                                                      .burnFormData
                                                      .value
                                                      .burnsValues
                                                      ?.woundManagementConservative =
                                                  value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          if (controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.woundManagementConservative ==
                                              true)
                                            NewTitleDropdown(
                                              isRequired:
                                                  true, // MANDATORY when conservative management is Yes
                                              title:
                                                  'Wound Management -Conservative',
                                              items: controller.lookupList.value
                                                      ?.conservative
                                                      ?.map((e) => {
                                                            "id": e.id ?? "",
                                                            "name":
                                                                e.name ?? "",
                                                          })
                                                      .toList() ??
                                                  [],
                                              selectedId: controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.conservative,
                                              hint:
                                                  'Select wound management type',
                                              onChanged: (value) {
                                                controller
                                                    .burnFormData
                                                    .value
                                                    .burnsValues
                                                    ?.conservative = value;
                                                controller.burnFormData
                                                    .refresh();
                                              },
                                            ),
                                          if (controller.burnFormData.value
                                                  .burnsValues?.conservative ==
                                              3)
                                            TitleTextFormField(
                                              isRequired:
                                                  true, // MANDATORY when "Other" is selected
                                              title: 'Other Dressings',
                                              controller: TextEditingController(
                                                  text: controller
                                                      .burnFormData
                                                      .value
                                                      .burnsValues
                                                      ?.othConservative),
                                              keyboardType: TextInputType.name,
                                              hintText:
                                                  ' Enter Other Dressings',
                                              onChanged: (v) {
                                                controller
                                                    .burnFormData
                                                    .value
                                                    .burnsValues
                                                    ?.othConservative = v;
                                              },
                                            ),
                                          NewTitleYesRadio(
                                            isRequired: true, // MANDATORY
                                            title: 'Surgery - Emergency',
                                            initialValue: controller
                                                .burnFormData
                                                .value
                                                .burnsValues
                                                ?.isSurgeryEmergency,
                                            onChanged: (value) {
                                              controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.isSurgeryEmergency = value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          if (controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.isSurgeryEmergency ==
                                              true)
                                            NewTitleDropdown(
                                              isRequired:
                                                  true, // MANDATORY when emergency surgery is Yes
                                              title: 'Surgery - Emergency',
                                              hint:
                                                  'Select Surgical Procedures',
                                              items: controller.lookupList.value
                                                      ?.surgeryEmergency
                                                      ?.map((e) => {
                                                            "id": e.id ?? "",
                                                            "name":
                                                                e.name ?? "",
                                                          })
                                                      .toList() ??
                                                  [],
                                              selectedId: controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.surgeryEmergency,
                                              onChanged: (value) {
                                                controller
                                                    .burnFormData
                                                    .value
                                                    .burnsValues
                                                    ?.surgeryEmergency = value;
                                                controller.burnFormData
                                                    .refresh();
                                              },
                                            ),
                                          if (controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.surgeryEmergency !=
                                              null)
                                            CommonDateTimeWidget(
                                              isRequired:
                                                  true, // MANDATORY when emergency surgery is selected
                                              title: "Surgery Date And Time",
                                              dateTime: controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.surgeryPerformedDate
                                                  .toString(),
                                              onChanged: (value) {
                                                controller
                                                        .burnFormData
                                                        .value
                                                        .burnsValues
                                                        ?.surgeryPerformedDate =
                                                    value;
                                                controller.burnFormData
                                                    .refresh();
                                              },
                                            ),
                                          NewTitleYesRadio(
                                            isRequired: true, // MANDATORY
                                            title: 'Surgery - Elective',
                                            initialValue: controller
                                                .burnFormData
                                                .value
                                                .burnsValues
                                                ?.isSurgeryElectivePerformed,
                                            onChanged: (value) {
                                              controller
                                                      .burnFormData
                                                      .value
                                                      .burnsValues
                                                      ?.isSurgeryElectivePerformed =
                                                  value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          if (controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.isSurgeryElectivePerformed ==
                                              true)
                                            Column(
                                              spacing: 18,
                                              children: [
                                                Column(
                                                  children: [
                                                    ...List.generate(
                                                      controller
                                                              .burnFormData
                                                              .value
                                                              .burnsSurgeryElective
                                                              ?.length ??
                                                          0,
                                                      (index) {
                                                        final item = controller
                                                                .burnFormData
                                                                .value
                                                                .burnsSurgeryElective![
                                                            index];
                                                        return Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 8),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors
                                                                .grey.shade100,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300),
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              NewTitleDropdown(
                                                                isRequired:
                                                                    true, // MANDATORY for each elective surgery
                                                                title:
                                                                    'Surgery - Elective',
                                                                hint:
                                                                    'Select Surgery - Elective',
                                                                selectedId: item
                                                                    .surgeryElective,
                                                                items: controller
                                                                        .lookupList
                                                                        .value
                                                                        ?.surgeryElective!
                                                                        .map((e) =>
                                                                            {
                                                                              "id": e.id,
                                                                              "name": e.name
                                                                            })
                                                                        .toList() ??
                                                                    [],
                                                                onChanged:
                                                                    (value) {
                                                                  item.surgeryElective =
                                                                      value;
                                                                  controller
                                                                      .burnFormData
                                                                      .refresh();
                                                                },
                                                              ),
                                                              CommonDateTimeWidget(
                                                                isRequired:
                                                                    true, // MANDATORY for each elective surgery
                                                                title:
                                                                    'Elective Surgery Date and Time',
                                                                dateTime: item
                                                                    .surgeryElectiveDate
                                                                    .toString(),
                                                                onChanged:
                                                                    (date) {
                                                                  item.surgeryElectiveDate =
                                                                      date;
                                                                  controller
                                                                      .burnFormData
                                                                      .refresh();
                                                                },
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                child:
                                                                    IconButton(
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .delete,
                                                                      color: Colors
                                                                          .red),
                                                                  onPressed:
                                                                      () {
                                                                    controller
                                                                        .burnFormData
                                                                        .value
                                                                        .burnsSurgeryElective!
                                                                        .removeAt(
                                                                            index);
                                                                    controller
                                                                        .burnFormData
                                                                        .refresh();
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    ElevatedButton.icon(
                                                      onPressed: () {
                                                        controller
                                                            .burnFormData
                                                            .value
                                                            .burnsSurgeryElective!
                                                            .add(
                                                                BurnsSurgeryElective());
                                                        controller.burnFormData
                                                            .refresh();
                                                      },
                                                      icon:
                                                          const Icon(Icons.add),
                                                      label: const Text(
                                                          "Add Elective Surgery"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          NewCheckboxList(
                                            isRequired: false, // MANDATORY
                                            title: 'Supportive Measures',
                                            options: controller.lookupList.value
                                                    ?.supportiveMeasures ??
                                                [],
                                            initialSelectedIndexes: controller
                                                    .burnFormData
                                                    .value
                                                    .burnsValues
                                                    ?.supportiveMeasures ??
                                                [],
                                            onChanged: (value) {
                                              controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.supportiveMeasures = value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          NewCheckboxList(
                                            isRequired: true, // MANDATORY
                                            title:
                                                'Complications During Hospital Stay',
                                            options: controller.lookupList.value
                                                    ?.stayComplications ??
                                                [],
                                            initialSelectedIndexes: controller
                                                    .burnFormData
                                                    .value
                                                    .burnsValues
                                                    ?.complicationsHospitalStay ??
                                                [],
                                            onChanged: (value) {
                                              controller
                                                      .burnFormData
                                                      .value
                                                      .burnsValues
                                                      ?.complicationsHospitalStay =
                                                  value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          NewCheckboxList(
                                            isRequired: true, // MANDATORY
                                            title: 'Multidisciplinary Support',
                                            options: controller.lookupList.value
                                                    ?.multidisciplinarySupport ??
                                                [],
                                            initialSelectedIndexes: controller
                                                    .burnFormData
                                                    .value
                                                    .burnsValues
                                                    ?.multidisciplinarySupport ??
                                                [],
                                            onChanged: (value) {
                                              controller
                                                      .burnFormData
                                                      .value
                                                      .burnsValues
                                                      ?.multidisciplinarySupport =
                                                  value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          if (controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.multidisciplinarySupport
                                                  ?.contains(19) ??
                                              false)
                                            TitleTextFormField(
                                              isRequired:
                                                  true, // MANDATORY when "Other" is selected
                                              keyboardType:
                                                  TextInputType.number,
                                              title: 'Quantity',
                                              initialValue: controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.othMultidisciplinarySupport,
                                              onChanged: (value) {
                                                controller
                                                        .burnFormData
                                                        .value
                                                        .burnsValues
                                                        ?.othMultidisciplinarySupport =
                                                    value;
                                                controller.burnFormData
                                                    .refresh();
                                              },
                                            ),
                                          NewTitleYesRadio(
                                            isRequired: true, // MANDATORY
                                            title: 'Skin Bank Available',
                                            initialValue: controller
                                                .burnFormData
                                                .value
                                                .burnsValues
                                                ?.skinBankAvailable,
                                            onChanged: (value) {
                                              controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.skinBankAvailable = value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          NewTitleYesRadio(
                                            isRequired: true, // MANDATORY
                                            title: 'Hyper Baric Oxygen Therapy',
                                            initialValue: controller
                                                .burnFormData
                                                .value
                                                .burnsValues
                                                ?.hyperBaric,
                                            onChanged: (value) {
                                              controller
                                                  .burnFormData
                                                  .value
                                                  .burnsValues
                                                  ?.hyperBaric = value;
                                              controller.burnFormData.refresh();
                                            },
                                          ),
                                          Space(height: 20),
                                        ],
                                      )
                                    : controller.currentIndex.value == 3
                                        ? Column(
                                            spacing: 18,
                                            children: [
                                              Column(
                                                spacing: 18,
                                                children: [
                                                  NewTitleDropdown(
                                                    isRequired:
                                                        true, // MANDATORY
                                                    title: 'Out come',
                                                    hint: 'Select Out come',
                                                    items: controller.lookupList
                                                            .value?.outcome
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
                                                        .burnFormData
                                                        .value
                                                        .burnsOutcome
                                                        ?.outcome,
                                                    onChanged: (value) {
                                                      controller
                                                          .burnFormData
                                                          .value
                                                          .burnsOutcome
                                                          ?.outcome = value;
                                                      controller.burnFormData
                                                          .refresh();
                                                    },
                                                  ),
                                                  if (controller
                                                                  .burnFormData
                                                                  .value
                                                                  .burnsOutcome
                                                                  ?.outcome !=
                                                              null &&
                                                          controller
                                                                  .burnFormData
                                                                  .value
                                                                  .burnsOutcome
                                                                  ?.outcome ==
                                                              1 ||
                                                      controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome ==
                                                          2 ||
                                                      controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome ==
                                                          3)
                                                    CommonDateTimeWidget(
                                                      isRequired:
                                                          true, // MANDATORY for outcomes 1,2,3
                                                      title: 'Date and Time',
                                                      dateTime: controller
                                                          .burnFormData
                                                          .value
                                                          .burnsOutcome
                                                          ?.dischargeDate,
                                                      onChanged: (value) {
                                                        controller
                                                                .burnFormData
                                                                .value
                                                                .burnsOutcome
                                                                ?.dischargeDate =
                                                            value;
                                                      },
                                                    ),
                                                  if (controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome !=
                                                          null &&
                                                      controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome ==
                                                          4)
                                                    CommonDateTimeWidget(
                                                      isRequired:
                                                          true, // MANDATORY for outcome 4
                                                      title: "Absconded Date",
                                                      dateTime: controller
                                                          .burnFormData
                                                          .value
                                                          .burnsOutcome
                                                          ?.abscondedDate
                                                          .toString(),
                                                      onChanged: (value) {
                                                        controller
                                                                .burnFormData
                                                                .value
                                                                .burnsOutcome
                                                                ?.abscondedDate =
                                                            value;
                                                        controller.burnFormData
                                                            .refresh();
                                                      },
                                                    ),
                                                  if (controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome !=
                                                          null &&
                                                      controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome ==
                                                          5)
                                                    CommonDateTimeWidget(
                                                      isRequired:
                                                          true, // MANDATORY for outcome 5
                                                      title: "Death Date",
                                                      dateTime: controller
                                                          .burnFormData
                                                          .value
                                                          .burnsOutcome
                                                          ?.deathDate
                                                          .toString(),
                                                      onChanged: (value) {
                                                        controller
                                                            .burnFormData
                                                            .value
                                                            .burnsOutcome
                                                            ?.deathDate = value;
                                                        controller.burnFormData
                                                            .refresh();
                                                      },
                                                    ),
                                                  if (controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome !=
                                                          null &&
                                                      controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome ==
                                                          7)
                                                    CommonDateTimeWidget(
                                                      isRequired:
                                                          true, // MANDATORY for outcome 7
                                                      title:
                                                          'Patient Exit Date',
                                                      dateTime: controller
                                                          .burnFormData
                                                          .value
                                                          .burnsOutcome
                                                          ?.patientExitDate
                                                          .toString(),
                                                      onChanged: (value) {
                                                        controller
                                                                .burnFormData
                                                                .value
                                                                .burnsOutcome
                                                                ?.patientExitDate =
                                                            value;
                                                        controller.burnFormData
                                                            .refresh();
                                                      },
                                                    ),
                                                  if (controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome !=
                                                          null &&
                                                      controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.outcome ==
                                                          6)
                                                    Column(
                                                      spacing: 18,
                                                      children: [
                                                        NewTitleDropdown(
                                                          isRequired:
                                                              true, // MANDATORY for referral
                                                          title:
                                                              'Hospital Type',
                                                          hint:
                                                              'Select Hospital Type',
                                                          items: controller
                                                                  .lookupList
                                                                  .value
                                                                  ?.hospitalType
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
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.hospitalType,
                                                          onChanged: (value) {
                                                            controller
                                                                    .burnFormData
                                                                    .value
                                                                    .burnsOutcome
                                                                    ?.hospitalType =
                                                                value;
                                                            controller
                                                                .burnFormData
                                                                .refresh();
                                                          },
                                                        ),
                                                        if (controller
                                                                .burnFormData
                                                                .value
                                                                .burnsOutcome
                                                                ?.hospitalType ==
                                                            1)
                                                          NewTitleDropdown(
                                                            isRequired:
                                                                true, // MANDATORY for TAEI hospital
                                                            title:
                                                                'Destination hospital',
                                                            hint:
                                                                'Select Destination hospital',
                                                            items: hospitalController
                                                                    .hospitalList
                                                                    .map(
                                                                        (e) => {
                                                                              "hospitalid": e.hospitalid ?? "",
                                                                              "hospitalname": e.hospitalname ?? "",
                                                                            })
                                                                    .toList() ??
                                                                [],
                                                            selectedId: controller
                                                                .burnFormData
                                                                .value
                                                                .burnsOutcome
                                                                ?.destinationTAEIHospitalId,
                                                            onChanged: (value) {
                                                              controller
                                                                  .burnFormData
                                                                  .value
                                                                  .burnsOutcome
                                                                  ?.destinationTAEIHospitalId = value;
                                                              controller
                                                                  .burnFormData
                                                                  .refresh();
                                                            },
                                                          ),
                                                        if (controller
                                                                .burnFormData
                                                                .value
                                                                .burnsOutcome
                                                                ?.hospitalType ==
                                                            2)
                                                          TitleTextFormField(
                                                            isRequired:
                                                                true, // MANDATORY for non-TAEI hospital
                                                            controller: TextEditingController(
                                                                text: controller
                                                                    .burnFormData
                                                                    .value
                                                                    .burnsOutcome
                                                                    ?.destinationHospital),
                                                            title:
                                                                'Destination Non TAEI hospital',
                                                            hintText:
                                                                'Enter Destination Non TAEI hospital',
                                                            onChanged: (value) {
                                                              controller
                                                                  .burnFormData
                                                                  .value
                                                                  .burnsOutcome
                                                                  ?.destinationHospital = value;
                                                              controller
                                                                  .burnFormData
                                                                  .refresh();
                                                            },
                                                          ),
                                                        NewTitleDropdown(
                                                          isRequired:
                                                              true, // MANDATORY for referral
                                                          title:
                                                              'Reason for referral',
                                                          hint: 'Select Reason',
                                                          items: controller
                                                                  .lookupList
                                                                  .value
                                                                  ?.reasonForReferral
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
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.reasonForReferral,
                                                          onChanged: (value) {
                                                            controller
                                                                    .burnFormData
                                                                    .value
                                                                    .burnsOutcome
                                                                    ?.reasonForReferral =
                                                                value;
                                                            controller
                                                                .burnFormData
                                                                .refresh();
                                                          },
                                                        ),
                                                        NewTitleDropdown(
                                                          isRequired:
                                                              true, // MANDATORY for referral
                                                          title:
                                                              'Condition of patient',
                                                          hint:
                                                              'Select Condition',
                                                          items: controller
                                                                  .lookupList
                                                                  .value
                                                                  ?.conditionOfPatient
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
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.conditionOfPatient,
                                                          onChanged: (value) {
                                                            controller
                                                                    .burnFormData
                                                                    .value
                                                                    .burnsOutcome
                                                                    ?.conditionOfPatient =
                                                                value;
                                                            controller
                                                                .burnFormData
                                                                .refresh();
                                                          },
                                                        ),
                                                        TitleTextFormField(
                                                          isRequired:
                                                              true, // MANDATORY for referral
                                                          title:
                                                              'Referring Doctor Name',
                                                          controller: TextEditingController(
                                                              text: controller
                                                                  .burnFormData
                                                                  .value
                                                                  .burnsOutcome
                                                                  ?.referringDoctorName),
                                                          keyboardType:
                                                              TextInputType
                                                                  .name,
                                                          hintText:
                                                              'Enter Doctor Name',
                                                          onChanged: (v) {
                                                            controller
                                                                .burnFormData
                                                                .value
                                                                .burnsOutcome
                                                                ?.referringDoctorName = v;
                                                          },
                                                        ),
                                                        NewTitleYesRadio(
                                                          isRequired:
                                                              true, // MANDATORY for referral
                                                          title:
                                                              'Whether details documented in TAEI Case sheet',
                                                          initialValue: controller
                                                              .burnFormData
                                                              .value
                                                              .burnsOutcome
                                                              ?.documentedTaeiSheet,
                                                          onChanged: (value) {
                                                            controller
                                                                    .burnFormData
                                                                    .value
                                                                    .burnsOutcome
                                                                    ?.documentedTaeiSheet =
                                                                value;
                                                            controller
                                                                .burnFormData
                                                                .refresh();
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                ],
                                              ),
                                              Space(height: 20),
                                            ],
                                          )
                                        : Container(),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              controller.currentIndex.value == 0
                                  ? const SizedBox()
                                  : CommonElevatedButtonM(
                                      backgroundColor: Colors.white,
                                      text: 'Back',
                                      onPressed: () {
                                        if (controller.currentIndex.value > 0) {
                                          controller.changeIndex(
                                            controller.currentIndex.value - 1,
                                          );
                                        }
                                      },
                                    ),
                              CommonElevatedButton(
                                text: controller.currentIndex.value < 3
                                    ? 'Next'
                                    : 'Submit',
                                onPressed: () async {
                                  if (controller.currentIndex.value < 3) {
                                    controller.currentIndex.value++;
                                    return;
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (_) => SaveOrSubmitDialog(
                                      title: 'Save or Submit',
                                      content: 'Do you want to save or submit?',
                                      onSave: () async {
                                        if (!validateBurnsForm(outcome: false))
                                          return;

                                        await _handleSaveOrSubmit(
                                            isDischarged: false);
                                      },
                                      onSubmit: () async {
                                        if (!validateBurnsForm(outcome: true))
                                          return;

                                        await _handleSaveOrSubmit(
                                            isDischarged: true);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
      ),
    );
  }

  Widget finalScreen() {
    return Form(
      key: formKey4,
      child:
          SizedBox() /*Column(
        spacing: 18,
        children: [
          TitleDropdown(
              title: 'Transferred To',
              hint: "Select Transferred To",
              items: controller.lookupList.value?.transferredTo
                      ?.map((e) => e.name)
                      .toList() ??
                  [],
              selectedItem: getName(
                  controller.lookupList.value!.transferredTo!,
                  controller.burnFormData.value!.burnsOutcome!.transferredTo ??
                      0),
              onChanged: (value) {
                controller.burnFormData.value!.burnsOutcome!.transferredTo =
                    getId(controller.lookupList.value!.transferredTo!, value);
                controller.burnFormData.refresh();
              }),
          if (controller.burnFormData.value!.burnsOutcome!.transferredTo !=
                  null &&
              controller.burnFormData.value!.burnsOutcome!.transferredTo == 4)
            Column(
              spacing: 18,
              children: [
                TitleDropdown(
                    title: 'Hospital Type',
                    hint: "Select Hospital Type",
                    items: controller.lookupList.value?.hospitalType
                            ?.map((e) => e.name)
                            .toList() ??
                        [],
                    selectedItem: getName(
                        controller.lookupList.value!.hospitalType!,
                        controller.burnFormData.value!.burnsOutcome!
                                .hospitalType ??
                            0),
                    onChanged: (value) {
                      controller
                              .burnFormData.value!.burnsOutcome!.hospitalType =
                          getId(controller.lookupList.value!.hospitalType!,
                              value);
                      controller.burnFormData.refresh();
                    }),
                TitleDropdown(
                    title: 'Hospital Destination',
                    hint: "Select Hospital Destination",
                    items: controller.lookupList.value?.destinationHospital
                            ?.map((e) => e.name)
                            .toList() ??
                        [],
                    selectedItem: getName(
                        controller.lookupList.value!.destinationHospital!,
                        controller.burnFormData.value!.burnsOutcome!
                                .destinationHospital ??
                            0),
                    onChanged: (value) {
                      controller.burnFormData.value!.burnsOutcome!
                              .destinationHospital =
                          getId(
                              controller.lookupList.value!.destinationHospital!,
                              value);
                      controller.burnFormData.refresh();
                    }),
                TitleDropdown(
                    title: 'Reason for referral',
                    hint: "Select Reason",
                    items: controller.lookupList.value?.reasonForReferral
                            ?.map((e) => e.name)
                            .toList() ??
                        [],
                    selectedItem: getName(
                        controller.lookupList.value!.reasonForReferral!,
                        controller.burnFormData.value!.burnsOutcome!
                                .reasonForReferral ??
                            0),
                    onChanged: (value) {
                      controller.burnFormData.value!.burnsOutcome!
                              .reasonForReferral =
                          getId(controller.lookupList.value!.reasonForReferral!,
                              value);
                      controller.burnFormData.refresh();
                    }),
                TitleDropdown(
                    title: 'Condition of patient',
                    hint: "Select Condition",
                    items: controller.lookupList.value?.conditionOfPatient
                            ?.map((e) => e.name)
                            .toList() ??
                        [],
                    selectedItem: getName(
                        controller.lookupList.value!.conditionOfPatient!,
                        controller.burnFormData.value!.burnsOutcome!
                                .conditionOfPatient ??
                            0),
                    onChanged: (value) {
                      controller.burnFormData.value!.burnsOutcome!
                              .conditionOfPatient =
                          getId(
                              controller.lookupList.value!.conditionOfPatient!,
                              value);
                      controller.burnFormData.refresh();
                    }),
                TitleTextFormField(
                  title: 'Referring Doctor Name',
                  controller: TextEditingController(
                      text: controller.burnFormData.value!.burnsOutcome!
                          .referringDoctorName),
                  keyboardType: TextInputType.name,
                  hintText: 'Enter Doctor Name',
                  onChanged: (v) {
                    controller.burnFormData.value!.burnsOutcome!
                        .referringDoctorName = v;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Doctor Name';
                    } else {
                      return null;
                    }
                  },
                ),
                TitleYesRadio(
                    title: 'Whether details documented in TAEI Case sheet',
                    initialValue: controller.burnFormData.value!.burnsOutcome!
                                .documentedTaeiSheet ==
                            null
                        ? null
                        : controller.burnFormData.value!.burnsOutcome!
                                    .documentedTaeiSheet ==
                                true
                            ? "Yes"
                            : "No",
                    onChanged: (value) {
                      controller.burnFormData.value!.burnsOutcome!
                          .documentedTaeiSheet = value == "Yes" ? true : false;
                      controller.burnFormData.refresh();
                    }),
              ],
            ),
          if (controller.burnFormData.value!.burnsOutcome!.transferredTo !=
                      null &&
                  controller.burnFormData.value!.burnsOutcome!.transferredTo ==
                      2 ||
              controller.burnFormData.value!.burnsOutcome!.transferredTo == 1)
            wardWidget(),
          if (controller.burnFormData.value!.burnsOutcome!.transferredTo !=
                  null &&
              controller.burnFormData.value!.burnsOutcome!.transferredTo != 4)
            outcomeWidget(),
          Space(height: 20),
        ],
      )*/
      ,
    );
  }

  Future<void> _handleSaveOrSubmit({required bool isDischarged}) async {
    controller.burnFormData.value.burns?.triageId =
        int.parse(widget.triageId.toString());

    controller.burnFormData.value.burnsOutcome?.isDischarged = isDischarged;

    if (widget.isUpdate == true) {
      await controller.updateBurns(
        data: controller.burnFormData.value,
        id: widget.burnId?.toString() ??
            controller.burnFormData.value.burns?.id?.toString() ??
            "",
      );
    } else {
      await controller.createBurns(
        data: controller.burnFormData.value,
      );
    }

    Get.back();
  }

  Widget wardWidget() {
    return Column(
      spacing: 18,
      children: [
        if (controller.burnFormData.value.burnsOutcome?.transferredTo != null &&
            controller.burnFormData.value.burnsOutcome?.transferredTo == 1)
          CommonDateTimeWidget(
            title: "Ward Date",
            dateTime: controller.burnFormData.value.burnsOutcome?.wardDatetime
                .toString(),
            onChanged: (value) {
              controller.burnFormData.value.burnsOutcome?.wardDatetime = value;
              controller.burnFormData.refresh();
            },
          ),
        if (controller.burnFormData.value.burnsOutcome?.transferredTo != null &&
            controller.burnFormData.value.burnsOutcome?.transferredTo == 2)
          CommonDateTimeWidget(
            title: "ICU Date",
            dateTime: controller.burnFormData.value.burnsOutcome?.icuDatetime
                .toString(),
            onChanged: (value) {
              controller.burnFormData.value.burnsOutcome?.icuDatetime = value;
              controller.burnFormData.refresh();
            },
          ),
        NewTitleYesRadio(
            title: 'Surgery - Emergency procedure is already done ',
            initialValue:
                controller.burnFormData.value.burnsValues?.isSurgeryEmergency,
            onChanged: (value) {
              controller.burnFormData.value.burnsValues?.isSurgeryEmergency =
                  value;
              controller.burnFormData.refresh();
            }),
        if (controller.burnFormData.value.burnsValues?.isSurgeryEmergency !=
                null &&
            controller.burnFormData.value.burnsValues?.isSurgeryEmergency ==
                false)
          Column(
            spacing: 18,
            children: [
              NewTitleDropdown(
                  title: 'Surgery - Emergency',
                  hint: 'Select Surgical Procedures',
                  items: controller.lookupList.value?.surgeryEmergency
                          ?.map((e) => {
                                "id": e.id ?? "",
                                "name": e.name ?? "",
                              })
                          .toList() ??
                      [],
                  selectedId: controller
                      .burnFormData.value.burnsValues?.surgeryEmergency,
                  onChanged: (value) {
                    controller.burnFormData.value.burnsValues
                        ?.surgeryEmergency = value;
                    controller.burnFormData.refresh();
                  }),
              CommonDateTimeWidget(
                title: "Surgery Date",
                dateTime: controller
                    .burnFormData.value.burnsValues?.surgeryPerformedDate
                    .toString(),
                onChanged: (value) {
                  controller.burnFormData.value.burnsValues
                      ?.surgeryPerformedDate = value;
                  controller.burnFormData.refresh();
                },
              ),
              Column(
                children: [
                  // Existing list of elective surgeries
                  ...List.generate(
                    controller
                            .burnFormData.value.burnsSurgeryElective?.length ??
                        0,
                    (index) {
                      final item = controller
                          .burnFormData.value.burnsSurgeryElective![index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            NewTitleDropdown(
                              title: 'Surgery - Elective',
                              hint: 'Select Surgery - Elective',
                              selectedId: item.surgeryElective,
                              items: controller
                                      .lookupList.value?.surgeryElective!
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList() ??
                                  [],
                              onChanged: (value) {
                                item.surgeryElective = value;
                                controller.burnFormData.refresh();
                                print("Selected ID: $value");
                              },
                            ),
                            CommonDateTimeWidget(
                                title: 'Elective Surgery Date and Time',
                                dateTime: item.surgeryElectiveDate.toString(),
                                onChanged: (date) {
                                  item.surgeryElectiveDate = date;
                                  controller.burnFormData.refresh();
                                }),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  controller
                                      .burnFormData.value.burnsSurgeryElective!
                                      .removeAt(index);
                                  controller.burnFormData.refresh();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Add button
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.burnFormData.value.burnsSurgeryElective!
                          .add(BurnsSurgeryElective()); // add() returns void
                      controller.burnFormData.refresh();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Elective Surgery"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        if (controller.burnFormData.value.burnsValues?.isSurgeryEmergency !=
                null &&
            controller.burnFormData.value.burnsValues?.isSurgeryEmergency ==
                true)
          Column(
            children: [
              Column(
                children: [
                  // Existing list of elective surgeries
                  ...List.generate(
                    controller
                            .burnFormData.value.burnsSurgeryElective?.length ??
                        0,
                    (index) {
                      final item = controller
                          .burnFormData.value.burnsSurgeryElective![index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            NewTitleDropdown(
                              title: 'Surgery - Elective',
                              hint: 'Select Surgery - Elective',
                              selectedId: item.surgeryElective,
                              items: controller
                                      .lookupList.value?.surgeryElective!
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList() ??
                                  [],
                              onChanged: (value) {
                                item.surgeryElective = value;
                                controller.burnFormData.refresh();
                                print("Selected ID: $value");
                              },
                            ),
                            CommonDateTimeWidget(
                                title: 'Elective Surgery Date and Time',
                                dateTime: item.surgeryElectiveDate.toString(),
                                onChanged: (date) {
                                  item.surgeryElectiveDate = date;
                                  controller.burnFormData.refresh();
                                }),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  controller
                                      .burnFormData.value.burnsSurgeryElective!
                                      .removeAt(index);
                                  controller.burnFormData.refresh();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Add button
                  ElevatedButton.icon(
                    onPressed: () {
                      controller.burnFormData.value.burnsSurgeryElective!
                          .add(BurnsSurgeryElective()); // add() returns void
                      controller.burnFormData.refresh();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add Elective Surgery"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        NewTitleYesRadio(
            title: 'Skin Bank Available',
            initialValue:
                controller.burnFormData.value.burnsValues?.skinBankAvailable,
            onChanged: (value) {
              controller.burnFormData.value.burnsValues?.skinBankAvailable =
                  value;
              controller.burnFormData.refresh();
            }),
        NewTitleYesRadio(
            title: 'Hyper Baric Oxygen Therapy',
            initialValue: controller.burnFormData.value.burnsValues?.hyperBaric,
            onChanged: (value) {
              controller.burnFormData.value.burnsValues?.hyperBaric = value;
              controller.burnFormData.refresh();
            }),
      ],
    );
  }
}

/*Widget outcomeWidget() {
    return SizedBox() /*Column(
      spacing: 18,
      children: [
        TitleDropdown(
            title: 'Out come',
            hint: 'Select Out come',
            items: controller.lookupList.value?.outcome
                    ?.map((e) => e.name)
                    .toList() ??
                [],
            selectedItem: getName(controller.lookupList.value!.outcome!,
                controller.burnFormData.value!.burnsOutcome!.outcome ?? 0),
            onChanged: (value) {
              controller.burnFormData.value!.burnsOutcome!.outcome =
                  getId(controller.lookupList.value!.outcome!, value);
              controller.burnFormData.refresh();
            }),
        if (controller.burnFormData.value!.burnsOutcome!.outcome != null &&
                controller.burnFormData.value!.burnsOutcome!.outcome == 1 ||
            controller.burnFormData.value!.burnsOutcome!.outcome == 2 ||
            controller.burnFormData.value!.burnsOutcome!.outcome == 3)
          DateTimeRowPicker(
            dateTitle: "Discharge Date",
            timeTitle: "Discharge Time",
            apiDate: controller.burnFormData.value!.burnsOutcome!.dischargeDate
                ?.toString(),
            apiTime:
                controller.burnFormData.value!.burnsOutcome!.dischargeDate ==
                        null
                    ? null
                    : DateFormat('hh:mm a').format(controller
                        .burnFormData.value!.burnsOutcome!.dischargeDate!),
            onDateTimeChanged: (date) {
              log(date.toString());
              controller.burnFormData.value!.burnsOutcome!.dischargeDate = date;
            },
          ),
        if (controller.burnFormData.value!.burnsOutcome!.outcome != null &&
            controller.burnFormData.value!.burnsOutcome!.outcome == 4)
          DateTimeRowPicker(
            dateTitle: "Absconded Date",
            timeTitle: "Absconded Time",
            apiDate: controller.burnFormData.value!.burnsOutcome!.abscondedDate
                ?.toString(),
            apiTime:
                controller.burnFormData.value!.burnsOutcome!.abscondedDate ==
                        null
                    ? null
                    : DateFormat('hh:mm a').format(controller
                        .burnFormData.value!.burnsOutcome!.abscondedDate!),
            onDateTimeChanged: (date) {
              log(date.toString());
              controller.burnFormData.value!.burnsOutcome!.abscondedDate = date;
            },
          ),
        if (controller.burnFormData.value!.burnsOutcome!.outcome != null &&
            controller.burnFormData.value!.burnsOutcome!.outcome == 5)
          DateTimeRowPicker(
            dateTitle: "Death Date",
            timeTitle: "Death Time",
            apiDate: controller.burnFormData.value!.burnsOutcome!.deathDate
                ?.toString(),
            apiTime: controller.burnFormData.value!.burnsOutcome!.deathDate ==
                    null
                ? null
                : DateFormat('hh:mm a').format(
                    controller.burnFormData.value!.burnsOutcome!.deathDate!),
            onDateTimeChanged: (date) {
              log(date.toString());
              controller.burnFormData.value!.burnsOutcome!.deathDate = date;
            },
          ),
        if (controller.burnFormData.value!.burnsOutcome!.outcome != null &&
            controller.burnFormData.value!.burnsOutcome!.outcome == 6)
          Column(
            spacing: 18,
            children: [
              TitleDropdown(
                  title: 'Hospital Type',
                  hint: 'Select Hospital Type',
                  items: controller.lookupList.value?.hospitalType
                          ?.map((e) => e.name)
                          .toList() ??
                      [],
                  selectedItem: getName(
                      controller.lookupList.value!.hospitalType!,
                      controller
                              .burnFormData.value!.burnsOutcome!.hospitalType ??
                          0),
                  onChanged: (value) {
                    controller.burnFormData.value!.burnsOutcome!.hospitalType =
                        getId(
                            controller.lookupList.value!.hospitalType!, value);
                    controller.burnFormData.refresh();
                  }),
              TitleDropdown(
                  title: 'Destination hospital',
                  hint: 'Select Destination hospital',
                  items: controller.lookupList.value?.destinationHospital
                          ?.map((e) => e.name)
                          .toList() ??
                      [],
                  selectedItem: getName(
                      controller.lookupList.value!.destinationHospital!,
                      controller.burnFormData.value!.burnsOutcome!
                              .destinationHospital ??
                          0),
                  onChanged: (value) {
                    controller.burnFormData.value!.burnsOutcome!
                            .destinationHospital =
                        getId(controller.lookupList.value!.destinationHospital!,
                            value);
                    controller.burnFormData.refresh();
                  }),
              TitleDropdown(
                  title: 'Reason for referral',
                  hint: 'Select Reason',
                  items: controller.lookupList.value?.reasonForReferral
                          ?.map((e) => e.name)
                          .toList() ??
                      [],
                  selectedItem: getName(
                      controller.lookupList.value!.reasonForReferral!,
                      controller.burnFormData.value!.burnsOutcome!
                              .reasonForReferral ??
                          0),
                  onChanged: (value) {
                    controller.burnFormData.value!.burnsOutcome!
                            .reasonForReferral =
                        getId(controller.lookupList.value!.reasonForReferral!,
                            value);
                    controller.burnFormData.refresh();
                  }),
              TitleDropdown(
                  title: 'Condition of patient',
                  hint: 'Select Condition',
                  items: controller.lookupList.value?.conditionOfPatient
                          ?.map((e) => e.name)
                          .toList() ??
                      [],
                  selectedItem: getName(
                      controller.lookupList.value!.conditionOfPatient!,
                      controller.burnFormData.value!.burnsOutcome!
                              .conditionOfPatient ??
                          0),
                  onChanged: (value) {
                    controller.burnFormData.value!.burnsOutcome!
                            .conditionOfPatient =
                        getId(controller.lookupList.value!.conditionOfPatient!,
                            value);
                    controller.burnFormData.refresh();
                  }),
              TitleTextFormField(
                title: 'Referring Doctor Name',
                controller: TextEditingController(
                    text: controller
                        .burnFormData.value!.burnsOutcome!.referringDoctorName),
                keyboardType: TextInputType.name,
                hintText: 'Enter Doctor Name',
                onChanged: (v) {
                  controller.burnFormData.value!.burnsOutcome!
                      .referringDoctorName = v;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Doctor Name';
                  } else {
                    return null;
                  }
                },
              ),
              TitleYesRadio(
                  title: 'Whether details documented in TAEI Case sheet',
                  initialValue: controller.burnFormData.value!.burnsOutcome!
                              .documentedTaeiSheet ==
                          null
                      ? null
                      : controller.burnFormData.value!.burnsOutcome!
                                  .documentedTaeiSheet ==
                              true
                          ? "Yes"
                          : "No",
                  onChanged: (value) {
                    controller.burnFormData.value!.burnsOutcome!
                        .documentedTaeiSheet = value == "Yes" ? true : false;
                    controller.burnFormData.refresh();
                  }),
              DateTimeRowPicker(
                dateTitle: "Patient Exit Date",
                timeTitle: "Patient Exit Time",
                apiDate: controller
                    .burnFormData.value!.burnsOutcome!.patientExitDate
                    ?.toString(),
                apiTime: controller.burnFormData.value!.burnsOutcome!
                            .patientExitDate ==
                        null
                    ? null
                    : DateFormat('hh:mm a').format(controller
                        .burnFormData.value!.burnsOutcome!.patientExitDate!),
                onDateTimeChanged: (date) {
                  log(date.toString());
                  controller.burnFormData.value!.burnsOutcome!.patientExitDate =
                      date;
                },
              ),
            ],
          )
      ],
    )*/
        ;
  }

  Widget thirdScreen() {
    return Form(
      key: formKey3,
      child:
          SizedBox() /*Column(
        spacing: 18,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // YesNoDropdown(
          //     title: 'First Aid Given', value: '', onChanged: (value) {}),
          // Space(
          //   height: 20,
          // ),
          // YesNoDropdown(
          //     title: 'Tetanus Prophylaxis Given',
          //     value: '',
          //     onChanged: (value) {}),
          TitleYesRadio(
              title: 'Fluid resuscitation given within One Hour of Inciden',
              initialValue: controller
                          .burnFormData.value!.isFluidResuscitationGiven ==
                      null
                  ? null
                  : controller.burnFormData.value!.isFluidResuscitationGiven ==
                          true
                      ? "Yes"
                      : "No",
              onChanged: (value) {
                controller.burnFormData.value!.isFluidResuscitationGiven =
                    value == "Yes" ? true : false;
                controller.burnFormData.refresh();
              }),

          TitleYesRadio(
            title: 'Patient on Mechanical Ventillation',
            initialValue:
                controller.burnFormData.value!.isMechanicalVentillation == null
                    ? null
                    : controller.burnFormData.value!.isMechanicalVentillation ==
                            true
                        ? "Yes"
                        : "No",
            onChanged: (value) {
              controller.burnFormData.value!.isMechanicalVentillation =
                  value == "Yes" ? true : false;
              controller.burnFormData.refresh();
            },
          ),

          // TitleDropdown<String>(
          //   title: 'Wound Management',
          //   items: woundOptions,
          //   selectedItem: woundMgmtType,
          //   hint: 'Select wound management type',
          //   onChanged: (val) {
          //     setState(() {
          //       woundMgmtType = val;
          //     });
          //   },
          // ),
          TitleDropdown(
              title: 'Wound Management -Conservative',
              items: controller.lookupList.value?.conservative
                      ?.map((e) => e.name)
                      .toList() ??
                  [],
              selectedItem: getName(
                  controller.lookupList.value!.conservative!,
                  controller.burnFormData.value!.burnsValues!.conservative ??
                      0),
              hint: 'Select wound management type',
              onChanged: (value) {
                controller.burnFormData.value!.burnsValues!.conservative =
                    getId(controller.lookupList.value!.conservative!, value);
                controller.burnFormData.refresh();
              }),

          // if(woundMgmtType == 'Hyperbaric Oxygen Therapy') ...[
          //   YesNoDropdown(
          //     title: 'Hyperbaric Oxygen Given',
          //     value: hyperbaricGiven,
          //     onChanged: (val) {
          //       setState(() {
          //         hyperbaricGiven = val;
          //       });
          //     },
          //   ),
          //   Space(
          //     height: 20,
          //   ),
          // ],

          // Conditional Fields
          if (controller.burnFormData.value!.burnsValues!.conservative == 3)
            TitleTextFormField(
              title: 'Other Dressings',
              controller: TextEditingController(
                  text: controller
                      .burnFormData.value!.burnsValues!.othConservative),
              keyboardType: TextInputType.name,
              hintText: ' Enter Other Dressings',
              onChanged: (v) {
                controller.burnFormData.value!.burnsValues!.othConservative = v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Dressings';
                } else {
                  return null;
                }
              },
            ),

          TitleDropdown(
              title: 'Surgery - Emergency',
              hint: 'Select Surgical Procedures',
              items: controller.lookupList.value?.surgeryEmergency
                      ?.map((e) => e.name)
                      .toList() ??
                  [],
              selectedItem: getName(
                  controller.lookupList.value!.surgeryEmergency!,
                  controller
                          .burnFormData.value!.burnsValues!.surgeryEmergency ??
                      0),
              onChanged: (value) {
                controller.burnFormData.value!.burnsValues!.surgeryEmergency =
                    getId(
                        controller.lookupList.value!.surgeryEmergency!, value);
                controller.burnFormData.refresh();
              }),

          if (controller.burnFormData.value!.burnsValues!.surgeryEmergency !=
              null)
            DateTimeRowPicker(
              dateTitle: "Surgery Date",
              timeTitle: "Surgery Time",
              apiDate: controller
                  .burnFormData.value!.burnsValues!.surgeryPerformedDate
                  ?.toString(),
              apiTime: controller.burnFormData.value!.burnsValues!
                          .surgeryPerformedDate ==
                      null
                  ? null
                  : DateFormat('hh:mm a').format(controller
                      .burnFormData.value!.burnsValues!.surgeryPerformedDate!),
              onDateTimeChanged: (date) {
                log(date.toString());
                controller.burnFormData.value!.burnsValues!
                    .surgeryPerformedDate = date;
              },
            ),

          // if (woundMgmtType == 'Hyperbaric Oxygen Therapy') ...[
          //   YesNoDropdown(
          //     title: 'Hyperbaric Oxygen Given',
          //     value: hyperbaricGiven,
          //     onChanged: (val) {
          //       setState(() {
          //         hyperbaricGiven = val;
          //       });
          //     },
          //   ),
          //   const SizedBox(height: 8),
          //   if (hyperbaricGiven == "Yes")
          //     TextFormField(
          //       controller: sessionController,
          //       keyboardType: TextInputType.number,
          //       decoration: const InputDecoration(
          //         labelText: 'No. of sessions',
          //         border: OutlineInputBorder(),
          //       ),
          //     ),
          // ],

          // if (woundMgmtType == 'Surgery - Emergency') ...[
          //   const Text('Select Emergency Procedures'),
          //   const SizedBox(height: 8),
          //   Wrap(
          //     spacing: 6,
          //     children: emergencyOptions.map((item) {
          //       return FilterChip(
          //         label: Text(
          //           item,
          //           style: const TextStyle(fontWeight: FontWeight.bold),
          //         ),
          //         selected: selectedEmergency.contains(item),
          //         onSelected: (val) {
          //           setState(() {
          //             val
          //                 ? selectedEmergency.add(item)
          //                 : selectedEmergency.remove(item);
          //           });
          //         },
          //       );
          //     }).toList(),
          //   ),
          // ],

          // if (woundMgmtType == 'Surgery - Elective') ...[
          //   const Text('Select Elective Procedures'),
          //   const SizedBox(height: 8),
          //   Wrap(
          //     spacing: 6,
          //     children: electiveOptions.map((item) {
          //       return FilterChip(
          //         label: Text(item),
          //         selected: selectedElective.contains(item),
          //         onSelected: (val) {
          //           setState(() {
          //             val
          //                 ? selectedElective.add(item)
          //                 : selectedElective.remove(item);
          //           });
          //         },
          //       );
          //     }).toList(),
          //   ),
          // ],

          // CompactCheckboxGroup(
          //   title: 'Surgery',
          //   options: ['Surgery - Emergency', 'Surgery - Elective'],
          //   onChanged: (value, val1) async {
          //     setState(() {
          //       if (value.isNotEmpty) {
          //         surgical = value.last;
          //       } else {
          //         surgical = '';
          //       }
          //       debugPrint("Data: $surgical");
          //     });
          //   },
          // ),
          // Space(height: 20),
          //
          // surgical == 'Surgery - Emergency' || surgical == 'Surgery - Elective'
          //     ? Column(
          //         children: [
          //           TitleDropdown(
          //               items: ["Fasciotomy", "Escharotomy", "Amputation"],
          //               onChanged: (val) {},
          //               title: 'Surgical Procedures',
          //               hint: 'Select Surgical Procedures'),
          //           Space(height: 20),
          //         ],
          //       )
          //     : Container(),

          // TitleYesRadio(
          //     title: 'Surgery',
          //     firstValue: 'Surgery - Emergency',
          //     secondValue: 'Surgery - Elective',
          //     onChanged: (value) {}),

          NewCheckboxList(
              title: 'Supportive Measures',
              options: controller.lookupList.value?.supportiveMeasures ?? [],
              initialSelectedIndexes: controller
                      .burnFormData.value!.burnsValues!.supportiveMeasures ??
                  [],
              onChanged: (value) {
                controller.burnFormData.value!.burnsValues!.supportiveMeasures =
                    value;
                controller.burnFormData.refresh();
              }),

          NewCheckboxList(
              title: 'Complications During Hospital Stay',
              options: controller.lookupList.value?.stayComplications ?? [],
              initialSelectedIndexes: controller.burnFormData.value!
                      .burnsValues!.complicationsHospitalStay ??
                  [],
              onChanged: (value) {
                controller.burnFormData.value!.burnsValues!
                    .complicationsHospitalStay = value;
                controller.burnFormData.refresh();
              }),

          NewCheckboxList(
              title: 'Multidisciplinary Support',
              options:
                  controller.lookupList.value?.multidisciplinarySupport ?? [],
              initialSelectedIndexes: controller.burnFormData.value!
                      .burnsValues!.multidisciplinarySupport ??
                  [],
              onChanged: (value) {
                controller.burnFormData.value!.burnsValues!
                    .multidisciplinarySupport = value;
                controller.burnFormData.refresh();
              }),

          if (controller.burnFormData.value!.burnsValues!
                      .multidisciplinarySupport !=
                  null &&
              controller
                  .burnFormData.value!.burnsValues!.multidisciplinarySupport!
                  .contains(19))
            TitleTextFormField(
              keyboardType: TextInputType.number,
              title: 'Quantity',
            ),

          Space(
            height: 20,
          ),
          // TitleDatePickerTextForm(
          //   today: true,
          //   title: 'Follow Up Date',
          //   controller:
          //       TextEditingController(text: ""),
          //   initialValue: normalizeDate(''),
          //   onDateSelected: (v) {},
          // ),
          // Space(
          //   height: 20,
          // ),
        ],
      )*/
      ,
    );
  }

  Widget secondScreen() {
    return Obx(
      () => Form(
        key: formKey2,
        child: SizedBox(),
        /*Column(spacing: 20, children: [
          TitleDropdown(
              title: 'Type Of Burn',
              hint: 'Select Type Of Burn',
              items: controller.lookupList.value?.typeOfBurn
                      ?.map((e) => e.name)
                      .toList() ??
                  [],
              selectedItem: getName(controller.lookupList.value!.typeOfBurn!,
                  controller.burnFormData.value!.typeOfBurn ?? 0),
              onChanged: (value) {
                controller.burnFormData.value!.typeOfBurn =
                    getId(controller.lookupList.value!.typeOfBurn!, value);
                controller.burnFormData.refresh();
              }),
          //// Add others field
          if (controller.burnFormData.value!.typeOfBurn != null &&
              controller.burnFormData.value!.typeOfBurn == 1)
            TitleYesRadio(
              title: 'Inhalation',
              initialValue: "",
              onChanged: (value) {
                controller.burnFormData.value!.inhalation =
                    value == "Yes" ? true : false;
                controller.burnFormData.refresh();
              },
            ),
          if (controller.burnFormData.value!.typeOfBurn != null &&
              controller.burnFormData.value!.typeOfBurn == 10)
            TitleTextFormField(
              title: 'Type Of Burn',
              hintText: "Enter Type Of Burn",
              controller: TextEditingController(
                  text: controller.burnFormData.value!.othTypeOfBurn),
              onChanged: (v) {
                controller.burnFormData.value!.othTypeOfBurn = v;
                controller.burnFormData.refresh();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Type Of Burn';
                } else {
                  return null;
                }
              },
            ),
          TitleDropdown(
              title: 'Mode Of Injury',
              hint: "Select Mode of Injury",
              items: controller.lookupList.value?.modeOfInjury
                      ?.map((e) => e.name)
                      .toList() ??
                  [],
              selectedItem: getName(controller.lookupList.value!.modeOfInjury!,
                  controller.burnFormData.value!.modeOfInjury ?? 0),
              onChanged: (value) {
                controller.burnFormData.value!.modeOfInjury =
                    getId(controller.lookupList.value!.modeOfInjury!, value);
                controller.burnFormData.refresh();
              }),

          InjuryDropdownList(
            title: "TBSA",
            listData: [
              TitleDropdownItem(
                title: "Head",

                /// max 19
                options: [
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                  8,
                  9,
                  10,
                  11,
                  12,
                  13,
                  14,
                  15,
                  16,
                  17,
                  18,
                  19
                ],
                selectedValue: controller.burnFormData.value?.tbsa?.head,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.head = val;
                  controller.calculateTbsaTotal();
                  // controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Neck",
                options: [
                  1,
                  2,
                ],
                selectedValue: controller.burnFormData.value?.tbsa?.neck,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.neck = val;
                  //controller.burnFormData.refresh();
                  controller.calculateTbsaTotal();
                  print(controller.burnFormData.value?.tbsa?.neck);
                  print(controller.burnFormData.value?.tbsa?.head);
                },
              ),
              ////var tbsa = {
              //     "head": 19,
              //     "neck": 2,
              //     "anterior_trunk": 13,
              //     "posterior_trunk": 13,
              //     "right_gluteal": 2.5,
              //     "left_gluteal": 2.5,
              //     "genital": 1,
              //     "right_arm": 4,
              //     "left_arm": 4,
              //     "right_forearm": 3,
              //     "left_forearm": 3,
              //     "right_hand": 2.5,
              //     "left_hand": 2.5,
              //     "right_thigh": 9.5,
              //     "left_thigh": 9.5,
              //     "right_leg": 7,
              //     "left_leg": 7,
              //     "right_foot": 3.5,
              //     "left_foot": 3.5,
              //   };
              // no max
              TitleDropdownItem(
                title: "Anterior Trunk",
                options: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
                selectedValue:
                    controller.burnFormData.value?.tbsa?.anteriorTrunk,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.anteriorTrunk = val;
                  controller.calculateTbsaTotal();
                  // controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Posterior Trunk",
                options: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
                selectedValue:
                    controller.burnFormData.value?.tbsa?.posteriorTrunk,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.posteriorTrunk = val;
                  controller.calculateTbsaTotal();
                  //  controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Right Gluteal",
                options: [1, 1.5, 2, 2.5],
                selectedValue:
                    controller.burnFormData.value?.tbsa?.rightGluteal,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.rightGluteal = val;
                  controller.calculateTbsaTotal();
                  //controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Left Gluteal",
                options: [1, 1.5, 2, 2.5],
                selectedValue: controller.burnFormData.value?.tbsa?.leftGluteal,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.leftGluteal = val;
                  controller.calculateTbsaTotal();
                  //controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Genital",
                options: [1],
                selectedValue: controller.burnFormData.value?.tbsa?.genital,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.genital = val;
                  controller.calculateTbsaTotal();
                  // controller.burnFormData.refresh();
                },
              ),
              // "right_arm": 4,
              //     "left_arm": 4,
              //     "right_forearm": 3,
              //     "left_forearm": 3,
              //     "right_hand": 2.5,
              //     "left_hand": 2.5,
              //     "right_thigh": 9.5,
              //     "left_thigh": 9.5,
              //     "right_leg": 7,
              //     "left_leg": 7,
              //     "right_foot": 3.5,
              //     "left_foot": 3.5,
              TitleDropdownItem(
                title: "Right Arm",
                options: [
                  1,
                  2,
                  3,
                  4,
                ],
                selectedValue: controller.burnFormData.value?.tbsa?.rightArm,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.rightArm = val;
                  controller.calculateTbsaTotal();
                  //controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Left Arm",
                options: [
                  1,
                  2,
                  3,
                  4,
                ],
                selectedValue: controller.burnFormData.value?.tbsa?.leftArm,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.leftArm = val;
                  controller.calculateTbsaTotal();
                  // controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Right Forearm",
                options: [
                  1,
                  2,
                  3,
                ],
                selectedValue:
                    controller.burnFormData.value?.tbsa?.rightForearm,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.rightForearm = val;
                  controller.calculateTbsaTotal();
                  //controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Left Forearm",
                options: [
                  1,
                  2,
                  3,
                ],
                selectedValue: controller.burnFormData.value?.tbsa?.leftForearm,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.leftForearm = val;
                  controller.calculateTbsaTotal();
                  // controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Right Hand",
                options: [
                  1,
                  1.5,
                  2,
                  2.5,
                ],
                selectedValue: controller.burnFormData.value?.tbsa?.rightHand,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.rightHand = val;
                  controller.calculateTbsaTotal();
                  //controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Left Hand",
                options: [
                  1,
                  1.5,
                  2,
                  2.5,
                ],
                selectedValue: controller.burnFormData.value?.tbsa?.leftHand,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.leftHand = val;
                  controller.calculateTbsaTotal();
                  // controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Right Thigh",
                options: [
                  1,
                  1.5,
                  2,
                  2.5,
                  3,
                  3.5,
                  4,
                  4.5,
                  5,
                  5.5,
                  6,
                  6.5,
                  7,
                  7.5,
                  8,
                  8.5,
                  9,
                  9.5,
                ],
                selectedValue: controller.burnFormData.value?.tbsa?.rightThigh,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.rightThigh = val;
                  controller.calculateTbsaTotal();
                  //controller.burnFormData.refresh();
                },
              ),

              TitleDropdownItem(
                title: "Left Thigh",
                options: [
                  1,
                  1.5,
                  2,
                  2.5,
                  3,
                  3.5,
                  4,
                  4.5,
                  5,
                  5.5,
                  6,
                  6.5,
                  7,
                  7.5,
                  8,
                  8.5,
                  9,
                  9.5,
                ],
                selectedValue: controller.burnFormData.value?.tbsa?.leftThigh,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.leftThigh = val;
                  controller.calculateTbsaTotal();
                  // controller.burnFormData.refresh();
                },
              ),

              TitleDropdownItem(
                title: "Right Leg",
                options: [1, 2, 3, 4, 5, 6, 7],
                selectedValue: controller.burnFormData.value?.tbsa?.rightLeg,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.rightLeg = val;
                  controller.calculateTbsaTotal();
                  //controller.burnFormData.refresh();
                },
              ),

              TitleDropdownItem(
                title: "Left Leg",
                options: [1, 2, 3, 4, 5, 6, 7],
                selectedValue: controller.burnFormData.value?.tbsa?.leftLeg,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.leftLeg = val;
                  controller.calculateTbsaTotal();
                  //controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Right Foot",
                options: [1, 1.5, 2, 2.5, 3, 3.5],
                selectedValue: controller.burnFormData.value?.tbsa?.rightFoot,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.rightFoot = val;
                  controller.calculateTbsaTotal();
                  //  controller.burnFormData.refresh();
                },
              ),
              TitleDropdownItem(
                title: "Left Foot",
                options: [1, 1.5, 2, 2.5, 3, 3.5],
                selectedValue: controller.burnFormData.value?.tbsa?.leftFoot,
                onChanged: (val) {
                  controller.burnFormData.value?.tbsa?.leftFoot = val;
                  controller.calculateTbsaTotal();
                  // controller.burnFormData.refresh();
                },
              ),
            ],
          ),
          TitleTextFormField(
              title: 'Total Percentage Of TBSA',
              controller: TextEditingController(
                text: "${controller.burnFormData.value!.tbsaTotalPer} %" ?? "0",
              )),

          // TitleDropdown(
          //     title: 'Place Of Incident',
          //     items: [
          //       "Home",
          //       "Work Place",
          //       "Religious",
          //       "Other - Specify",
          //     ],
          //     onChanged: (value) {}),
          //
          // DateTimeRowPicker(dateTitle: 'Date', timeTitle: 'Time'),

          TitleDropdown(
              title: 'Degree Of Burn',
              hint: 'Select Degree Of Burn',
              items: controller.lookupList.value?.degreeOfBurn
                      ?.map((e) => e.name)
                      .toList() ??
                  [],
              selectedItem: getName(controller.lookupList.value!.degreeOfBurn!,
                  controller.burnFormData.value!.degreeOfBurn ?? 0),
              onChanged: (value) {
                controller.burnFormData.value!.degreeOfBurn =
                    getId(controller.lookupList.value!.degreeOfBurn!, value);
                controller.burnFormData.refresh();
              }),

          TitleTextFormField(
            hintText: 'Enter Associated Injury',
            title: 'Associated Injury',
            controller: TextEditingController(
                text: controller.burnFormData.value!.associatedInjuries),
            onChanged: (v) {
              controller.burnFormData.value!.associatedInjuries = v;
              controller.burnFormData.refresh();
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Type Of Burn';
              } else {
                return null;
              }
            },
          ),
          // CompactCheckboxGroup(
          //     title: 'Co-Morbidities',
          //     options: [
          //       "DM",
          //       "HTN",
          //       "BA",
          //       "PTB",
          //       "EPILEPSY",
          //       "CAD",
          //       "CKD",
          //       "Others - Specify",
          //     ],
          //     onChanged: (selectedList, otherText) {}),
          NewCheckboxList(
              title: "Co-Morbidities",
              options: controller.lookupList.value?.coMorbidities ?? [],
              initialSelectedIndexes:
                  controller.burnFormData.value!.coMorbidities ?? [],
              onChanged: (v) {
                controller.burnFormData.value!.coMorbidities = v;
                controller.burnFormData.refresh();
              }),
          if (controller.burnFormData.value!.coMorbidities != null &&
              controller.burnFormData.value!.coMorbidities!.contains(8))
            // TODO: need to add APi data
            TitleTextFormField(
              title: "Other Specify",
              controller: TextEditingController(),
              keyboardType: TextInputType.name,
              hintText: 'Enter Specific Complaint',
              onChanged: (v) {
                // controller.createTriageModel.value!.triageDtls!
                //     .othPcMedicalEmergency = v;
              },
              validator: (value) {
                if (value == null) {
                  return 'Please Enter Specific Complaint';
                } else {
                  return null;
                }
              },
            ),

          TitleYesRadio(
              title: 'Is the Patient Pregnant',
              initialValue: controller.burnFormData.value!.isPregnant == null
                  ? null
                  : controller.burnFormData.value!.isPregnant == false
                      ? "No"
                      : "Yes",
              onChanged: (value) {
                controller.burnFormData.value!.isPregnant =
                    value == "Yes" ? true : false;
                controller.burnFormData.refresh();
              })
        ]*/
      ),
    );
  }

/*Column firstScreen() {
    return Column(
      children: [
        DateTimeRowPicker(
          dateTitle: "Admission Date",
          timeTitle: "Admission Time",
          apiDate: controller.burnFormData.value!.admissionDate?.toString(),
          apiTime: controller.burnFormData.value!.admissionDate == null
              ? null
              : DateFormat('hh:mm a')
                  .format(controller.burnFormData.value!.admissionDate!),
          onDateTimeChanged: (date) {
            log(date.toString());
            controller.burnFormData.value!.admissionDate = date;
          },
        ),
        Space(height: 20),
        // DateTimeRowPicker(
        //     dateTitle: 'Date of Admission ',
        //     timeTitle: 'Time'),
        // Space(height: 20),
        // TitleDropdown(
        //     hint: 'Visit Type',
        //     title: 'Visit Type (OP / IP)',
        //     items: [
        //       'OP',
        //       'IP',
        //     ],
        //     onChanged: (value) {
        //       controller.visitType.value = value!;
        //       controller.burnFormData.value.burnsValues.vis
        //     }),
        // controller.visitType == 'IP'
        //     ? TitleTextFormField(
        //         title: 'Average number of day Occupied',
        //       )
        //     : Container(),
        Space(height: 20),
        */

/*  TitleDropdown(
                                title: 'Department',
                                items: departments,
                                onChanged: (value) {}),
                            Space(
                              height: 20,
                            ),
                            TitleDropdown(
                              title:
                                  'Reserred from Another Facility - Government',
                              items: referredOptions,
                              onChanged: (value) {},
                            ),
                            Space(
                              height: 20,
                            ),
                            TitleDropdown(
                              title: 'MCH Name',
                              items: mchNames,
                              onChanged: (value) {},
                            ),
                            Space(
                              height: 20,
                            ),
                            TitleDropdown(
                              title: 'DHQH Name',
                              items: dhqhNames,
                              onChanged: (value) {},
                            ),
                            Space(
                              height: 20,
                            ),
                            TitleDropdown(
                              title: 'GH Name',
                              items: ghList,
                              onChanged: (value) {},
                            ),
                            Space(
                              height: 20,
                            ),
                            TitleDropdown(
                                title: 'PHC',
                                items: phcList,
                                onChanged: (value) {}),
                            TitleTextFormField(
                              title: 'Private Hospital Name',
                            ),
                            Space(
                              height: 20,
                            ),
                            TitleDropdown(
                                title: 'Mode of Arrival',
                                items: [
                                  '108 Ambulance',
                                  'Private Ambulance',
                                  'Auto',
                                  'Car',
                                  'Other-Specify'
                                ],
                                onChanged: (value) {}),
                            Space(
                              height: 20,
                            ),*/ /*
      ],
    );
  }*/*/
