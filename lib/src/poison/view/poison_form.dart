import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/burn/controller/burn_controller.dart';
import 'package:taei_gov/src/hospital/controller/hospital_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_button.dart';
import 'package:taei_gov/utils/common/common_check_box_list.dart';
import 'package:taei_gov/utils/common/common_drop_down.dart';
import 'package:taei_gov/utils/common/date_picker.dart';
import 'package:taei_gov/utils/common/date_time_common.dart';
import 'package:taei_gov/utils/common/new_common_date_time_picker.dart';
import 'package:taei_gov/utils/common/save_submit_dialog.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/step_indicator.dart';
import 'package:taei_gov/utils/common/title_textfield.dart';
import 'package:taei_gov/utils/common/yes_or_no_drop_down.dart';
import 'package:taei_gov/utils/common/yes_or_no_radio_button.dart';

import '../../../utils/common/appbar.dart';
import '../../../utils/common/list_data_radio_button.dart';
import '../../prem/controller/prem_controller.dart';
import '../controller/poison_controller.dart';

class PoisonForm extends StatefulWidget {
  final String? poisonId;
  final String? triageId;
  final bool isUpdate;
  final String? dateTimeOfTriage;
  final String? dateAndTimeOfIncident;
  final bool? prem;
  final String? id;
  final int? refFormId;
  final String? refId;

  const PoisonForm({
    super.key,
    this.poisonId,
    this.triageId,
    this.isUpdate = false,
    this.dateTimeOfTriage,
    this.dateAndTimeOfIncident,
    this.prem,
    this.id,
    this.refFormId,
    this.refId,
  });

  @override
  State<PoisonForm> createState() => _PoisonFormState();
}

