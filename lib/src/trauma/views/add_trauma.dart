import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/hospital/controller/hospital_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/trauma/controller/trauma_controller.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import 'package:taei_gov/utils/common/new_common_date_time_picker.dart';
import 'package:taei_gov/utils/common/save_submit_dialog.dart';
import 'package:taei_gov/utils/common/step_indicator.dart';
import '../../../utils/common/common_check_box_list.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../../utils/common/date_picker.dart';
import '../../../utils/common/list_data_radio_button.dart';
import '../../../utils/common/m_elevate_button.dart';
import '../../../utils/common/space.dart';
import '../../../utils/common/title_textfield.dart';
import '../../../utils/common/yes_or_no_radio_button.dart';

class AddTrauma extends StatefulWidget {
  final String? triageId;
  final String? traumaId;
  final String? dateTimeOfTriage;
  final String? dateAndTimeOfIncident;
  final bool isUpdate;
  final String? dischargeStatus;

  const AddTrauma({
    super.key,
    this.triageId,
    this.traumaId,
    this.isUpdate = false,
    this.dateTimeOfTriage,
    this.dateAndTimeOfIncident,
    this.dischargeStatus,
  });

  @override
  State<AddTrauma> createState() => _AddTraumaState();
}

class _AddTraumaState extends State<AddTrauma> {
  TraumaController traumaController = Get.put(TraumaController());
  TextEditingController dateController = TextEditingController();
  HospitalController hospitalController = Get.put(HospitalController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      traumaController.isLoading(true);
      await traumaController.getTraumaLookup();
      await hospitalController.getHospitalListData();
      if (widget.isUpdate) {
        await traumaController
            .getTraumaById(id: widget.traumaId ?? '')
            .then((value) {
          traumaController.trauma.value.traumaOutcome?.stayedDuration =
              calculatePositiveDays(
                  traumaController.trauma.value.trauma?.dateTimeOfEntry);

          traumaController
                  .trauma.value.traumaFinal?.surgeryTakenupFromTriageDate =
              calculatePositiveDays(widget.dateTimeOfTriage);
          traumaController
                  .trauma.value.traumaFinal?.surgeryTakenupFromIncidentDate =
              calculatePositiveDays(widget.dateAndTimeOfIncident);
        });
      }
      traumaController.isLoading(false);
    });
    print(
        'Test date ${traumaController.trauma.value.traumaOutcome?.stayedDuration}');

    super.initState();
  }

  bool validateTraumaForm({required bool outcome}) {
    final model = traumaController.trauma.value;

    // Step 1 Validation
    if (traumaController.currentIndex.value == 0) {
      // Patient Admission validation
      if (model.trauma?.patientAdmitted == null) {
        showValidationError("Patient admission status is required");
        return false;
      }

      if (model.trauma?.patientAdmitted == true) {
        if (model.trauma?.dateTimeOfEntry == null) {
          showValidationError(
              "Date Time of Admission is required when patient is admitted");
          return false;
        }
        if (model.trauma?.nameOfDept == null ||
            model.trauma!.nameOfDept!.isEmpty) {
          showValidationError("Name of Admitting Department is required");
          return false;
        }
      }

      // Mechanism of Injury
      if (model.trauma?.mechanismOfInjury == null) {
        showValidationError("Mechanism of Injury is required");
        return false;
      }

      // Type of Injury
      if (model.trauma?.typeOfInjury == null) {
        showValidationError("Type of Injury is required");
        return false;
      }

      // Conditional validation based on Type of Injury
      if (model.trauma?.typeOfInjury == 11) {
        // WorkSpot Injury
        if (model.trauma?.workspotInjury == null) {
          showValidationError("Sector Type is required for WorkSpot Injury");
          return false;
        }
      }

      if (model.trauma?.typeOfInjury == 5) {
        // Assault
        if (model.trauma?.assault == null) {
          showValidationError("Assault Type is required");
          return false;
        }
      }

      if (model.trauma?.typeOfInjury == 1) {
        // RTA
        if (model.trauma?.rta == null) {
          showValidationError("Vehicle Involved is required for RTA");
          return false;
        }
      }

      if (model.trauma?.typeOfInjury == 13) {
        if (model.trauma?.othTypeOfInjury == null ||
            model.trauma!.othTypeOfInjury!.isEmpty) {
          showValidationError("Please specify Other Injury Type");
          return false;
        }
      }

      // Injuries Identified
      if (model.trauma?.injuriesIdentified == null ||
          model.trauma!.injuriesIdentified!.isEmpty) {
        showValidationError("Please select at least one Injury");
        return false;
      }

      // If "Others" is selected in injuries
      if (model.trauma?.injuriesIdentified?.contains(14) ?? false) {
        if (model.trauma?.othInjuriesIdentified == null ||
            model.trauma!.othInjuriesIdentified!.isEmpty) {
          showValidationError("Please specify Other Injuries");
          return false;
        }
      }

      // Part of Body Injured
      if (model.trauma?.partOfTheBodyInjured == null ||
          model.trauma!.partOfTheBodyInjured!.isEmpty) {
        showValidationError("Please select at least one Part of Body Injured");
        return false;
      }

      // If "Others" is selected in body parts
      if (model.trauma?.partOfTheBodyInjured?.contains(38) ?? false) {
        if (model.trauma?.othBodyInjured == null ||
            model.trauma!.othBodyInjured!.isEmpty) {
          showValidationError("Please specify Other Body Part");
          return false;
        }
      }

      // GCS validation
      if (model.trauma?.gcsEye == null) {
        showValidationError("GCS (Eye) is required");
        return false;
      }

      if (model.trauma?.gcsVerbal == null) {
        showValidationError("GCS (Verbal) is required");
        return false;
      }

      if (model.trauma?.gcsMotor == null) {
        showValidationError("GCS (Motor) is required");
        return false;
      }

      // GCS Total is calculated, so check if calculation happened
      if (traumaController.gcsTotal == null) {
        showValidationError("GCS Total calculation failed");
        return false;
      }

      // BP validation
      if (model.traumaValues?.bpSystolic == null) {
        showValidationError("BP Systolic is required");
        return false;
      }
      if (model.traumaValues?.bpDiastolic == null) {
        showValidationError("BP Diastolic is required");
        return false;
      }

      // RR validation
      if (model.traumaValues?.rr == null || model.traumaValues!.rr!.isEmpty) {
        showValidationError("RR is required");
        return false;
      }

      // RTS (auto-generated)
      if (traumaController.totalTraumaScore == null) {
        showValidationError("RTS calculation failed");
        return false;
      }

      // Trauma Flag
      if (model.traumaValues?.traumaFlag == null) {
        showValidationError("Trauma Flag is required");
        return false;
      }

      // ECG - if yes, findings required
      // if (model.traumaValues?.ecg == null) {
      //   // if (model.traumaValues?.ecgfindings == null ||
      //   //     model.traumaValues!.ecgfindings!.isEmpty) {
      //   showValidationError("ECG  are required");
      //   return false;
      // }

      // XRay - if yes, date time and findings required
      if (model.traumaValues?.xray == null) {
        // if (model.traumaValues?.xrayDateTime == null) {
        showValidationError("XRay is required");
        return false;
        // }
        // if (model.traumaValues?.xrayfindings == null ||
        //     model.traumaValues!.xrayfindings!.isEmpty) {
        //   showValidationError("XRay Findings are required");
        //   return false;
        // }
      }

      // EFAST - if yes, date time and findings required
      if (model.traumaValues?.efast == null) {
        // if (model.traumaValues?.efastDateTime == null) {
        showValidationError("EFAST is required");
        return false;
        // }
        // if (model.traumaValues?.efastfindings == null ||
        //     model.traumaValues!.efastfindings!.isEmpty) {
        //   showValidationError("EFAST Findings are required");
        //   return false;
        // }
      }

      // CT - if yes, date time and findings required
      if (model.traumaValues?.ct == null) {
        // if (model.traumaValues?.ctDateTime == null) {
        showValidationError("CT is required");
        return false;
        // }
        // if (model.traumaValues?.ctfindings == null ||
        //     model.traumaValues!.ctfindings!.isEmpty) {
        //   showValidationError("CT Findings are required");
        //   return false;
        // }
      }

      // MRI - if yes, date time and findings required
      if (model.traumaValues?.mri == null) {
        // if (model.traumaValues?.mriDateTime == null) {
        showValidationError("MRI is required");
        return false;
        // }
        // if (model.traumaValues?.mrifindings == null ||
        //     model.traumaValues!.mrifindings!.isEmpty) {
        //   showValidationError("MRI Findings are required");
        //   return false;
        // }
      }

      // ABG - if yes, date time required
      if (model.traumaValues?.abg == null) {
        // if (model.traumaValues?.abgDateTime == null) {
        showValidationError("ABG is required");
        return false;
        // }
      }

      // Blood Investigation - if yes, date time required
      if (model.traumaValues?.bloodInvestigation == null) {
        // if (model.traumaValues?.bloodDateTime == null) {
        showValidationError("Blood Investigation is required");
        return false;
      }
      // }

      // HCG - if yes, date time required
      if (model.traumaValues?.hcg == null) {
        showValidationError("HCG is required");
        return false;
      }

      if (model.traumaValues?.urineTest == null) {
        showValidationError("Urine Test is required");
        return false;
      }

      // Other Tests - if specified, date time required
      if (model.traumaValues?.othSpecify != null &&
          model.traumaValues!.othSpecify!.isNotEmpty) {
        // if (model.traumaValues?.othDateTime == null) {
        showValidationError("Other Tests is required");
        return false;
        // }
      }

      // Speciality Opinion (Step 1 section)
      if (model.traumaFinal?.specialityOpinion == null ||
          model.traumaFinal!.specialityOpinion!.isEmpty) {
        showValidationError("Speciality Opinion is required");
        return false;
      }
    } else {
      // Step 2 Validation
      // CPR validation
      if (model.traumaFinal?.iscpr == true) {
        if (model.traumaFinal?.cprDone == null) {
          showValidationError("Please specify when CPR was done");
          return false;
        }
      }

      // Mechanical Ventilation validation
      if (model.traumaFinal?.mechIntubation == true) {
        if (model.traumaFinal?.mechIntubationDtls == null) {
          showValidationError(
              "Intubation Type is required for Mechanical Ventilation");
          return false;
        }
        if (model.traumaFinal?.mechIntubationDtls == 2) {
          // ET Intubation
          if (model.traumaFinal?.firstPassIntubation == null) {
            showValidationError(
                "First Pass Intubation status is required for ET Intubation");
            return false;
          }
        }
      }

      // Other Procedure Done
      if (model.traumaFinal?.otherProcedureDone == 18) {
        // Others
        if (model.traumaFinal?.othProcedureDone == null ||
            model.traumaFinal!.othProcedureDone!.isEmpty) {
          showValidationError("Please specify Other Procedure");
          return false;
        }
      }

      // Final Diagnosis
      if (model.traumaFinal?.finalDiagnosis == null ||
          model.traumaFinal!.finalDiagnosis!.isEmpty) {
        showValidationError("Final Diagnosis is required");
        return false;
      }
      // Management
      if (model.traumaFinal?.management == null) {
        showValidationError("Management type is required");
        return false;
      }

      // Surgery Management
      if (model.traumaFinal?.management == 2) {
        // Surgery
        if (model.traumaFinal?.typeOfSurgery == null) {
          showValidationError("Surgery Type is required");
          return false;
        }
        if (model.traumaFinal?.surgeryType == null) {
          showValidationError("Please select Major/Minor Surgery");
          return false;
        }
        if (model.traumaFinal?.surgeryName == null ||
            model.traumaFinal!.surgeryName!.isEmpty) {
          showValidationError("Surgery Name is required");
          return false;
        }
        if (model.traumaFinal?.dateTime == null) {
          showValidationError("Surgery Date & Time is required");
          return false;
        }
        if (model.traumaFinal?.nameOfSpeciality == null) {
          showValidationError("Name of Speciality is required");
          return false;
        }
        if (model.traumaFinal?.doneBy == null ||
            model.traumaFinal!.doneBy!.isEmpty) {
          showValidationError("Done By is required");
          return false;
        }
        if (model.traumaFinal?.surgeryDoneUnder == null) {
          showValidationError("Surgery Done Under is required");
          return false;
        }
      }
      if (outcome == true) {
        if (model.traumaOutcome?.outcome == null) {
          showValidationError("Outcome is required");
          return false;
        }
      }
      // if (model.traumaOutcome?.nameOfDoctor == null ||
      //     model.traumaOutcome?.nameOfDoctor == "") {
      //   showValidationError("Outcome is required");
      //   return false;
      // }
    }
    return true;
  }

  void showValidationError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: const Color(0xFFD32F2F), // Material Design red 700
      textColor: Colors.white,
      webBgColor: "#d32f2f", // hex red
      webShowClose: false,
      fontSize: context.isDesktop ? 18.0 : 15.0,
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
      appBar: CommonAppBar(
        title: 'Trauma',
        id: widget.triageId,
      ),
      body: Obx(
        () => traumaController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
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
                          : Colors.transparent, // border color
                      width: 0.3 // border thickness
                      ),
                ),
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(scrollbars: false),
                  child: Padding(
                    padding: context.isDesktop
                        ? EdgeInsets.only(
                            left: 30, right: 30, top: 8, bottom: 8)
                        : EdgeInsets.all(10),
                    child: ListView(children: [
                      FancyStepIndicator(
                          currentIndex: traumaController.currentIndex,
                          stepCount: 2),
                      Space(height: 16),
                      traumaController.currentIndex.value == 0
                          ? Column(
                              spacing: 12,
                              children: [
                                NewTitleYesRadio(
                                    isRequired: true, // MANDATORY
                                    title: 'Patient admitted',
                                    initialValue: traumaController
                                        .trauma.value.trauma?.patientAdmitted,
                                    onChanged: (value) {
                                      traumaController.trauma.value.trauma
                                          ?.patientAdmitted = value;
                                      traumaController.trauma.refresh();

                                      print('Value $value');
                                      print(
                                          'Test date ${traumaController.trauma.value.trauma?.patientAdmitted}');
                                    }),
                                traumaController.trauma.value.trauma
                                            ?.patientAdmitted ==
                                        true
                                    ? Column(
                                        children: [
                                          CommonDateTimeWidget(
                                              isRequired:
                                                  true, // MANDATORY when admitted
                                              title: 'Date Time of Admission',
                                              dateTime: traumaController.trauma
                                                  .value.trauma?.dateTimeOfEntry
                                                  .toString(),
                                              onChanged: (value) {
                                                traumaController
                                                    .trauma
                                                    .value
                                                    .trauma
                                                    ?.dateTimeOfEntry = value;
                                                traumaController
                                                        .trauma
                                                        .value
                                                        .traumaOutcome
                                                        ?.stayedDuration =
                                                    calculatePositiveDays(
                                                        value);
                                              }),
                                          Space(
                                            height: 16,
                                          ),
                                          TitleTextFormField(
                                              isRequired:
                                                  true, // MANDATORY when admitted
                                              title:
                                                  'Name of The Admitting Department',
                                              hintText:
                                                  'Enter Name of The Admitting Department',
                                              controller: TextEditingController(
                                                text: traumaController.trauma
                                                    .value.trauma?.nameOfDept,
                                              ),
                                              onChanged: (value) {
                                                traumaController.trauma.value
                                                    .trauma?.nameOfDept = value;
                                              })
                                        ],
                                      )
                                    : Container(),
                                NewTitleDropdown(
                                  isRequired: true, // MANDATORY
                                  title: 'Mechanism of Injury',
                                  items: traumaController
                                          .traumaLookup.value.mechanismOfInjury
                                          ?.map((e) => {
                                                "id": e.id ?? "",
                                                "name": e.name ?? "",
                                              })
                                          .toList() ??
                                      [],
                                  selectedId: traumaController
                                      .trauma.value.trauma?.mechanismOfInjury,
                                  hint: 'Select Mechanism of Injury',
                                  onChanged: (value) async {
                                    traumaController.trauma.value.trauma
                                            ?.mechanismOfInjury =
                                        int.parse(value.toString());
                                  },
                                ),
                                NewTitleDropdown(
                                  isRequired: true, // MANDATORY
                                  title: 'Type of injury',
                                  items: traumaController
                                          .traumaLookup.value.typeOfInjury
                                          ?.map((e) => {
                                                "id": e.id ?? "",
                                                "name": e.name ?? "",
                                              })
                                          .toList() ??
                                      [],
                                  selectedId: traumaController
                                      .trauma.value.trauma?.typeOfInjury,
                                  hint: 'Select Injury Type',
                                  onChanged: (value) async {
                                    traumaController.trauma.value.trauma
                                        ?.typeOfInjury = value;
                                    print(traumaController
                                        .trauma.value.trauma?.typeOfInjury);
                                    traumaController.trauma.refresh();
                                  },
                                ),

                                /// WorkSpot Injury
                                if (traumaController
                                        .trauma.value.trauma?.typeOfInjury ==
                                    11)
                                  NewTitleDropdown(
                                    isRequired:
                                        true, // MANDATORY for WorkSpot Injury
                                    title: 'Sector Type',
                                    items: traumaController
                                            .traumaLookup.value.workspotInjury
                                            ?.map((e) => {
                                                  "id": e.id ?? "",
                                                  "name": e.name ?? "",
                                                })
                                            .toList() ??
                                        [],
                                    selectedId: traumaController
                                        .trauma.value.trauma?.workspotInjury,
                                    hint: 'Select Type',
                                    onChanged: (value) async {
                                      traumaController.trauma.value.trauma
                                              ?.workspotInjury =
                                          int.parse(value.toString());
                                    },
                                  ),

                                /// Assault
                                if (traumaController
                                        .trauma.value.trauma?.typeOfInjury ==
                                    5)
                                  NewTitleDropdown(
                                    isRequired: true, // MANDATORY for Assault
                                    title: 'Sector Type',
                                    items: traumaController
                                            .traumaLookup.value.assault
                                            ?.map((e) => {
                                                  "id": e.id ?? "",
                                                  "name": e.name ?? "",
                                                })
                                            .toList() ??
                                        [],
                                    selectedId: traumaController
                                        .trauma.value.trauma?.assault,
                                    hint: 'Select Type',
                                    onChanged: (value) async {
                                      traumaController
                                          .trauma.value.trauma?.assault = value;
                                    },
                                  ),

                                /// Road Traffic Injury
                                if (traumaController
                                        .trauma.value.trauma?.typeOfInjury ==
                                    1)
                                  Column(
                                    spacing: 12,
                                    children: [
                                      NewTitleYesRadio(
                                        title: 'IKT Availed',
                                        initialValue: traumaController
                                            .trauma.value.trauma?.iktAvailed,
                                        onChanged: (value) {
                                          traumaController.trauma.value.trauma
                                              ?.iktAvailed = value;
                                        },
                                      ),
                                      NewTitleDropdown(
                                        isRequired: true, // MANDATORY for RTA
                                        title: 'Vehicle Involved',
                                        items: traumaController
                                                .traumaLookup.value.rta
                                                ?.map((e) => {
                                                      "id": e.id ?? "",
                                                      "name": e.name ?? "",
                                                    })
                                                .toList() ??
                                            [],
                                        selectedId: traumaController
                                            .trauma.value.trauma?.rta,
                                        hint: 'Select Type',
                                        onChanged: (value) async {
                                          traumaController
                                              .trauma.value.trauma?.rta = value;
                                          traumaController.trauma.refresh();
                                        },
                                      ),

                                      /// Two Wheeler
                                      if (traumaController
                                              .trauma.value.trauma?.rta ==
                                          1)
                                        Column(
                                          spacing: 12,
                                          children: [
                                            NewTitleYesRadio(
                                              title: 'Helmet use',
                                              initialValue: traumaController
                                                  .trauma
                                                  .value
                                                  .trauma
                                                  ?.rtaHelmet,
                                              onChanged: (value) {
                                                traumaController.trauma.value
                                                    .trauma?.rtaHelmet = value;
                                              },
                                            ),
                                            // NewTitleYesRadio(
                                            //   title: 'IKT Availed',
                                            //   initialValue: traumaController
                                            //       .trauma
                                            //       .value
                                            //       .trauma
                                            //       ?.iktAvailed,
                                            //   onChanged: (value) {
                                            //     traumaController.trauma.value
                                            //         .trauma?.iktAvailed = value;
                                            //   },
                                            // ),
                                          ],
                                        )
                                    ],
                                  ),
                                if (traumaController
                                        .trauma.value.trauma?.typeOfInjury ==
                                    13)
                                  TitleTextFormField(
                                      isRequired:
                                          true, // MANDATORY for Other injury type
                                      title: 'Other Specify',
                                      hintText: 'Enter Other Specify',
                                      controller: TextEditingController(
                                        text: traumaController.trauma.value
                                            .trauma?.othTypeOfInjury,
                                      ),
                                      keyboardType: TextInputType.name,
                                      onChanged: (value) {
                                        traumaController.trauma.value.trauma
                                            ?.othTypeOfInjury = value;
                                      }),
                                NewCheckboxList(
                                  isRequired: true, // MANDATORY
                                  title: 'Injuries identified',
                                  options: traumaController.traumaLookup.value
                                          .injuriesIdentified ??
                                      [],
                                  initialSelectedIndexes: traumaController
                                              .trauma
                                              .value
                                              .trauma
                                              ?.injuriesIdentified ==
                                          null
                                      ? []
                                      : traumaController.trauma.value.trauma!
                                          .injuriesIdentified!,
                                  onChanged: (value) async {
                                    traumaController.trauma.value.trauma
                                        ?.injuriesIdentified = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                        .trauma.value.trauma?.injuriesIdentified
                                        ?.contains(14) ??
                                    false)
                                  TitleTextFormField(
                                    isRequired:
                                        true, // MANDATORY when Others is selected
                                    title: "Specify Injuries",
                                    controller: TextEditingController(
                                      text: traumaController.trauma.value.trauma
                                          ?.othInjuriesIdentified,
                                    ),
                                    keyboardType: TextInputType.name,
                                    hintText: 'Enter Specify Injuries',
                                    onChanged: (value) {
                                      traumaController.trauma.value.trauma
                                          ?.othInjuriesIdentified = value;
                                    },
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please Enter Specific Parts';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                NewCheckboxList(
                                  isRequired: true, // MANDATORY
                                  title: 'Part of the Body Injured',
                                  options: traumaController.traumaLookup.value
                                          .partOfTheBodyInjured ??
                                      [],
                                  initialSelectedIndexes: traumaController
                                              .trauma
                                              .value
                                              .trauma
                                              ?.partOfTheBodyInjured ==
                                          null
                                      ? []
                                      : traumaController.trauma.value.trauma!
                                          .partOfTheBodyInjured!,
                                  onChanged: (value) {
                                    traumaController.trauma.value.trauma
                                        ?.partOfTheBodyInjured = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),

                                traumaController.trauma.value.trauma
                                            ?.partOfTheBodyInjured
                                            ?.contains(38) ??
                                        false
                                    ? TitleTextFormField(
                                        isRequired:
                                            true, // MANDATORY when Others is selected
                                        title: "If Others Specify Body Part",
                                        controller: TextEditingController(
                                          text: traumaController.trauma.value
                                              .trauma?.othBodyInjured,
                                        ),
                                        onChanged: (value) {
                                          traumaController.trauma.value.trauma
                                              ?.othBodyInjured = value;
                                        },
                                        keyboardType: TextInputType.name,
                                        hintText:
                                            'Enter Specify other part Body',
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please Enter Specify other part Body';
                                          } else {
                                            return null;
                                          }
                                        },
                                      )
                                    : SizedBox(),
                                NewTitleDropdown(
                                  isRequired: true, // MANDATORY
                                  title: 'GCS(Eye)',
                                  items:
                                      traumaController.traumaLookup.value.gcsEye
                                              ?.map((e) => {
                                                    "id": e.id ?? "",
                                                    "name": e.name ?? "",
                                                  })
                                              .toList() ??
                                          [],
                                  selectedId: traumaController
                                      .trauma.value.trauma?.gcsEye,
                                  hint: 'Select GCS',
                                  onChanged: (value) async {
                                    traumaController
                                        .trauma.value.trauma?.gcsEye = value;
                                    print(
                                        "value ${traumaController.trauma.value.trauma?.gcsEye}");
                                    traumaController.updateGcsEye(value);
                                    // traumaController.trauma.refresh();
                                  },
                                ),
                                Space(
                                  height: 10,
                                ),
                                NewTitleDropdown(
                                  isRequired: true, // MANDATORY
                                  title: 'GCS(Verbal)',
                                  items: traumaController
                                          .traumaLookup.value.gcsVerbal
                                          ?.map((e) => {
                                                "id": e.id ?? "",
                                                "name": e.name ?? "",
                                              })
                                          .toList() ??
                                      [],
                                  selectedId: traumaController
                                      .trauma.value.trauma?.gcsVerbal,
                                  hint: 'Select GCS',
                                  onChanged: (value) async {
                                    traumaController
                                        .trauma.value.trauma?.gcsVerbal = value;
                                    traumaController.updateGcsVerbal(value);
                                    //  traumaController.trauma.refresh();
                                  },
                                ),
                                Space(
                                  height: 10,
                                ),
                                NewTitleDropdown(
                                  isRequired: true, // MANDATORY
                                  title: 'GCS(Motor)',
                                  items: traumaController
                                          .traumaLookup.value.gcsMotor
                                          ?.map((e) => {
                                                "id": e.id ?? "",
                                                "name": e.name ?? "",
                                              })
                                          .toList() ??
                                      [],
                                  selectedId: traumaController
                                      .trauma.value.trauma?.gcsMotor,
                                  hint: 'Select GCS',
                                  onChanged: (value) async {
                                    traumaController
                                        .trauma.value.trauma?.gcsMotor = value;
                                    traumaController.updateGcsMotor(value);
                                    // traumaController.trauma.refresh();
                                  },
                                ),
                                Space(
                                  height: 16,
                                ),
                                TitleTextFormField(
                                  isRequired: true, // MANDATORY (calculated)
                                  title: "GCS Total",
                                  readOnly: true,
                                  controller: TextEditingController(
                                    text: traumaController.gcsTotal.toString(),
                                  ),
                                  onChanged: (value) {
                                    traumaController
                                        .trauma.value.trauma?.gcsTotal = value;
                                    // traumaController.trauma.refresh();
                                  },
                                  keyboardType: TextInputType.name,
                                  hintText: 'Enter GCS Total',
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please Enter GCS Total';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                Space(
                                  height: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'BP',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Row(children: [
                                      Expanded(
                                        child: TitleTextFormField(
                                          isRequired: true, // MANDATORY
                                          title: "BP Systolic",
                                          keyboardType: TextInputType.number,
                                          hintText: 'Enter BP Systolic',
                                          maxLength: 3,
                                          initialValue: traumaController
                                                      .trauma
                                                      .value
                                                      .traumaValues
                                                      ?.bpSystolic !=
                                                  null
                                              ? traumaController.trauma.value
                                                  .traumaValues!.bpSystolic
                                                  .toString()
                                              : "",
                                          onChanged: (value) {
                                            traumaController.trauma.value
                                                    .traumaValues?.bpSystolic =
                                                int.parse(value.toString());
                                            traumaController.updateBpSystolic(
                                                int.parse(value.toString()));
                                            //traumaController.trauma.refresh();
                                          },
                                        ),
                                      ),
                                      Spacer(),
                                      Expanded(
                                          child: TitleTextFormField(
                                              isRequired: true, // MANDATORY
                                              title: "BP Diastolic",
                                              keyboardType:
                                                  TextInputType.number,
                                              hintText: 'Enter BP Diastolic',
                                              maxLength: 3,
                                              initialValue: traumaController
                                                          .trauma
                                                          .value
                                                          .traumaValues
                                                          ?.bpDiastolic !=
                                                      null
                                                  ? traumaController
                                                      .trauma
                                                      .value
                                                      .traumaValues
                                                      ?.bpDiastolic
                                                      .toString()
                                                  : "",
                                              onChanged: (value) {
                                                traumaController
                                                        .trauma
                                                        .value
                                                        .traumaValues
                                                        ?.bpDiastolic =
                                                    int.parse(value.toString());
                                                traumaController
                                                    .updateBpDiastolic(
                                                        int.parse(
                                                            value.toString()));
                                                // traumaController.trauma.refresh();
                                              }))
                                    ]),
                                  ],
                                ),
                                TitleTextFormField(
                                  isRequired: true, // MANDATORY
                                  title: "RR",
                                  keyboardType: TextInputType.name,
                                  hintText: 'Enter RR',
                                  initialValue: traumaController
                                              .trauma.value.traumaValues?.rr !=
                                          null
                                      ? traumaController
                                          .trauma.value.traumaValues?.rr
                                          .toString()
                                      : "",
                                  onChanged: (value) {
                                    traumaController
                                        .trauma.value.traumaValues?.rr = value;
                                    traumaController.updateRr(value.toString());
                                    //traumaController.trauma.refresh();
                                  },
                                ),
                                TitleTextFormField(
                                  isRequired: true, // MANDATORY (calculated)
                                  readOnly: true,
                                  filled: true,
                                  fillColor: traumaController.traumaColor ==
                                          'red'
                                      ? Colors.red
                                      : traumaController.traumaColor == 'yellow'
                                          ? Colors.yellow
                                          : traumaController.traumaColor ==
                                                  'green'
                                              ? Colors.green
                                              : Colors.white,
                                  title: "RTS",
                                  keyboardType: TextInputType.number,
                                  hintText: 'Enter RTS',
                                  controller: TextEditingController(
                                      text: traumaController.totalTraumaScore
                                          .toString()),
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaValues
                                        ?.rtsAutogenerate = double.parse(value);
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please Enter RTS';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                                Space(
                                  height: 10,
                                ),
                                NewTitleDropdown(
                                  isRequired: true, // MANDATORY
                                  title: 'Trauma Flag',
                                  items:
                                      traumaController.traumaLookup.value.flag
                                              ?.map((e) => {
                                                    "id": e.id ?? "",
                                                    "name": e.name ?? "",
                                                  })
                                              .toList() ??
                                          [],
                                  selectedId: traumaController
                                      .trauma.value.traumaValues?.traumaFlag,
                                  hint: 'Select Flag',
                                  onChanged: (value) async {
                                    traumaController.trauma.value.traumaValues
                                        ?.traumaFlag = value;
                                  },
                                ),
                                NewTitleYesRadio(
                                  isRequired: false, // MANDATORY
                                  title: 'ECG',
                                  initialValue: traumaController
                                      .trauma.value.traumaValues?.ecg,
                                  onChanged: (value) {
                                    traumaController
                                        .trauma.value.traumaValues?.ecg = value;
                                    print(traumaController
                                        .trauma.value.traumaValues?.ecg);
                                    traumaController.trauma.refresh();
                                    print(
                                        'ECG: ${traumaController.trauma.value.traumaValues?.ecg}');
                                  },
                                ),
                                if (traumaController
                                        .trauma.value.traumaValues?.ecg ==
                                    true)
                                  Obx(() => Column(
                                        children: [
                                          // Note: ECG findings is commented out in validation
                                          // TitleTextFormField(
                                          //   title: 'Findings',
                                          //   controller: TextEditingController(
                                          //     text: traumaController
                                          //         .trauma
                                          //         .value
                                          //         .traumaValues
                                          //         ?.ecgfindings,
                                          //   ),
                                          //   onChanged: (value) {
                                          //     traumaController
                                          //         .trauma
                                          //         .value
                                          //         .traumaValues
                                          //         ?.ecgfindings = value;
                                          //   },
                                          //   keyboardType: TextInputType.name,
                                          //   hintText: 'Enter Findings',
                                          //   validator: (value) {
                                          //     if (value == null) {
                                          //       return 'Please Enter Findings';
                                          //     } else {
                                          //       return null;
                                          //     }
                                          //   },
                                          // ),
                                        ],
                                      )),
                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'XRay',
                                  initialValue: traumaController
                                      .trauma.value.traumaValues?.xray,
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaValues
                                        ?.xray = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                            .trauma.value.traumaValues?.xray !=
                                        null &&
                                    traumaController
                                            .trauma.value.traumaValues?.xray ==
                                        true)
                                  Column(
                                    children: [
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY when XRay is Yes
                                        title: 'Date & Time',
                                        dateTime: traumaController.trauma.value
                                            .traumaValues?.xrayDateTime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaValues
                                              ?.xrayDateTime = value;
                                        },
                                      ),
                                      Space(
                                        height: 10,
                                      ),
                                      // TitleTextFormField(
                                      //   title: 'Findings',
                                      //   controller: TextEditingController(
                                      //     text: traumaController.trauma.value
                                      //         .traumaValues?.xrayfindings,
                                      //   ),
                                      //   onChanged: (value) {
                                      //     traumaController
                                      //         .trauma
                                      //         .value
                                      //         .traumaValues
                                      //         ?.xrayfindings = value;
                                      //   },
                                      //   keyboardType: TextInputType.name,
                                      //   hintText: 'Enter Findings',
                                      //   validator: (value) {
                                      //     if (value == null) {
                                      //       return 'Please Enter Findings';
                                      //     } else {
                                      //       return null;
                                      //     }
                                      //   },
                                      // ),
                                    ],
                                  ),
                                NewTitleYesRadio(
                                  title: 'EFAST',
                                  isRequired: true,
                                  initialValue: traumaController
                                      .trauma.value.traumaValues?.efast,
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaValues
                                        ?.efast = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                            .trauma.value.traumaValues?.efast !=
                                        null &&
                                    traumaController
                                            .trauma.value.traumaValues?.efast ==
                                        true)
                                  Column(
                                    children: [
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY when EFAST is Yes
                                        title: 'Date & Time',
                                        dateTime: traumaController.trauma.value
                                            .traumaValues?.efastDateTime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaValues
                                              ?.efastDateTime = value;
                                        },
                                      ),
                                      Space(
                                        height: 10,
                                      ),
                                      // TitleTextFormField(
                                      //   title: 'Findings',
                                      //   controller: TextEditingController(
                                      //     text: traumaController.trauma.value
                                      //         .traumaValues?.efastfindings,
                                      //   ),
                                      //   onChanged: (value) {
                                      //     traumaController
                                      //         .trauma
                                      //         .value
                                      //         .traumaValues
                                      //         ?.efastfindings = value;
                                      //   },
                                      //   keyboardType: TextInputType.name,
                                      //   hintText: 'Enter Findings',
                                      //   validator: (value) {
                                      //     if (value == null) {
                                      //       return 'Please Enter Findings';
                                      //     } else {
                                      //       return null;
                                      //     }
                                      //   },
                                      // ),
                                    ],
                                  ),
                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'CT',
                                  initialValue: traumaController
                                      .trauma.value.traumaValues?.ct,
                                  onChanged: (value) {
                                    traumaController
                                        .trauma.value.traumaValues?.ct = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                            .trauma.value.traumaValues?.ct !=
                                        null &&
                                    traumaController
                                            .trauma.value.traumaValues?.ct ==
                                        true)
                                  Column(
                                    children: [
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY when CT is Yes
                                        title: 'Date & Time',
                                        dateTime: traumaController.trauma.value
                                            .traumaValues?.ctDateTime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController.trauma.value
                                              .traumaValues?.ctDateTime = value;
                                        },
                                      ),
                                      Space(
                                        height: 10,
                                      ),
                                      // TitleTextFormField(
                                      //   title: 'Findings',
                                      //   controller: TextEditingController(
                                      //     text: traumaController.trauma.value
                                      //         .traumaValues?.ctfindings,
                                      //   ),
                                      //   onChanged: (value) {
                                      //     traumaController.trauma.value
                                      //         .traumaValues?.ctfindings = value;
                                      //   },
                                      //   keyboardType: TextInputType.name,
                                      //   hintText: 'Enter Findings',
                                      //   validator: (value) {
                                      //     if (value == null) {
                                      //       return 'Please Enter Findings';
                                      //     } else {
                                      //       return null;
                                      //     }
                                      //   },
                                      // ),
                                    ],
                                  ),
                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'MRI',
                                  initialValue: traumaController
                                      .trauma.value.traumaValues?.mri,
                                  onChanged: (value) {
                                    traumaController
                                        .trauma.value.traumaValues?.mri = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                            .trauma.value.traumaValues?.mri !=
                                        null &&
                                    traumaController
                                            .trauma.value.traumaValues?.mri ==
                                        true)
                                  Column(
                                    children: [
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY when MRI is Yes
                                        title: 'Date & Time',
                                        dateTime: traumaController.trauma.value
                                            .traumaValues?.mriDateTime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaValues
                                              ?.mriDateTime = value;
                                        },
                                      ),
                                      Space(
                                        height: 10,
                                      ),
                                      // TitleTextFormField(
                                      //   title: 'Findings',
                                      //   controller: TextEditingController(
                                      //     text: traumaController.trauma.value
                                      //         .traumaValues?.mrifindings,
                                      //   ),
                                      //   onChanged: (value) {
                                      //     traumaController
                                      //         .trauma
                                      //         .value
                                      //         .traumaValues
                                      //         ?.mrifindings = value;
                                      //   },
                                      //   keyboardType: TextInputType.name,
                                      //   hintText: 'Enter Findings',
                                      //   validator: (value) {
                                      //     if (value == null) {
                                      //       return 'Please Enter Findings';
                                      //     } else {
                                      //       return null;
                                      //     }
                                      //   },
                                      // ),
                                    ],
                                  ),
                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'ABG',
                                  initialValue: traumaController
                                      .trauma.value.traumaValues?.abg,
                                  onChanged: (value) {
                                    traumaController
                                        .trauma.value.traumaValues?.abg = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                            .trauma.value.traumaValues?.abg !=
                                        null &&
                                    traumaController
                                            .trauma.value.traumaValues?.abg ==
                                        true)
                                  Column(
                                    children: [
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY when ABG is Yes
                                        title: 'Date & Time',
                                        dateTime: traumaController.trauma.value
                                            .traumaValues?.abgDateTime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaValues
                                              ?.abgDateTime = value;
                                        },
                                      ),
                                      Space(
                                        height: 10,
                                      ),
                                      TitleTextFormField(
                                        title: 'Findings',
                                        hintText: 'Enter Findings',
                                        controller: TextEditingController(
                                          text: traumaController.trauma.value
                                              .traumaValues?.abgfindings,
                                        ),
                                      ),
                                    ],
                                  ),
                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'Blood Investigation',
                                  initialValue: traumaController.trauma.value
                                      .traumaValues?.bloodInvestigation,
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaValues
                                        ?.bloodInvestigation = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController.trauma.value.traumaValues
                                        ?.bloodInvestigation ==
                                    true)
                                  Column(
                                    children: [
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY when Blood Investigation is Yes
                                        title: 'Date & Time',
                                        dateTime: traumaController.trauma.value
                                            .traumaValues?.bloodDateTime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaValues
                                              ?.bloodDateTime = value;
                                        },
                                      ),
                                    ],
                                  ),
                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'HCG',
                                  initialValue: traumaController
                                      .trauma.value.traumaValues?.hcg,
                                  onChanged: (value) {
                                    traumaController
                                        .trauma.value.traumaValues?.hcg = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                        .trauma.value.traumaValues?.hcg ==
                                    true)
                                  Column(
                                    children: [
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY when HCG is Yes
                                        title: 'Date & Time',
                                        dateTime: traumaController.trauma.value
                                            .traumaValues?.hcgDateTime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaValues
                                              ?.hcgDateTime = value;
                                        },
                                      ),
                                    ],
                                  ),
                                NewTitleYesRadio(
                                  title: 'Urine Test',
                                  initialValue: traumaController
                                      .trauma.value.traumaValues?.urineTest,
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaValues
                                        ?.urineTest = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                        .trauma.value.traumaValues?.urineTest ==
                                    true)
                                  Column(
                                    children: [
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY when Urine Test is Yes
                                        title: 'Date & Time',
                                        dateTime: traumaController.trauma.value
                                            .traumaValues?.urineDateTime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaValues
                                              ?.urineDateTime = value;
                                        },
                                      ),
                                    ],
                                  ),
                                TitleTextFormField(
                                  title: "Other Tests",
                                  controller: TextEditingController(
                                    text: traumaController
                                        .trauma.value.traumaValues?.othSpecify,
                                  ),
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaValues
                                        ?.othSpecify = value;
                                  },
                                  hintText: 'Enter Tests',
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please Enter Tests';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                // Note: Other tests date time is required when Other Tests field has value
                                Column(
                                  children: [
                                    CommonDateTimeWidget(
                                      title: 'Other Tests Date & Time',
                                      dateTime: traumaController.trauma.value
                                          .traumaValues?.othDateTime
                                          .toString(),
                                      onChanged: (value) {
                                        traumaController.trauma.value
                                            .traumaValues?.othDateTime = value;
                                      },
                                    ),
                                  ],
                                ),
                                NewCheckboxList(
                                  isRequired:
                                      true, // MANDATORY (Step 1 section)
                                  title: 'Speciality Opinion',
                                  options: traumaController.traumaLookup.value
                                          .specialityOpinion ??
                                      [],
                                  initialSelectedIndexes: traumaController
                                          .trauma
                                          .value
                                          .traumaFinal
                                          ?.specialityOpinion ??
                                      [],
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaFinal
                                        ?.specialityOpinion = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                              ],
                            )
                          : Column(
                              spacing: 12,
                              children: [
                                Center(
                                  child: Text(
                                    'Procedure Done',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'CPR Done ( Near Death Resuscitation)',
                                  initialValue: traumaController
                                      .trauma.value.traumaFinal?.iscpr,
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaFinal
                                        ?.iscpr = value;
                                    traumaController.trauma.refresh();
                                    print(
                                        'Cpr ${traumaController.trauma.value.traumaFinal?.iscpr}');
                                  },
                                ),
                                Space(
                                  height: 10,
                                ),
                                traumaController
                                            .trauma.value.traumaFinal?.iscpr ==
                                        true
                                    ? Column(children: [
                                        NewTitleDropdown(
                                            isRequired:
                                                true, // MANDATORY when CPR is Yes
                                            title:
                                                'CPR On Arrival/ CPR During Hospital Stay',
                                            hint:
                                                'Select CPR On Arrival/ CPR During Hospital Stay',
                                            items: traumaController
                                                    .traumaLookup.value.cpr
                                                    ?.map((e) => {
                                                          "id": e.id,
                                                          "name": e.name
                                                        })
                                                    .toList() ??
                                                [],
                                            selectedId: traumaController.trauma
                                                .value.traumaFinal?.cprDone,
                                            onChanged: (value) {
                                              traumaController.trauma.value
                                                  .traumaFinal?.cprDone = value;
                                            })
                                      ])
                                    : SizedBox(),
                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'Blood Transfusion Done',
                                  initialValue: traumaController.trauma.value
                                      .traumaFinal?.bloodTransfusionDone,
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaFinal
                                        ?.bloodTransfusionDone = value;
                                  },
                                ),
                                Space(
                                  height: 10,
                                ),
                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'On arrival Nerve Blocks ',
                                  initialValue: traumaController.trauma.value
                                      .traumaFinal?.onArrivalNerveBlocks,
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaFinal
                                        ?.onArrivalNerveBlocks = value;
                                  },
                                ),
                                Space(
                                  height: 10,
                                ),
                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'Mechanical Ventilation',
                                  initialValue: traumaController
                                      .trauma.value.traumaFinal?.mechIntubation,
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaFinal
                                        ?.mechIntubation = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),

                                /// Step 2: If Yes → CPAP / ET Intubation
                                Obx(() => traumaController.trauma.value
                                            .traumaFinal?.mechIntubation ==
                                        true
                                    ? NewTitleDropdown(
                                        isRequired:
                                            true, // MANDATORY when Mechanical Ventilation is Yes
                                        title: 'Intubation Type',
                                        items: traumaController.traumaLookup
                                            .value.mechIntubationDtls!
                                            .map((e) =>
                                                {"id": e.id, "name": e.name})
                                            .toList(),
                                        selectedId: traumaController
                                            .trauma
                                            .value
                                            .traumaFinal
                                            ?.mechIntubationDtls,
                                        hint: 'Select Type',
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaFinal
                                              ?.mechIntubationDtls = value;
                                          traumaController.trauma.refresh();
                                        },
                                      )
                                    : SizedBox()),

                                /// Step 3: If ET Intubation → First pass Yes/No
                                Obx(() => traumaController.trauma.value
                                            .traumaFinal?.mechIntubationDtls ==
                                        2
                                    ? NewTitleYesRadio(
                                        isRequired:
                                            true, // MANDATORY when ET Intubation
                                        title: 'First Pass Intubation',
                                        initialValue: traumaController
                                            .trauma
                                            .value
                                            .traumaFinal
                                            ?.firstPassIntubation,
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaFinal
                                              ?.firstPassIntubation = value;
                                        },
                                      )
                                    : SizedBox()),

                                NewCustomRadioList(
                                    isRequired: true,
                                    title: 'Other Procedure Done',
                                    options: traumaController.traumaLookup.value
                                            .othProcedureDone ??
                                        [],
                                    initialId: traumaController.trauma.value
                                        .traumaFinal?.otherProcedureDone,
                                    onChanged: (value) {
                                      traumaController.trauma.value.traumaFinal
                                          ?.otherProcedureDone = value;
                                      traumaController.trauma.refresh();
                                    }),

                                /// Step 4: If Other Procedure Done → Others Specify
                                traumaController.trauma.value.traumaFinal
                                            ?.otherProcedureDone ==
                                        18
                                    ? TitleTextFormField(
                                        isRequired:
                                            true, // MANDATORY when Others is selected
                                        title: "Others",
                                        controller: TextEditingController(
                                          text: traumaController.trauma.value
                                              .traumaFinal?.othProcedureDone,
                                        ),
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaFinal
                                              ?.othProcedureDone = value;
                                        },
                                        keyboardType: TextInputType.name,
                                        hintText: 'Enter Others',
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please Enter Others';
                                          } else {
                                            return null;
                                          }
                                        },
                                      )
                                    : SizedBox(),

                                Space(
                                  height: 10,
                                ),
                                TitleTextFormField(
                                  isRequired: true, // MANDATORY
                                  title: "Final Diagnosis",
                                  controller: TextEditingController(
                                    text: traumaController.trauma.value
                                        .traumaFinal?.finalDiagnosis,
                                  ),
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaFinal
                                        ?.finalDiagnosis = value;
                                  },
                                  keyboardType: TextInputType.name,
                                  hintText: 'Enter Final Diagnosis',
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please Enter Final Diagnosis';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),

                                NewTitleDropdown(
                                  isRequired: true, // MANDATORY
                                  title: 'Management',
                                  items: traumaController
                                          .traumaLookup.value.management
                                          ?.map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList() ??
                                      [],
                                  selectedId: traumaController
                                      .trauma.value.traumaFinal?.management,
                                  hint: 'Select Flag',
                                  onChanged: (value) async {
                                    traumaController.trauma.value.traumaFinal
                                        ?.management = value;
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                        .trauma.value.traumaFinal?.management ==
                                    2)
                                  Column(
                                    spacing: 12,
                                    children: [
                                      NewTitleDropdown(
                                          isRequired:
                                              true, // MANDATORY for Surgery
                                          title: 'Surgery Type',
                                          hint: 'Select Surgery Type',
                                          items: traumaController.traumaLookup
                                                  .value.typeOfSurgery
                                                  ?.map((e) => {
                                                        "id": e.id,
                                                        "name": e.name
                                                      })
                                                  .toList() ??
                                              [],
                                          selectedId: traumaController.trauma
                                              .value.traumaFinal?.typeOfSurgery,
                                          onChanged: (value) {
                                            traumaController
                                                .trauma
                                                .value
                                                .traumaFinal
                                                ?.typeOfSurgery = value;
                                          }),
                                      NewTitleDropdown(
                                          isRequired:
                                              true, // MANDATORY for Surgery
                                          hint: 'Select Surgery Type',
                                          title: "Surgery Type (Major/Minor)",
                                          items: [
                                            {"id": 1, "name": "Major"},
                                            {"id": 2, "name": "Minor"},
                                          ],
                                          selectedId: traumaController.trauma
                                              .value.traumaFinal?.surgeryType,
                                          onChanged: (value) {
                                            traumaController
                                                .trauma
                                                .value
                                                .traumaFinal
                                                ?.surgeryType = value;
                                          }),

                                      TitleTextFormField(
                                        isRequired:
                                            true, // MANDATORY for Surgery
                                        title: "Surgery Name",
                                        keyboardType: TextInputType.name,
                                        hintText: 'Enter Procedure',
                                        initialValue: traumaController.trauma
                                            .value.traumaFinal?.surgeryName,
                                        onChanged: (value) {
                                          traumaController.trauma.value
                                              .traumaFinal?.surgeryName = value;
                                        },
                                        validator: (value) {
                                          if (value == null) {
                                            return 'Please Enter Procedure';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),

                                      ///Date & time  of Surgery Done
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY for Surgery
                                        title: 'Date & time  of Surgery Done',
                                        dateTime: traumaController
                                            .trauma.value.traumaFinal?.dateTime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController.trauma.value
                                              .traumaFinal?.dateTime = value;
                                        },
                                      ),

                                      ///Surgery Takenup Within(From Incident Time)
                                      TitleTextFormField(
                                        isRequired: true,
                                        title:
                                            'Surgery Takenup Within(From Incident Time) ',
                                        keyboardType: TextInputType.number,
                                        hintText:
                                            'Enter Surgery Takenup Within(From Incident Time)',
                                        initialValue: traumaController
                                                .trauma
                                                .value
                                                .traumaFinal
                                                ?.surgeryTakenupFromIncidentDate
                                                ?.toString() ??
                                            '',
                                        onChanged: (value) {
                                          traumaController
                                                  .trauma
                                                  .value
                                                  .traumaFinal
                                                  ?.surgeryTakenupFromIncidentDate =
                                              int.parse(value);
                                        },
                                      ),

                                      ///Surgery Takenup Within(From Triage)
                                      TitleTextFormField(
                                        isRequired: true,
                                        title:
                                            'Surgery Takenup Within(From Triage) ',
                                        initialValue: traumaController
                                                .trauma
                                                .value
                                                .traumaFinal
                                                ?.surgeryTakenupFromTriageDate
                                                ?.toString() ??
                                            '',
                                        keyboardType: TextInputType.number,
                                        hintText:
                                            'Enter Surgery Takenup Within(From Triage)',
                                        onChanged: (value) {
                                          traumaController
                                                  .trauma
                                                  .value
                                                  .traumaFinal
                                                  ?.surgeryTakenupFromTriageDate =
                                              int.parse(value);
                                        },
                                      ),

                                      ///Name ofSurgery Done By
                                      NewTitleDropdown(
                                          isRequired:
                                              true, // MANDATORY for Surgery
                                          title: 'Name of Speciality ',
                                          hint: 'Select Name of Speciality',
                                          items: traumaController.traumaLookup
                                                  .value.specialityOpinion
                                                  ?.map((e) => {
                                                        "id": e.id,
                                                        "name": e.name
                                                      })
                                                  .toList() ??
                                              [],
                                          selectedId: traumaController
                                              .trauma
                                              .value
                                              .traumaFinal
                                              ?.nameOfSpeciality,
                                          onChanged: (value) {
                                            traumaController
                                                .trauma
                                                .value
                                                .traumaFinal
                                                ?.nameOfSpeciality = value;
                                          }),

                                      /// Done By TextField
                                      TitleTextFormField(
                                        isRequired:
                                            true, // MANDATORY for Surgery
                                        title: 'Done By ',
                                        hintText: 'Done By',
                                        initialValue: traumaController
                                            .trauma.value.traumaFinal?.doneBy,
                                        onChanged: (value) {
                                          traumaController.trauma.value
                                              .traumaFinal?.doneBy = value;
                                        },
                                      ),
                                      NewTitleDropdown(
                                          isRequired:
                                              true, // MANDATORY for Surgery
                                          title: 'Surgery Done Under',
                                          hint: 'Select Surgery Type',
                                          selectedId: traumaController
                                              .trauma
                                              .value
                                              .traumaFinal
                                              ?.surgeryDoneUnder,
                                          items: traumaController.traumaLookup
                                                  .value.surgeryDoneUnder
                                                  ?.map((e) => {
                                                        "id": e.id,
                                                        "name": e.name
                                                      })
                                                  .toList() ??
                                              [],
                                          onChanged: (value) {
                                            traumaController
                                                .trauma
                                                .value
                                                .traumaFinal
                                                ?.surgeryDoneUnder = value;
                                          }),
                                    ],
                                  ),

                                NewTitleYesRadio(
                                  isRequired: true,
                                  title: 'Rehabilitation Required',
                                  initialValue: traumaController.trauma.value
                                      .traumaFinal?.rehabilitationRequired,
                                  onChanged: (value) {
                                    traumaController.trauma.value.traumaFinal
                                        ?.rehabilitationRequired = value;
                                  },
                                ),
                                NewTitleDropdown(
                                  isRequired: true,
                                  title: 'Outcome',
                                  items: traumaController
                                          .traumaLookup.value.outcome
                                          ?.map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList() ??
                                      [],
                                  selectedId: traumaController
                                      .trauma.value.traumaOutcome?.outcome,
                                  hint: 'Select status',
                                  onChanged: (value) async {
                                    traumaController.trauma.value.traumaOutcome
                                        ?.outcome = value;
                                    print(value);
                                    traumaController.trauma.refresh();
                                  },
                                ),
                                if (traumaController
                                        .trauma.value.traumaOutcome?.outcome ==
                                    9)
                                  Column(
                                    spacing: 12,
                                    children: [
                                      Text(
                                        'Referred to other Hospital',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      NewTitleDropdown(
                                        title: 'Hospital Type',
                                        items: traumaController
                                                .traumaLookup.value.hospitalType
                                                ?.map((e) => {
                                                      "id": e.id,
                                                      "name": e.name
                                                    })
                                                .toList() ??
                                            [],
                                        selectedId: traumaController.trauma
                                            .value.traumaOutcome?.hospitalType,
                                        hint: 'Select status',
                                        onChanged: (value) async {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaOutcome
                                              ?.hospitalType = value;
                                          traumaController.trauma.refresh();
                                        },
                                      ),
                                      if (traumaController.trauma.value
                                              .traumaOutcome?.hospitalType ==
                                          1)
                                        NewTitleDropdown(
                                          title: 'Destination hospital',
                                          items: hospitalController.hospitalList
                                                  .map((e) => {
                                                        "hospitalid":
                                                            e.hospitalid ?? "",
                                                        "hospitalname":
                                                            e.hospitalname ??
                                                                "",
                                                      })
                                                  .toList() ??
                                              [],
                                          selectedId: traumaController
                                              .trauma
                                              .value
                                              .traumaOutcome
                                              ?.destinationTaeiHospital,
                                          hint: 'Select status',
                                          onChanged: (value) async {
                                            traumaController
                                                    .trauma
                                                    .value
                                                    .traumaOutcome
                                                    ?.destinationTaeiHospital =
                                                value;
                                          },
                                        ),
                                      if (traumaController.trauma.value
                                              .traumaOutcome?.hospitalType ==
                                          2)
                                        TitleTextFormField(
                                          title:
                                              "Destination Non TAEI hospital",
                                          keyboardType: TextInputType.name,
                                          controller: TextEditingController(
                                              text: traumaController
                                                  .trauma
                                                  .value
                                                  .traumaOutcome
                                                  ?.destinationHospital),
                                          onChanged: (value) {
                                            traumaController
                                                .trauma
                                                .value
                                                .traumaOutcome
                                                ?.destinationHospital = value;
                                          },
                                          hintText:
                                              'Enter Destination Non TAEI hospital',
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please Enter Destination Non TAEI hospital';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      NewTitleDropdown(
                                        title: 'Reason for referral',
                                        items: traumaController.traumaLookup
                                                .value.reasonForReferral
                                                ?.map((e) => {
                                                      "id": e.id,
                                                      "name": e.name
                                                    })
                                                .toList() ??
                                            [],
                                        selectedId: traumaController
                                            .trauma
                                            .value
                                            .traumaOutcome
                                            ?.reasonForReferral,
                                        hint: 'Select status',
                                        onChanged: (value) async {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaOutcome
                                              ?.reasonForReferral = value;
                                          traumaController.trauma.refresh();
                                        },
                                      ),
                                      if (traumaController
                                              .trauma
                                              .value
                                              .traumaOutcome
                                              ?.reasonForReferral ==
                                          3)
                                        TitleTextFormField(
                                          title: "Other Specify",
                                          controller: TextEditingController(),
                                          keyboardType: TextInputType.name,
                                          hintText: 'Enter Reason',
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please Enter Reason';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      NewTitleDropdown(
                                        title: 'Condition of patient',
                                        items: traumaController.traumaLookup
                                                .value.conditionOfPatient
                                                ?.map((e) => {
                                                      "id": e.id ?? "",
                                                      "name": e.name ?? "",
                                                    })
                                                .toList() ??
                                            [],
                                        selectedId: traumaController
                                            .trauma
                                            .value
                                            .traumaOutcome
                                            ?.conditionOfPatient,
                                        hint: 'Select status',
                                        onChanged: (value) async {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaOutcome
                                              ?.conditionOfPatient = value;
                                        },
                                      ),
                                      TitleTextFormField(
                                        controller: TextEditingController(
                                            text: traumaController
                                                .trauma
                                                .value
                                                .traumaOutcome
                                                ?.referringDoctorName),
                                        title: "Referring Doctor",
                                        keyboardType: TextInputType.name,
                                        hintText: 'Enter Doctor Name',
                                        onChanged: (value) async {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaOutcome
                                              ?.referringDoctorName = value;
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
                                          isRequired:
                                              true, // MANDATORY for Referral
                                          title:
                                              'Whether details documented in TAEI Case sheet',
                                          initialValue: traumaController
                                              .trauma
                                              .value
                                              .traumaOutcome
                                              ?.taeiCaseDocumented,
                                          onChanged: (value) async {
                                            traumaController
                                                .trauma
                                                .value
                                                .traumaOutcome
                                                ?.taeiCaseDocumented = value;
                                          }),

                                      /// Name Of Doctor
                                      TitleTextFormField(
                                          isRequired:
                                              true, // MANDATORY for Referral
                                          title: 'Name Of Doctor',
                                          controller: TextEditingController(
                                              text: traumaController
                                                  .trauma
                                                  .value
                                                  .traumaOutcome
                                                  ?.nameOfDoctor),
                                          onChanged: (value) async {
                                            traumaController
                                                .trauma
                                                .value
                                                .traumaOutcome
                                                ?.nameOfDoctor = value;
                                          }),

                                      /// stayed_duration
                                      TitleTextFormField(
                                        title: 'Stayed Duration',
                                        controller: TextEditingController(
                                            text: traumaController
                                                        .trauma
                                                        .value
                                                        .traumaOutcome
                                                        ?.stayedDuration
                                                        .toString() ==
                                                    'null'
                                                ? ''
                                                : traumaController
                                                    .trauma
                                                    .value
                                                    .traumaOutcome
                                                    ?.stayedDuration
                                                    .toString()),
                                        onChanged: (value) async {
                                          traumaController
                                                  .trauma
                                                  .value
                                                  .traumaOutcome
                                                  ?.stayedDuration =
                                              int.parse(value);
                                        },
                                      ),
                                    ],
                                  ),
                                if (traumaController.trauma.value.traumaOutcome?.outcome == 2 ||
                                    traumaController.trauma.value.traumaOutcome
                                            ?.outcome ==
                                        3 ||
                                    traumaController.trauma.value.traumaOutcome
                                            ?.outcome ==
                                        4 ||
                                    traumaController.trauma.value.traumaOutcome
                                            ?.outcome ==
                                        5 ||
                                    traumaController.trauma.value.traumaOutcome
                                            ?.outcome ==
                                        6 ||
                                    traumaController.trauma.value.traumaOutcome
                                            ?.outcome ==
                                        7 ||
                                    traumaController.trauma.value.traumaOutcome
                                            ?.outcome ==
                                        8 ||
                                    traumaController.trauma.value.traumaOutcome
                                            ?.outcome ==
                                        1)
                                  Column(
                                    spacing: 12,
                                    children: [
                                      CommonDateTimeWidget(
                                        isRequired:
                                            true, // MANDATORY for these outcomes
                                        title: 'Date & Time',
                                        dateTime: traumaController.trauma.value
                                            .traumaOutcome?.dischargeDatetime
                                            .toString(),
                                        onChanged: (value) {
                                          traumaController
                                              .trauma
                                              .value
                                              .traumaOutcome
                                              ?.dischargeDatetime = value;
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                      Space(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          traumaController.currentIndex.value == 0
                              ? Container()
                              : CommonElevatedButtonM(
                                  backgroundColor: Colors.white,
                                  text: 'Back',
                                  onPressed: () {
                                    if (traumaController.currentIndex.value ==
                                        0) {
                                    } else {
                                      traumaController.changeIndex(
                                        traumaController.currentIndex.value - 1,
                                      );
                                    }
                                  },
                                ),
                          CommonElevatedButton(
                            text: traumaController.currentIndex.value == 0
                                ? 'Next'
                                : 'Submit',
                            onPressed: () async {
                              // if (!validateTraumaForm(outcome: true)) return;

                              debugPrint(traumaController
                                  .trauma.value.traumaValues
                                  .toString());
                              log(traumaController.trauma.value.toString());
                              if (traumaController.currentIndex.value == 0) {
                                traumaController.changeIndex(1);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => SaveOrSubmitDialog(
                                    title: 'Save or Submit',
                                    content: 'Do you want to save or submit?',
                                    onSave: () async {
                                      debugPrint("test");
                                      if (!validateTraumaForm(outcome: false))
                                        return;
                                      traumaController
                                              .trauma.value.trauma?.triageId =
                                          int.parse(widget.triageId.toString());

                                      if (widget.isUpdate == true) {
                                        traumaController
                                            .trauma
                                            .value
                                            .traumaOutcome
                                            ?.isDischarged = false;
                                        await traumaController.updateTrauma(
                                          data: traumaController.trauma.value,
                                          id: widget.traumaId.toString(),
                                        );
                                        Get.back();
                                      } else {
                                        traumaController
                                            .trauma
                                            .value
                                            .traumaOutcome
                                            ?.isDischarged = false;

                                        await traumaController.createTrauma(
                                          data: traumaController.trauma.value,
                                        );
                                        Get.back();
                                      }
                                    },
                                    onSubmit: () async {
                                      if (!validateTraumaForm(outcome: true))
                                        return;
                                      traumaController
                                              .trauma.value.trauma?.triageId =
                                          int.parse(widget.triageId.toString());

                                      if (widget.isUpdate == true) {
                                        traumaController.trauma.value
                                            .traumaOutcome?.isDischarged = true;
                                        await traumaController.updateTrauma(
                                          data: traumaController.trauma.value,
                                          id: widget.traumaId.toString(),
                                        );
                                        Get.back();
                                      } else {
                                        traumaController.trauma.value
                                            .traumaOutcome?.isDischarged = true;

                                        await traumaController.createTrauma(
                                            data:
                                                traumaController.trauma.value);
                                        Get.back();
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
      ),
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