class _PoisonFormState extends State<PoisonForm> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  PoisonController poisonController = Get.put(PoisonController());
  HospitalController hospitalController = Get.put(HospitalController());
  final PremController prem = Get.put(PremController());

  bool insuranceCard = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      poisonController.isLoading(true);

      // Fetch lookup and hospital list
      await poisonController.getPoisonLookup();
      await hospitalController.getHospitalListData();
      // If it's from Prem
      if (widget.prem == true) {
        await poisonController.getPoisonByTriageId(
          id: widget.triageId.toString(),
        );
      }

      // If updating existing record
      if (widget.isUpdate) {
        await poisonController
            .getByPoisonById(
          id: widget.poisonId.toString(),
        )
            .then((_) {
          final poison = poisonController.poisoning.value.poison;

          // Calculate duration of hospital stay
          poison?.durationOfHospitalStay = DateTime.now()
              .difference(
                poison.dateTimeOfEntry != null
                    ? DateTime.tryParse(poison.dateTimeOfEntry!) ??
                        DateTime.now()
                    : DateTime.now(),
              )
              .inDays;

          // Calculate time elapsed between exposure and symptoms
          poison?.timeElapsedExposureSymptom =
              calculatePositiveDays(widget.dateAndTimeOfIncident).toString();
        });
      }

      poisonController.isLoading(false);
    });
  }

  // bool validateBurnsForm({required bool outcome}) {
  //   final burns = poisonController.poisoningDetails.value;
  //
  //   // Step 0: Visit & Admission Details Validation
  //   if (controller.currentIndex.value == 0) {
  //     if (burns.burns?.admitted == null) {
  //       showValidationError("Please specify if patient was admitted");
  //       return false;
  //     }
  //   }
  // }

  bool validatePoisoningForm({required bool outcome}) {
    final poisoning = poisonController.poisoning.value;
    final modelPoison = poisoning.poison;
    final modelOutcome = poisoning.poisonsOutcome;

    // Step 0: Admission Details Validation
    if (poisonController.currentIndex.value == 0) {
      if (modelPoison?.patientAdmitted == null) {
        showValidationError("Please specify if patient was admitted");
        return false;
      }

      // If admitted is true, validate admission details
      if (modelPoison?.patientAdmitted == true) {
        if (modelPoison?.dateOfAdmit == null) {
          showValidationError("Date of Admission is required");
          return false;
        }

        if (modelPoison?.nameOfDept == null ||
            modelPoison!.nameOfDept!.isEmpty) {
          showValidationError("Name of The Admitting Department is required");
          return false;
        }
      }
    }
    // Step 1: Poisoning Details Validation
    else if (poisonController.currentIndex.value == 1) {
      if (modelPoison?.typeOfPoisoning == null) {
        showValidationError("Type of poisoning is required");
        return false;
      }

      if (modelPoison?.routeOfExposure == null) {
        showValidationError("Route of exposure is required");
        return false;
      }

      if (modelPoison?.substanceInvolved == null) {
        showValidationError("Substance Involved is required");
        return false;
      }

      // Note: Substance Subcategory is optional based on your UI
      // Brand or product name is optional based on your UI
      // Quantity is optional based on your UI
      // Source of substance is optional based on your UI
    }
    // Step 2: Clinical Presentation Validation
    else if (poisonController.currentIndex.value == 2) {
      if (modelPoison?.symptomsAtPresentation == null ||
          modelPoison!.symptomsAtPresentation!.isEmpty) {
        showValidationError(
            "Please select at least one symptom at presentation");
        return false;
      }

      // Date of Onset Of Symptoms validation
      // if (modelPoison?.timeOfOnsetOfSymptoms == null) {
      //   showValidationError("Date of Onset Of Symptoms is required");
      //   return false;
      // }

      // Time elapsed Between Exposure And symptoms onset validation
      // if (modelPoison?.timeElapsedExposureSymptom == null ||
      //     modelPoison!.timeElapsedExposureSymptom!.isEmpty) {
      //   showValidationError(
      //       "Time elapsed Between Exposure And symptoms onset is required");
      //   return false;
      // }

      // Investigations Performed validation
      // if (modelPoison?.investigationsPerformed == null ||
      //     modelPoison!.investigationsPerformed!.isEmpty) {
      //   showValidationError("Investigation Performed is required");
      //   return false;
      // }

      // Severity of poisoning validation
      // if (modelPoison?.severityOfPoisoning == null) {
      //   showValidationError("Severity of poisoning is required");
      //   return false;
      // }
    }
    // Step 3: Treatment & Management Validation
    else if (poisonController.currentIndex.value == 3) {
      if (modelPoison!.decontamination!.length <= 0) {
        showValidationError(
            "Please select at least one decontamination method");
        return false;
      }

      // Antidote administered Name validation
      if (modelPoison?.antidoteAdministeredName == null ||
          modelPoison!.antidoteAdministeredName!.isEmpty) {
        showValidationError("Antidote administered Name is required");
        return false;
      }

      // Note: Dosage of antidote is optional based on your UI

      // Time Of First Administration validation
      // if (modelPoison?.antidoteAdministeredTiming == null) {
      //   showValidationError("Time Of First Administration is required");
      //   return false;
      // }

      // Supportive care provided validation
      if (modelPoison?.supportiveCareProvided == null ||
          modelPoison!.supportiveCareProvided!.isEmpty) {
        showValidationError(
            "Please select at least one supportive care provided");
        return false;
      }

      // If supportive care includes Hemodialysis (3) or Hemoperfusion (4), validate number of cycles
      if ((modelPoison.supportiveCareProvided?.contains(3) ?? false) ||
          (modelPoison.supportiveCareProvided?.contains(4) ?? false)) {
        if (modelPoison.noOfCyclesPerformed == null ||
            modelPoison.noOfCyclesPerformed! <= 0) {
          showValidationError("Number of Cycles Performed is required");
          return false;
        }
      }

      if (modelPoison?.counsellingProvided == null) {
        showValidationError(
            "Counselling provided before discharge is required");
        return false;
      }
    }
    // Step 4: Outcome Validation (only for non-prem mode)
    else if (poisonController.currentIndex.value == 4) {
      if (outcome == true) {
        if (modelOutcome?.outcome == null) {
          showValidationError("Outcome is required");
          return false;
        }

        // switch (modelOutcome?.outcome) {
        //   case 1: // Discharged
        //   case 2: // Discharge at request
        //   case 3: // DAMA
        //     if (modelOutcome?.dischargeDate == null) {
        //       showValidationError("Date & Time of Discharge is required");
        //       return false;
        //     }
        //
        //     // Duration of hospital stay validation
        //     if (modelPoison?.durationOfHospitalStay == null ||
        //         modelPoison!.durationOfHospitalStay! <= 0) {
        //       showValidationError("Duration of hospital stay is required");
        //       return false;
        //     }
        //     break;
        //
        //   case 4: // Absconded
        //     if (modelOutcome?.abscondedDate == null) {
        //       showValidationError("Date & Time of Absconded is required");
        //       return false;
        //     }
        //     break;
        //
        //   case 5: // Death
        //     if (modelOutcome?.deathDate == null) {
        //       showValidationError("Date & Time of Death is required");
        //       return false;
        //     }
        //     break;
        //
        //   case 7: // Patient Exit
        //     if (modelOutcome?.patientExitDate == null) {
        //       showValidationError("Date & Time of Patient Exit is required");
        //       return false;
        //     }
        //     break;
        //
        //   case 6: // Referred to other hospital
        //     // Hospital Type validation
        //     if (modelOutcome?.hospitalType == null) {
        //       showValidationError("Hospital Type is required");
        //       return false;
        //     }
        //
        //     // Destination hospital validation based on hospital type
        //     if (modelOutcome?.hospitalType == 1) {
        //       // TAEI Hospital
        //       if (modelOutcome?.destinationTAEIHospital == null) {
        //         showValidationError("Destination hospital is required");
        //         return false;
        //       }
        //     } else if (modelOutcome?.hospitalType == 2) {
        //       // Non-TAEI Hospital
        //       if (modelOutcome?.destinationHospital == null ||
        //           modelOutcome!.destinationHospital!.isEmpty) {
        //         showValidationError(
        //             "Destination Non TAEI Hospital name is required");
        //         return false;
        //       }
        //     }
        //
        //     // Reason for referral validation
        //     if (modelOutcome?.reasonForReferral == null) {
        //       showValidationError("Reason for referral is required");
        //       return false;
        //     }
        //
        //     // If reason for referral is "Other" (id: 3), validate other specification
        //     if (modelOutcome?.reasonForReferral == 3 &&
        //         (modelOutcome?.othReasonForReferral == null ||
        //             modelOutcome!.othReasonForReferral!.isEmpty)) {
        //       showValidationError("Please specify other reason for referral");
        //       return false;
        //     }
        //
        //     // Condition of patient validation
        //     if (modelOutcome?.conditionOfPatient == null) {
        //       showValidationError("Condition of patient is required");
        //       return false;
        //     }
        //
        //     // Referring Doctor validation
        //     if (modelOutcome?.referringDoctor == null ||
        //         modelOutcome!.referringDoctor!.isEmpty) {
        //       showValidationError("Referring Doctor name is required");
        //       return false;
        //     }
        //
        //     // Documentation in TAEI case sheet validation
        //     if (modelOutcome?.documentedTaeiSheet == null) {
        //       showValidationError(
        //           "Documentation in TAEI Case sheet status is required");
        //       return false;
        //     }
        //
        //     break;
        // }
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
    if (poisonController.poisoning.value.poison?.patientAdmitted == null) {
      poisonController.poisoning.value.poison?.patientAdmitted = true;
    }
    return WillPopScope(
      onWillPop: () async {
        if (poisonController.currentIndex.value > 0) {
          poisonController.currentIndex.value -= 1;
          return false;
        }
        return true;
      },
      child: Scaffold(
          backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
          appBar: CommonAppBar(
            id: widget.triageId,
            title: 'Poisoning',
          ),
          body: Obx(() {
            if (widget.prem == true) {
              poisonController.poisoning.value.poison?.refFormId =
                  widget.refFormId == null ? 1 : widget.refFormId;
              poisonController.poisoning.value.poison?.refId =
                  widget.refId == null
                      ? prem.refId
                      : int.parse(widget.refId.toString());
              poisonController.poisoning.value.poison?.triageId =
                  int.parse(widget.triageId.toString());
            }

            if (poisonController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
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
                          : Colors.transparent, // border color
                      width: 0.3 // border thickness
                      ),
                ),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    overscroll: false, // removes stretch
                    scrollbars: true, // hides scrollbars
                  ),
                  child: Padding(
                    padding: context.isDesktop
                        ? EdgeInsets.only(
                            left: 30, right: 30, top: 8, bottom: 8)
                        : EdgeInsets.all(10),
                    child: ListView(
                      children: [
                        Center(
                            child: Text(
                          poisonController.currentIndex.value == 0
                              ? 'Admission Details'
                              : poisonController.currentIndex.value == 1
                                  ? 'Poisoning Details'
                                  : poisonController.currentIndex.value == 2
                                      ? 'Clinical Presentation'
                                      : poisonController.currentIndex.value == 3
                                          ? 'Treatment & Management'
                                          : 'Outcome',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                        Space(height: 20),
                        FancyStepIndicator(
                          currentIndex: poisonController.currentIndex,
                          stepCount: widget.prem == true ? 4 : 5,
                        ),
                        Space(height: 26),
                        poisonController.currentIndex.value == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  NewTitleYesRadio(
                                    isRequired: true,
                                    title: 'Patient admitted',
                                    initialValue: poisonController.poisoning
                                        .value.poison?.patientAdmitted,
                                    onChanged: (value) {
                                      poisonController.poisoning.value.poison
                                          ?.patientAdmitted = value;
                                      poisonController.poisoning.refresh();
                                    },
                                  ),
                                  Space(
                                    height: 16,
                                  ),
                                  poisonController.poisoning.value.poison
                                              ?.patientAdmitted ==
                                          true
                                      ? Column(
                                          children: [
                                            CommonDateTimeWidget(
                                              isRequired: true,
                                              title: 'Date of Admission',
                                              dateTime: poisonController
                                                  .poisoning
                                                  .value
                                                  .poison
                                                  ?.dateOfAdmit
                                                  .toString(),
                                              onChanged: (value) {
                                                poisonController
                                                    .poisoning
                                                    .value
                                                    .poison
                                                    ?.dateOfAdmit = value;
                                                // traumaController.trauma.value.traumaOutcome?.stayedDuration = value
                                                //         .difference(DateTime.now())
                                                //         .inDays
                                                //         .toString();
                                                poisonController
                                                        .poisoning
                                                        .value
                                                        .poison
                                                        ?.durationOfHospitalStay =
                                                    calculatePositiveDays(
                                                        value);
                                              },
                                            ),
                                            Space(
                                              height: 16,
                                            ),
                                            TitleTextFormField(
                                              isRequired: true,
                                              title:
                                                  'Name of The Admitting Department',
                                              hintText:
                                                  'Enter Name of The Admitting Department',
                                              initialValue: poisonController
                                                  .poisoning
                                                  .value
                                                  .poison
                                                  ?.nameOfDept,
                                              onChanged: (value) {
                                                poisonController.poisoning.value
                                                    .poison?.nameOfDept = value;
                                              },
                                            )
                                          ],
                                        )
                                      : Container(),
                                  Space(
                                    height: 20,
                                  )
                                ],
                              )
                            : poisonController.currentIndex.value == 1
                                ? Column(
                                    children: [
                                      NewTitleDropdown(
                                          isRequired: true,
                                          title: 'Type of poisoning',
                                          hint: 'Choose Poison Type',
                                          selectedId: poisonController.poisoning
                                              .value.poison?.typeOfPoisoning,
                                          items: poisonController
                                                  .poisoningLookup
                                                  .value
                                                  .typeOfPoisoning
                                                  ?.map((e) => {
                                                        "id": e.id ?? "",
                                                        "name": e.name ?? "",
                                                      })
                                                  .toList() ??
                                              [],
                                          onChanged: (value) {
                                            poisonController
                                                .poisoning
                                                .value
                                                .poison
                                                ?.typeOfPoisoning = value;
                                          }),
                                      Space(
                                        height: 20,
                                      ),
                                      NewTitleDropdown(
                                          isRequired: true,
                                          title: 'Route of exposure',
                                          hint: 'Choose Route',
                                          selectedId: poisonController.poisoning
                                              .value.poison?.routeOfExposure,
                                          items: poisonController
                                                  .poisoningLookup
                                                  .value
                                                  .routeOfExposure
                                                  ?.map((e) => {
                                                        "id": e.id ?? "",
                                                        "name": e.name ?? "",
                                                      })
                                                  .toList() ??
                                              [],
                                          onChanged: (value) {
                                            poisonController
                                                .poisoning
                                                .value
                                                .poison
                                                ?.routeOfExposure = value;
                                          }),
                                      Space(
                                        height: 20,
                                      ),
                                      NewTitleDropdown(
                                        isRequired: true,
                                        title: 'Substance Involved ',
                                        hint: 'Choose...',
                                        selectedId: poisonController.poisoning
                                            .value.poison?.substanceInvolved,
                                        items: poisonController.poisoningLookup
                                                .value.substanceInvolved
                                                ?.map((e) => {
                                                      "id": e.id ?? "",
                                                      "name": e.name ?? "",
                                                    })
                                                .toList() ??
                                            [],
                                        onChanged: (value) {
                                          poisonController
                                              .poisoning
                                              .value
                                              .poison
                                              ?.substanceInvolved = value;
                                          poisonController.poisoning.refresh();
                                        },
                                      ),
                                      Space(
                                        height: 20,
                                      ),
                                      Obx(() {
                                        final selectedSubstanceId =
                                            poisonController.poisoning.value
                                                .poison?.substanceInvolved;
                                        final selectedSubCategoryId =
                                            poisonController.poisoning.value
                                                .poison?.substanceInvolvedSub;

                                        if (selectedSubstanceId == null) {
                                          return const SizedBox.shrink();
                                        }

                                        final filteredSubList = poisonController
                                                .poisoningLookup
                                                .value
                                                .substanceInvolvedSub
                                                ?.where((e) =>
                                                    e.substanceInvolvedId ==
                                                    selectedSubstanceId)
                                                .map((e) => {
                                                      "id": e.id,
                                                      "name": e.name,
                                                    })
                                                .toList() ??
                                            [];

                                        final isSelectedSubValid =
                                            filteredSubList.any((item) =>
                                                item["id"].toString() ==
                                                selectedSubCategoryId
                                                    ?.toString());

                                        final effectiveSelectedId =
                                            isSelectedSubValid
                                                ? selectedSubCategoryId
                                                : null;

                                        return NewTitleDropdown(
                                          title:
                                              'Substance Involved SubCategory',
                                          hint: filteredSubList.isEmpty
                                              ? 'No subcategories found'
                                              : 'Choose...',
                                          selectedId: effectiveSelectedId,
                                          items: filteredSubList,
                                          onChanged: (value) {
                                            poisonController
                                                .poisoning
                                                .value
                                                .poison
                                                ?.substanceInvolvedSub = value;
                                            poisonController.update();
                                          },
                                        );
                                      }),
                                      Space(
                                        height: 20,
                                      ),
                                      TitleTextFormField(
                                        hintText: 'Enter Brand or product name',
                                        title: 'Brand or product name',
                                        initialValue: poisonController.poisoning
                                            .value.poison?.brandOrProductName,
                                        onChanged: (value) {
                                          poisonController
                                              .poisoning
                                              .value
                                              .poison
                                              ?.brandOrProductName = value;
                                        },
                                      ),
                                      TitleTextFormField(
                                        //  keyboardType: TextInputType.number,
                                        hintText: 'Enter Quantity',
                                        title: 'Quantity',
                                        keyboardType: TextInputType.number,
                                        initialValue: poisonController
                                            .poisoning.value.poison?.quantity,
                                        onChanged: (value) {
                                          poisonController.poisoning.value
                                              .poison?.quantity = value;
                                        },
                                      ),
                                      NewTitleDropdown(
                                        title: 'Source of substance',
                                        items: poisonController.poisoningLookup
                                                .value.sourceOfSubstance
                                                ?.map((e) => {
                                                      "id": e.id ?? "",
                                                      "name": e.name ?? "",
                                                    })
                                                .toList() ??
                                            [],
                                        selectedId: poisonController.poisoning
                                            .value.poison?.sourceOfSubstance,
                                        onChanged: (value) {
                                          poisonController
                                              .poisoning
                                              .value
                                              .poison
                                              ?.sourceOfSubstance = value;
                                        },
                                      ),
                                    ],
                                  )
                                : poisonController.currentIndex.value == 2
                                    ? Column(
                                        children: [
                                          Space(
                                            height: 20,
                                          ),
                                          NewCheckboxList(
                                              isRequired: true,
                                              title: 'Symptoms at presentation',
                                              initialSelectedIndexes: poisonController
                                                          .poisoning
                                                          .value
                                                          .poison
                                                          ?.symptomsAtPresentation ==
                                                      null
                                                  ? []
                                                  : poisonController
                                                      .poisoning
                                                      .value
                                                      .poison!
                                                      .symptomsAtPresentation!,
                                              options: poisonController
                                                      .poisoningLookup
                                                      .value
                                                      .symptomsPresentation ??
                                                  [],
                                              onChanged: (value) {
                                                poisonController
                                                        .poisoning
                                                        .value
                                                        .poison!
                                                        .symptomsAtPresentation =
                                                    value;
                                              }),
                                          CommonDateTimeWidget(
                                              title:
                                                  'Date of Onset Of Symptoms',
                                              dateTime: poisonController
                                                      .poisoning
                                                      .value
                                                      .poison
                                                      ?.timeOfOnsetOfSymptoms
                                                      ?.toString() ??
                                                  "",
                                              onChanged: (value) {
                                                poisonController
                                                        .poisoning
                                                        .value
                                                        .poison!
                                                        .timeOfOnsetOfSymptoms =
                                                    value;
                                                poisonController
                                                        .poisoning
                                                        .value
                                                        .poison!
                                                        .timeElapsedExposureSymptom =
                                                    calculatePositiveDays(widget
                                                            .dateAndTimeOfIncident)
                                                        .toString();
                                                poisonController.poisoning
                                                    .refresh();
                                              }),
                                          Space(
                                            height: 20,
                                          ),
                                          TitleTextFormField(
                                            title:
                                                'Time elapsed Between Exposure And symptoms onset',
                                            hintText: 'Enter Time',
                                            initialValue: poisonController
                                                .poisoning
                                                .value
                                                .poison!
                                                .timeElapsedExposureSymptom,
                                            onChanged: (value) {
                                              poisonController
                                                      .poisoning
                                                      .value
                                                      .poison!
                                                      .timeElapsedExposureSymptom =
                                                  value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          TitleTextFormField(
                                            title:
                                                'Investigation Performed(Labs, toxicology)',
                                            hintText: 'Enter Investigation ',
                                            initialValue: poisonController
                                                .poisoning
                                                .value
                                                .poison!
                                                .investigationsPerformed,
                                            onChanged: (value) {
                                              poisonController
                                                      .poisoning
                                                      .value
                                                      .poison!
                                                      .investigationsPerformed =
                                                  value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          NewTitleDropdown(
                                              hint: 'Select Severity',
                                              title: 'Severity of poisoning',
                                              selectedId: poisonController
                                                  .poisoning
                                                  .value
                                                  .poison!
                                                  .severityOfPoisoning,
                                              items: poisonController
                                                      .poisoningLookup
                                                      .value
                                                      .severityOfPoisoning
                                                      ?.map((e) => {
                                                            "id": e.id ?? "",
                                                            "name":
                                                                e.name ?? "",
                                                          })
                                                      .toList() ??
                                                  [],
                                              onChanged: (value) {
                                                poisonController
                                                        .poisoning
                                                        .value
                                                        .poison!
                                                        .severityOfPoisoning =
                                                    value;
                                              }),
                                          Space(
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    : poisonController.currentIndex.value == 3
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              NewCheckboxList(
                                                isRequired: true,
                                                title: 'Decontamination',
                                                initialSelectedIndexes:
                                                    poisonController
                                                            .poisoning
                                                            .value
                                                            .poison
                                                            ?.decontamination ??
                                                        [],
                                                options: poisonController
                                                            .poisoningLookup
                                                            .value
                                                            .decontamination ==
                                                        null
                                                    ? []
                                                    : poisonController
                                                        .poisoningLookup
                                                        .value
                                                        .decontamination!,
                                                onChanged: (value) {
                                                  // Update the model with selected values
                                                  poisonController
                                                      .poisoning
                                                      .value
                                                      .poison
                                                      ?.decontamination = value;

                                                  // Refresh the UI to reflect changes
                                                  poisonController.poisoning
                                                      .refresh();
                                                },
                                              ),
                                              Space(
                                                height: 20,
                                              ),
                                              TitleTextFormField(
                                                isRequired: true,
                                                title:
                                                    'Antidote administered Name',
                                                hintText: 'Enter Name',
                                                initialValue: poisonController
                                                    .poisoning
                                                    .value
                                                    .poison
                                                    ?.antidoteAdministeredName,
                                                onChanged: (value) {
                                                  poisonController
                                                          .poisoning
                                                          .value
                                                          .poison
                                                          ?.antidoteAdministeredName =
                                                      value;
                                                },
                                              ),
                                              Space(
                                                height: 20,
                                              ),
                                              TitleTextFormField(
                                                title: 'Dosage of antidote',
                                                hintText: 'Enter Dosage',
                                                initialValue: poisonController
                                                    .poisoning
                                                    .value
                                                    .poison
                                                    ?.antidoteAdministeredDosage,
                                                onChanged: (value) {
                                                  poisonController
                                                          .poisoning
                                                          .value
                                                          .poison
                                                          ?.antidoteAdministeredDosage =
                                                      value;
                                                },
                                              ),
                                              Space(
                                                height: 20,
                                              ),

                                              CommonDateTimeWidget(
                                                title:
                                                    'Time Of First Administration',
                                                dateTime: poisonController
                                                    .poisoning
                                                    .value
                                                    .poison
                                                    ?.antidoteAdministeredTiming
                                                    .toString(),
                                                onChanged: (value) {
                                                  poisonController
                                                          .poisoning
                                                          .value
                                                          .poison
                                                          ?.antidoteAdministeredTiming =
                                                      value;
                                                },
                                              ),
                                              Space(
                                                height: 20,
                                              ),
                                              //// Change the field Check box list

                                              /*  NewTitleDropdown(
                                                  hint: 'Supportive care provided',
                                                  title: 'Supportive care provided',
                                                  selectedId: poisonController
                                                      .poisoning
                                                      .value
                                                      .poison
                                                      ?.supportiveCareProvided,
                                                  items: poisonController
                                                          .poisoningLookup
                                                          .value
                                                          .supportiveCareProvided
                                                          ?.map((e) => {
                                                                "id": e.id ?? "",
                                                                "name":
                                                                    e.name ?? "",
                                                              })
                                                          .toList() ??
                                                      [],
                                                  onChanged: (value) {
                                                    poisonController
                                                            .poisoning
                                                            .value
                                                            .poison
                                                            ?.supportiveCareProvided =
                                                        value;
                                                  }),*/

                                              /// Backend Change
                                              NewCheckboxList(
                                                  isRequired: true,
                                                  title:
                                                      'Supportive care provided',
                                                  options: poisonController
                                                          .poisoningLookup
                                                          .value
                                                          .supportiveCareProvided ??
                                                      [],
                                                  initialSelectedIndexes:
                                                      poisonController
                                                              .poisoning
                                                              .value
                                                              .poison
                                                              ?.supportiveCareProvided ??
                                                          [],
                                                  onChanged: (value) {
                                                    poisonController
                                                            .poisoning
                                                            .value
                                                            .poison
                                                            ?.supportiveCareProvided =
                                                        value;
                                                    poisonController.poisoning
                                                        .refresh();
                                                  }),
                                              if ((poisonController
                                                          .poisoning
                                                          .value
                                                          .poison
                                                          ?.supportiveCareProvided
                                                          ?.contains(3) ??
                                                      false) ||
                                                  (poisonController
                                                          .poisoning
                                                          .value
                                                          .poison
                                                          ?.supportiveCareProvided
                                                          ?.contains(4) ??
                                                      false))
                                                TitleTextFormField(
                                                  isRequired: true,
                                                  title:
                                                      'Number of Cycles Performed',
                                                  hintText:
                                                      'Enter Number of Cycles Performed',
                                                  initialValue: poisonController
                                                      .poisoning
                                                      .value
                                                      .poison
                                                      ?.noOfCyclesPerformed
                                                      .toString(),
                                                  onChanged: (value) {
                                                    poisonController
                                                            .poisoning
                                                            .value
                                                            .poison
                                                            ?.noOfCyclesPerformed =
                                                        int.parse(value);
                                                  },
                                                ),
                                              Space(
                                                height: 20,
                                              ),
                                              /* poisonController
                                                              .poisoning
                                                              .value
                                                              .poison
                                                              ?.supportiveCareProvided ==
                                                          3 ||
                                                      poisonController
                                                              .poisoning
                                                              .value
                                                              .poison
                                                              ?.supportiveCareProvided ==
                                                          4
                                                  ? Column(
                                                      children: [
                                                        TitleTextFormField(
                                                          title:
                                                              'Number of Cycles Performed',
                                                          hintText:
                                                              'Enter Number of Cycles Performed',
                                                          initialValue:
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poison
                                                                  ?.noOfCyclesPerformed
                                                                  .toString(),
                                                          onChanged: (value) {
                                                            poisonController
                                                                    .poisoning
                                                                    .value
                                                                    .poison
                                                                    ?.noOfCyclesPerformed =
                                                                int.parse(value);
                                                          },
                                                        )
                                                      ],
                                                    )
                                                  : Container(),

                                              Space(
                                                height: 20,
                                              ),*/
                                              NewTitleYesRadio(
                                                  isRequired: true,
                                                  title:
                                                      'Counselling provided before discharge',
                                                  initialValue: poisonController
                                                      .poisoning
                                                      .value
                                                      .poison
                                                      ?.counsellingProvided,
                                                  onChanged: (value) {
                                                    poisonController
                                                            .poisoning
                                                            .value
                                                            .poison
                                                            ?.counsellingProvided =
                                                        value;
                                                  }),

                                              Space(
                                                height: 20,
                                              )
                                            ],
                                          )
                                        : widget.prem == true
                                            ? Container()
                                            : Column(
                                                children: [
                                                  // TitleDropdown(
                                                  //     title: 'Outcome',
                                                  //     hint: 'Select Outcome',
                                                  //
                                                  //     ///1. Discharged
                                                  //     // 2. Discharge at request
                                                  //     // 3. DAMA
                                                  //     // 4. Absconded
                                                  //     // 5. Death
                                                  //     // 6. Transferred to other hospital
                                                  //     // 7. Treated as OP
                                                  //     items: [
                                                  //       'Treated as OP',
                                                  //       'Discharged',
                                                  //       'Discharge at request',
                                                  //       'DAMA',
                                                  //       'Absconded',
                                                  //       'Death',
                                                  //       'Transferred to other hospital',
                                                  //     ],
                                                  //     onChanged: (value) {}),
                                                  NewTitleDropdown(
                                                      title: 'Outcome',
                                                      isRequired: true,
                                                      hint: 'Select Outcome',
                                                      items: poisonController
                                                              .poisoningLookup
                                                              .value
                                                              .outcome
                                                              ?.map((e) => {
                                                                    "id":
                                                                        e.id ??
                                                                            "",
                                                                    "name":
                                                                        e.name ??
                                                                            "",
                                                                  })
                                                              .toList() ??
                                                          [],
                                                      selectedId:
                                                          poisonController
                                                              .poisoning
                                                              .value
                                                              .poisonsOutcome
                                                              ?.outcome,
                                                      onChanged: (value) {
                                                        poisonController
                                                            .poisoning
                                                            .value
                                                            .poisonsOutcome
                                                            ?.outcome = value;
                                                        poisonController
                                                            .poisoning
                                                            .refresh();
                                                      }),
                                                  Space(
                                                    height: 20,
                                                  ),
                                                  if (poisonController.poisoning.value.poisonsOutcome?.outcome == 1 ||
                                                      poisonController
                                                              .poisoning
                                                              .value
                                                              .poisonsOutcome
                                                              ?.outcome ==
                                                          2 ||
                                                      poisonController
                                                              .poisoning
                                                              .value
                                                              .poisonsOutcome
                                                              ?.outcome ==
                                                          3)
                                                    Column(
                                                      children: [
                                                        CommonDateTimeWidget(
                                                          title:
                                                              'Date & Time of Discharge',
                                                          dateTime:
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poisonsOutcome
                                                                  ?.dischargeDate
                                                                  .toString(),
                                                          onChanged: (value) {
                                                            poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.dischargeDate = value;
                                                          },
                                                        ),
                                                        TitleTextFormField(
                                                          title:
                                                              'Duration of hospital stay',
                                                          hintText:
                                                              'Enter Duration',
                                                          initialValue:
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poison
                                                                  ?.durationOfHospitalStay
                                                                  .toString(),
                                                          onChanged: (value) {
                                                            poisonController
                                                                    .poisoning
                                                                    .value
                                                                    .poison
                                                                    ?.durationOfHospitalStay =
                                                                int.parse(
                                                                    value);
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  if (poisonController
                                                          .poisoning
                                                          .value
                                                          .poisonsOutcome
                                                          ?.outcome ==
                                                      4)
                                                    CommonDateTimeWidget(
                                                      title:
                                                          'Date & Time of Absconded',
                                                      dateTime: poisonController
                                                          .poisoning
                                                          .value
                                                          .poisonsOutcome
                                                          ?.abscondedDate
                                                          .toString(),
                                                      onChanged: (value) {
                                                        poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.abscondedDate =
                                                            value;
                                                      },
                                                    ),
                                                  if (poisonController
                                                          .poisoning
                                                          .value
                                                          .poisonsOutcome
                                                          ?.outcome ==
                                                      5)
                                                    CommonDateTimeWidget(
                                                      title:
                                                          'Date & Time of Death',
                                                      dateTime: poisonController
                                                          .poisoning
                                                          .value
                                                          .poisonsOutcome
                                                          ?.deathDate
                                                          .toString(),
                                                      onChanged: (value) {
                                                        poisonController
                                                            .poisoning
                                                            .value
                                                            .poisonsOutcome
                                                            ?.deathDate = value;
                                                      },
                                                    ),
                                                  if (poisonController
                                                          .poisoning
                                                          .value
                                                          .poisonsOutcome
                                                          ?.outcome ==
                                                      7)
                                                    CommonDateTimeWidget(
                                                      title:
                                                          'Date & Time of Patient Exit',
                                                      dateTime: poisonController
                                                          .poisoning
                                                          .value
                                                          .poisonsOutcome
                                                          ?.patientExitDate
                                                          .toString(),
                                                      onChanged: (value) {
                                                        poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.patientExitDate =
                                                            value;
                                                      },
                                                    ),
                                                  if (poisonController
                                                          .poisoning
                                                          .value
                                                          .poisonsOutcome
                                                          ?.outcome ==
                                                      6)
                                                    Column(
                                                      spacing: 12,
                                                      children: [
                                                        Text(
                                                          'Referred to other Hospital',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        NewTitleDropdown(
                                                          title:
                                                              'Hospital Type',
                                                          items: poisonController
                                                                  .poisoningLookup
                                                                  .value
                                                                  .hospitalType
                                                                  ?.map((e) => {
                                                                        "id": e.id ??
                                                                            "",
                                                                        "name":
                                                                            e.name ??
                                                                                "",
                                                                      })
                                                                  .toList() ??
                                                              [],
                                                          selectedId:
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poisonsOutcome
                                                                  ?.hospitalType,
                                                          hint: 'Select status',
                                                          onChanged:
                                                              (value) async {
                                                            poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.hospitalType = value;
                                                            poisonController
                                                                .poisoning
                                                                .refresh();
                                                          },
                                                        ),
                                                        if (poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.hospitalType ==
                                                            1)
                                                          NewTitleDropdown(
                                                            title:
                                                                'Destination hospital',
                                                            items: hospitalController
                                                                    .hospitalList
                                                                    ?.map(
                                                                        (e) => {
                                                                              "hospitalid": e.hospitalid ?? "",
                                                                              "hospitalname": e.hospitalname ?? "",
                                                                            })
                                                                    .toList() ??
                                                                [],
                                                            selectedId:
                                                                poisonController
                                                                    .poisoning
                                                                    .value
                                                                    .poisonsOutcome
                                                                    ?.destinationTAEIHospital,
                                                            hint:
                                                                'Select status',
                                                            onChanged:
                                                                (value) async {
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poisonsOutcome
                                                                  ?.destinationTAEIHospital = value;
                                                            },
                                                          ),
                                                        if (poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.hospitalType ==
                                                            2)
                                                          TitleTextFormField(
                                                            title:
                                                                "Destination Non TAEI Hospital",
                                                            controller: TextEditingController(
                                                                text: poisonController
                                                                    .poisoning
                                                                    .value
                                                                    .poisonsOutcome
                                                                    ?.destinationHospital),
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            hintText:
                                                                'Enter Destination Non TAEI Hospital',
                                                            onChanged:
                                                                (value) async {
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poisonsOutcome
                                                                  ?.destinationHospital = value;
                                                            },
                                                          ),
                                                        NewTitleDropdown(
                                                          title:
                                                              'Reason for referral',
                                                          items: poisonController
                                                                  .poisoningLookup
                                                                  .value
                                                                  .reasonForReferral
                                                                  ?.map((e) => {
                                                                        "id": e
                                                                            .id,
                                                                        "name":
                                                                            e.name
                                                                      })
                                                                  .toList() ??
                                                              [],
                                                          selectedId:
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poisonsOutcome
                                                                  ?.reasonForReferral,
                                                          hint: 'Select status',
                                                          onChanged:
                                                              (value) async {
                                                            poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.reasonForReferral = value;
                                                            poisonController
                                                                .poisoning
                                                                .refresh();
                                                          },
                                                        ),
                                                        if (poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.reasonForReferral ==
                                                            3)

                                                          /// Backend
                                                          TitleTextFormField(
                                                            title:
                                                                "Other Specify",
                                                            controller: TextEditingController(
                                                                text: poisonController
                                                                    .poisoning
                                                                    .value
                                                                    .poisonsOutcome
                                                                    ?.othReasonForReferral),
                                                            keyboardType:
                                                                TextInputType
                                                                    .name,
                                                            hintText:
                                                                'Enter Reason',
                                                            onChanged:
                                                                (value) async {
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poisonsOutcome
                                                                  ?.othReasonForReferral = value;
                                                              poisonController
                                                                  .poisoning
                                                                  .refresh();
                                                            },
                                                          ),
                                                        NewTitleDropdown(
                                                          title:
                                                              'Condition of patient',
                                                          items: poisonController
                                                                  .poisoningLookup
                                                                  .value
                                                                  .conditionOfPatient
                                                                  ?.map((e) => {
                                                                        "id": e.id ??
                                                                            "",
                                                                        "name":
                                                                            e.name ??
                                                                                "",
                                                                      })
                                                                  .toList() ??
                                                              [],
                                                          selectedId:
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poisonsOutcome
                                                                  ?.conditionOfPatient,
                                                          hint: 'Select status',
                                                          onChanged:
                                                              (value) async {
                                                            poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.conditionOfPatient = value;
                                                          },
                                                        ),
                                                        TitleTextFormField(
                                                          controller: TextEditingController(
                                                              text: poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poisonsOutcome
                                                                  ?.referringDoctor),
                                                          title:
                                                              "Referring Doctor",
                                                          keyboardType:
                                                              TextInputType
                                                                  .name,
                                                          hintText:
                                                              'Enter Doctor Name',
                                                          onChanged:
                                                              (value) async {
                                                            poisonController
                                                                .poisoning
                                                                .value
                                                                .poisonsOutcome
                                                                ?.referringDoctor = value;
                                                          },
                                                          validator: (value) {
                                                            if (value == null) {
                                                              return 'Please Enter Doctor Name';
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                        ),

                                                        /// Whether details documented in TAEI Case sheet	Yes/No
                                                        NewTitleYesRadio(
                                                            title:
                                                                'Whether details documented in TAEI Case sheet',
                                                            initialValue:
                                                                poisonController
                                                                    .poisoning
                                                                    .value
                                                                    .poisonsOutcome
                                                                    ?.documentedTaeiSheet,
                                                            onChanged:
                                                                (value) async {
                                                              poisonController
                                                                  .poisoning
                                                                  .value
                                                                  .poisonsOutcome
                                                                  ?.documentedTaeiSheet = value;
                                                            }),
                                                      ],
                                                    ),

                                                  /*DateTimeRowPicker(
                                                dateTitle:
                                                    'Recovered and Discharged Date',
                                                timeTitle:
                                                    'Recovered and Discharged Time',
                                              ),
                                              Space(
                                                height: 20,
                                              ),
                                              TitleDropdown(
                                                  title:
                                                      'Recovered with Complications',
                                                  items: [''],
                                                  onChanged: (value) {}),
                                              Space(
                                                height: 20,
                                              ),
                                              TitleDropdown(
                                                  title:
                                                      'Under Treatment / Ongoing Care',
                                                  items: [''],
                                                  onChanged: (value) {}),
                                              Space(
                                                height: 20,
                                              ),
                                              TitleDropdown(
                                                  title:
                                                      'Referred to Higher Center',
                                                  items: [''],
                                                  onChanged: (value) {}),
                                              Space(
                                                height: 20,
                                              ),
                                              DateTimeRowPicker(
                                                dateTitle:
                                                    'Left Against Medical Advice (LAMA) Date',
                                                timeTitle:
                                                    'Left Against Medical Advice (LAMA) Time',
                                              ),
                                              Space(
                                                height: 20,
                                              ),
                                              TitleYesRadio(
                                                  title: 'Absconded',
                                                  onChanged: (value) {}),
                                              Space(
                                                height: 20,
                                              ),
                                              TitleYesRadio(
                                                  title: 'Brought Dead',
                                                  onChanged: (value) {}),
                                              Space(
                                                height: 20,
                                              ),
                                              DateTimeRowPicker(
                                                  dateTitle:
                                                      'Death After Admission Date',
                                                  timeTitle:
                                                      'Death After Admission Time'),
                                              Space(
                                                height: 20,
                                              ),*/
                                                ],
                                              ),
                        Space(
                          height: 30,
                        ),
                        Row(
                          children: [
                            poisonController.currentIndex.value == 0
                                ? CommonElevatedButtonM(
                                    backgroundColor: Colors.white,
                                    text: 'Back',
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                                : CommonElevatedButtonM(
                                    backgroundColor: Colors.white,
                                    text: 'Back',
                                    onPressed: () {
                                      if (poisonController.currentIndex.value ==
                                          0) {
                                      } else {
                                        poisonController.changeIndex(
                                          poisonController.currentIndex.value -
                                              1,
                                        );
                                      }
                                    }),
                            Spacer(),
                            widget.prem == true
                                ? Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                      ),
                                      CommonElevatedButtonM(
                                        text: poisonController
                                                    .currentIndex.value ==
                                                3
                                            ? (poisonController.notFound == true
                                                ? 'Submit From Prem'
                                                : 'Update From Prem')
                                            : "Next",
                                        onPressed: () async {
                                          if (validatePoisoningForm(
                                              outcome: false)) return;
                                          debugPrint(poisonController
                                              .poisoning.value
                                              .toString());
                                          if (poisonController
                                                  .currentIndex.value ==
                                              3) {
                                            poisonController.poisoning.value
                                                    .poison?.triageId =
                                                int.parse(
                                                    widget.triageId.toString());
                                            log('My Trama ${poisonController.poisoning.value}');

                                            bool success = false;

                                            if (poisonController.notFound ==
                                                true) {
                                              success = await poisonController
                                                  .createPoison(
                                                      data: poisonController
                                                          .poisoning.value);
                                            } else {
                                              debugPrint(
                                                  "Updating record with ID: ${widget.id}");
                                              success = await poisonController
                                                  .updatePoison(
                                                data: poisonController
                                                    .poisoning.value,
                                                id: poisonController
                                                    .poisoning.value.poison!.id
                                                    .toString(),
                                              );
                                            }
                                            if (success) {
                                              Navigator.pop(context, true);
                                              // Navigator.pop(context,
                                              //     true); // Close form and return success
                                            }
                                            // if (widget.isUpdate == true) {
                                            //   await poisonController.updatePoison(
                                            //       data: poisonController.poisoning.value,
                                            //       id: widget.poisonId.toString());
                                            // } else {
                                            //   await poisonController.createPoison(
                                            //       data:
                                            //           poisonController.poisoning.value);
                                            // }
                                          } else {
                                            poisonController.currentIndex
                                                .value = poisonController
                                                    .currentIndex.value +
                                                1;
                                          }

                                          // final reqData =
                                          //     bitesController.bitesModelRequest.value;
                                          // bool success = false;
                                          //
                                          // if (bitesController.notFound == true) {
                                          //   // Create new record
                                          //   success = await bitesController.createBites(
                                          //       data: reqData);
                                          // } else {
                                          //   debugPrint("Updating record with ID: ${widget.id}");
                                          //   success = await bitesController.updateBites(
                                          //     data: reqData,
                                          //     id: bitesController
                                          //         .bitesModelRequest.value.bitesStings!.id
                                          //         .toString(),
                                          //   );
                                          // }
                                          // if (success) {
                                          //   Navigator.pop(context, true);
                                          //   Navigator.pop(
                                          //       context, true); // Close form and return success
                                          // }
                                        },
                                      ),
                                    ],
                                  )
                                : CommonElevatedButtonM(
                                    text:
                                        poisonController.currentIndex.value == 4
                                            ? 'Proceed'
                                            : 'Next',
                                    onPressed: () async {
                                      if (validatePoisoningForm(
                                          outcome: false)) {
                                        debugPrint(poisonController
                                            .poisoning.value
                                            .toString());
                                        if (poisonController
                                                .currentIndex.value ==
                                            4) {
                                          /// Old Save Methods
                                          ///
                                          /* poisonController.poisoning.value.poison
                                                ?.triageId =
                                            int.parse(
                                                widget.triageId.toString());
                                        if (widget.isUpdate == true) {
                                          await poisonController.updatePoison(
                                              data: poisonController
                                                  .poisoning.value,
                                              id: widget.poisonId.toString());
                                        } else {
                                          await poisonController.createPoison(
                                              data: poisonController
                                                  .poisoning.value);
                                        }*/

                                          /// Save or Submit
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                SaveOrSubmitDialog(
                                              title: 'Save or Submit',
                                              content:
                                                  'Do you want to save or submit?',
                                              onSave: () async {
                                                if (validatePoisoningForm(
                                                    outcome: false)) {
                                                  poisonController
                                                          .poisoning
                                                          .value
                                                          .poison
                                                          ?.triageId =
                                                      int.parse(widget.triageId
                                                          .toString());
                                                  poisonController
                                                      .poisoning
                                                      .value
                                                      .poisonsOutcome
                                                      ?.isDischarged = false;
                                                  if (widget.isUpdate ==
                                                      false) {
                                                    await poisonController
                                                        .createPoison(
                                                            data:
                                                                poisonController
                                                                    .poisoning
                                                                    .value);
                                                    Get.back();
                                                  } else {
                                                    await poisonController
                                                        .updatePoison(
                                                            data:
                                                                poisonController
                                                                    .poisoning
                                                                    .value,
                                                            id: widget.poisonId
                                                                .toString());

                                                    Get.back();
                                                  }
                                                };
                                                // Navigator.pop(context);
                                              },
                                              onSubmit: () async {
                                                if (validatePoisoningForm(
                                                    outcome: true)) {
                                                  poisonController
                                                          .poisoning
                                                          .value
                                                          .poison
                                                          ?.triageId =
                                                      int.parse(widget.triageId
                                                          .toString());
                                                  poisonController
                                                      .poisoning
                                                      .value
                                                      .poisonsOutcome
                                                      ?.isDischarged = true;
                                                  if (widget.isUpdate ==
                                                      false) {
                                                    await poisonController
                                                        .createPoison(
                                                            data:
                                                                poisonController
                                                                    .poisoning
                                                                    .value);
                                                    Get.back();
                                                  } else {
                                                    await poisonController
                                                        .updatePoison(
                                                            data:
                                                                poisonController
                                                                    .poisoning
                                                                    .value,
                                                            id: widget.poisonId
                                                                .toString());

                                                    Get.back();
                                                  }
                                                }
                                              },
                                            ),
                                          );
                                        } else {
                                          poisonController.currentIndex.value =
                                              poisonController
                                                      .currentIndex.value +
                                                  1;
                                        }
                                      }
                                    }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          })),
    );
  }

  int calculatePositiveDays(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 0;

    try {
      // Convert "2025-11-26 03:42:00 PM" → DateTime
      DateTime date = DateFormat("yyyy-MM-dd hh:mm:ss a").parse(dateString);

      // Difference from now
      int days = DateTime.now().difference(date).inDays;

      // Return only positive (no negative values)
      return days < 0 ? 0 : days;
    } catch (e) {
      return 0;
    }
  }
}
