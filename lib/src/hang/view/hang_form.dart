import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/hang/controller/hang_controller.dart';
import 'package:taei_gov/src/hang/model/hanging_model.dart';
import 'package:taei_gov/src/hospital/controller/hospital_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_button.dart';
import 'package:taei_gov/utils/common/common_check_box_list.dart';
import 'package:taei_gov/utils/common/common_drop_down.dart';
import 'package:taei_gov/utils/common/date_time_common.dart';
import 'package:taei_gov/utils/common/save_submit_dialog.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/step_indicator.dart';
import 'package:taei_gov/utils/common/title_textfield.dart';
import 'package:taei_gov/utils/common/yes_or_no_radio_button.dart';
import 'package:taei_gov/utils/helpers/no_data_widget.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';
import '../../../utils/common/appbar.dart';
import '../../../utils/common/new_common_date_time_picker.dart';

class HangForm extends StatefulWidget {
  const HangForm({
    super.key,
    required this.triageId,
    required this.hangId,
    required this.isUpdate,
  });

  final int? hangId;
  final int? triageId;
  final bool isUpdate;
  //final String? dischargeStatus;

  @override
  State<HangForm> createState() => _HangFormState();
}

class _HangFormState extends State<HangForm> {
  TextEditingController dateController = TextEditingController();
  HangController controller = Get.put(HangController());
  HospitalController hospitalController = Get.put(HospitalController());
  // final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    fetchDta();
    super.initState();
  }

  fetchDta() async {
    controller.hangModel(HangingModel(
      hanging: Hanging(
        triageId: widget.triageId,
      ),
      outcome: Outcome(),
    ));
    controller.hangModel.value!.hanging!.dateTimeOfEntry =
        DateTime.now().toString();
    Future.delayed(Duration.zero, () async {
      await hospitalController.getHospitalListData();
      await controller.getLookup();
      if (widget.isUpdate) {
        await controller.getHangById(widget.hangId.toString());
      }
    });
  }


  bool validateHangingForm({required bool outcome}) {
    final hanging = controller.hangModel.value;

    // Step 0: Details of Hanging Validation
    if (controller.currentIndex.value == 0) {
      if (hanging?.hanging?.patientAdmitted == null) {
        showValidationError("Please specify if patient was admitted");
        return false;
      }

      // If admitted is true, additional fields are required
      if (hanging?.hanging?.patientAdmitted == true) {
        if (hanging?.hanging?.nameOfDept == null ||
            hanging?.hanging!.nameOfDept! == "") {
          showValidationError("Name of The Admitting Department is required");
          return false;
        }

        if (hanging?.hanging?.dateOfAdmit == null) {
          showValidationError("Date of Admission is required");
          return false;
        }
      }

      if (hanging?.hanging?.natureOfIncident == null) {
        showValidationError("Nature of incident is required");
        return false;
      }

      if (hanging?.hanging?.suspensionOfBody == null) {
        showValidationError("Suspension of Body is required");
        return false;
      }

      if (hanging?.hanging?.materialsUsedForHanging == null) {
        showValidationError("Materials used for hanging is required");
        return false;
      }

      if (hanging?.hanging?.symptomsAtPresentation == null ||
          hanging?.hanging!.symptomsAtPresentation! == "") {
        showValidationError("Please select at least one symptom at presentation");
        return false;
      }
    }
    // Step 1: Treatment & Management Validation
    else if (controller.currentIndex.value == 1) {
      if (hanging?.hanging?.interventions == null) {
        showValidationError("Intervention is required");
        return false;
      }

      // If intervention is "Other" (id: 3), validate other specification
      if (hanging?.hanging?.interventions == 3 &&
          (hanging?.hanging?.othInterventions == null ||
              hanging?.hanging!.othInterventions! == "")) {
        showValidationError(
            "Please specify intervention when selecting 'Other'");
        return false;
      }

      if (hanging?.hanging?.supportiveCareProvided == null) {
        showValidationError("Supportive care provided is required");
        return false;
      }

      // // If supportive care is "Other" (id: 4), validate other specification
      if (hanging?.hanging?.supportiveCareProvided == 4 &&
          (hanging?.hanging?.othSupportiveCareProvided == null ||
              hanging?.hanging!.othSupportiveCareProvided! == "")) {
        showValidationError(
            "Please specify supportive care is a mandatory");
        return false;
      }

      if (hanging?.hanging?.isCounsellingProvided == null) {
        showValidationError(
            "Counselling provided before discharge status is required");
        return false;
      }

      // if (hanging?.hanging?.durationOfHospitalStay == null ||
      //     hanging?.hanging!.durationOfHospitalStay! <= 0) {
      //   showValidationError("Duration of hospital stay is required");
      //   return false;
      // }
    }
    // Step 2: Outcome Validation
    else if (controller.currentIndex.value == 2) {
      if (outcome == true) {
        if (hanging?.outcome?.outcome == null) {
          showValidationError("Outcome is required");
          return false;
        }

        switch (hanging?.outcome?.outcome) {
          case 1: // Discharged
          case 2: // Outcome 2
          case 3: // Outcome 3
            if (hanging?.outcome?.dischargeDate == null) {
              showValidationError("Discharge date is required");
              return false;
            }
            break;

          case 4: // Absconded
            if (hanging?.outcome?.abscondedDate == null) {
              showValidationError("Absconded date is required");
              return false;
            }
            break;

          case 5: // Death
            if (hanging?.outcome?.deathDate == null) {
              showValidationError("Date of death is required");
              return false;
            }

            if (hanging?.outcome?.causeOfDeath == null ||
                hanging?.outcome!.causeOfDeath!.isEmpty) {
              showValidationError("Cause of death is required");
              return false;
            }
            break;

          case 6: // Referred
            if (hanging?.outcome?.hospitalType == null) {
              showValidationError("Hospital type is required for referral");
              return false;
            }

            if (hanging?.outcome?.hospitalType == 1) {
              // TAEI Hospital
              if (hanging?.outcome?.destinationTaeiHospital == null) {
                showValidationError("Destination TAEI hospital is required");
                return false;
              }
            }

            if (hanging?.outcome?.reasonForReferral == null) {
              showValidationError("Reason for referral is required");
              return false;
            }

            if (hanging?.outcome?.conditionOfPatient == null) {
              showValidationError("Condition of patient at referral is required");
              return false;
            }

            if (hanging?.outcome?.referringDoctor == null ||
                hanging?.outcome!.referringDoctor! == '') {
              showValidationError("Referring doctor name is required");
              return false;
            }

            if (hanging?.outcome?.documentedTaeiSheet == null) {
              showValidationError(
                  "Documentation in TAEI case sheet status is required");
              return false;
            }
            break;
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value > 0) {
          controller.currentIndex.value -= 1; // Go back a step
          return false; // Prevent page pop
        }
        return true; // Pop if on the first step
      },
      child: Scaffold(
        backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
        //backgroundColor: Colors.white,
        appBar: CommonAppBar(
          id: widget.triageId.toString(),
          title: 'Hanging',
        ),
        body: Obx(
          () => controller.isLookupLoading.value
              ? pageLoader()
              : controller.lookupList.value == null
                  ? noDataWidget(msg: "Something went wrong")
                  : widget.isUpdate && controller.isUpdateHangLoading.value
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
                                    : Colors.transparent, // border color
                                width: 0.3 // border thickness
                                ),
                          ),
                          child: ScrollConfiguration(
                            behavior: const ScrollBehavior()
                                .copyWith(overscroll: false),
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
                                        ? 'Details of hanging'
                                        : controller.currentIndex.value == 1
                                            ? /*'Clinical Presentation'
                                  : controller.currentIndex.value == 2
                                      ? */
                                            'Treatment & Management'
                                            : 'Outcome',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Space(height: 20),
                                  FancyStepIndicator(
                                    currentIndex: controller.currentIndex,
                                    stepCount: 3,
                                  ),
                                  Space(height: 26),
                                  controller.currentIndex.value == 0
                                      ? detailWidget()
                                      : controller.currentIndex.value == 1
                                          ? /*Column(
                                    children: [
                                      // TitleTextFormField(
                                      //   title: 'Vital signs on admission',
                                      //   hintText: 'Vital signs on admission',
                                      // ),
                                      // Space(height: 20),
                                      // TitleDropdown(
                                      //     title:
                                      //         'Level of consciousness on arrival',
                                      //     hint: 'Select Level of consciousness',
                                      //     items: [
                                      //       'Alert',
                                      //       'Voice',
                                      //       'Pain',
                                      //       'Unresponsive'
                                      //     ],
                                      //     onChanged: (value) {}),
                                      // Space(height: 20),
                                      // TitleTextFormField(
                                      //   title: 'Neurological status – GCS',
                                      //   hintText: 'Neurological status – GCS',
                                      // ),
                                      // Space(height: 20),
                                    ],
                                  )
                                : controller.currentIndex.value == 2
                                    ? */
                                          treatmentWidget()
                                          : outcomeWidget(),
                                  Space(height: 26),
                                  Row(
                                    children: [
                                      controller.currentIndex.value == 0
                                          ? Container()
                                          : CommonElevatedButtonM(
                                              backgroundColor: Colors.white,
                                              text: 'Back',
                                              onPressed: () {
                                                if (controller
                                                        .currentIndex.value ==
                                                    1) {
                                                  controller
                                                      .currentIndex.value = 0;
                                                  print(controller
                                                      .currentIndex.value);
                                                } else if (controller
                                                        .currentIndex.value ==
                                                    2) {
                                                  controller
                                                      .currentIndex.value = 1;
                                                  print(controller
                                                      .currentIndex.value);
                                                } else if (controller
                                                        .currentIndex.value ==
                                                    3) {
                                                  controller
                                                      .currentIndex.value = 2;
                                                  print(controller
                                                      .currentIndex.value);
                                                }
                                              }),
                                      Spacer(),
                                      CommonElevatedButtonM(
                                          text:
                                              controller.currentIndex.value == 2
                                                  ? 'Proceed'
                                                  : 'Next',
                                        onPressed: () async {
                                          // Validate before proceeding
                                          if (!validateHangingForm(outcome: false)) {
                                            return; // Don't proceed if validation fails
                                          }

                                          if (controller.currentIndex.value == 2) {
                                            // For final step, show save/submit dialog
                                            showDialog(
                                              context: context,
                                              builder: (context) => SaveOrSubmitDialog(
                                                title: 'Save or Submit',
                                                content: 'Do you want to save or submit?',
                                                onSave: () async {
                                                  if (!validateHangingForm(outcome: false)) return;
                                                  controller.hangModel.value?.outcome?.isDischarged = false;
                                                  if (widget.isUpdate == false) {
                                                    await controller.createHang().then((v) {
                                                      if (v) {
                                                        Get.back();
                                                        Get.back();
                                                        Get.snackbar("Success", "Hanging Added Successfully",
                                                            backgroundColor: Colors.green, colorText: Colors.white);
                                                      } else {
                                                        Get.back();
                                                        Get.snackbar("Error", "Something went wrong",
                                                            backgroundColor: Colors.red, colorText: Colors.white);
                                                      }
                                                    });
                                                  } else {
                                                    await controller.updateHang().then((v) {
                                                      if (v) {
                                                        Get.back();
                                                        Get.back();
                                                        Get.snackbar("Success", "Hanging Updated Successfully",
                                                            backgroundColor: Colors.green, colorText: Colors.white);
                                                      } else {
                                                        Get.back();
                                                        Get.snackbar("Error", "Something went wrong",
                                                            backgroundColor: Colors.red, colorText: Colors.white);
                                                      }
                                                    });
                                                  }
                                                },
                                                onSubmit: () async {
                                                  if (!validateHangingForm(outcome: true)) return;
                                                  controller.hangModel.value?.outcome?.isDischarged = true;
                                                  if (widget.isUpdate == false) {
                                                    await controller.createHang().then((v) {
                                                      if (v) {
                                                        Get.back();
                                                        Get.back();
                                                        Get.snackbar("Success", "Hanging Added Successfully",
                                                            backgroundColor: Colors.green, colorText: Colors.white);
                                                      } else {
                                                        Get.back();
                                                        Get.snackbar("Error", "Something went wrong",
                                                            backgroundColor: Colors.red, colorText: Colors.white);
                                                      }
                                                    });
                                                  } else {
                                                    await controller.updateHang().then((v) {
                                                      if (v) {
                                                        Get.back();
                                                        Get.back();
                                                        Get.snackbar("Success", "Hanging Updated Successfully",
                                                            backgroundColor: Colors.green, colorText: Colors.white);
                                                      } else {
                                                        Get.back();
                                                        Get.snackbar("Error", "Something went wrong",
                                                            backgroundColor: Colors.red, colorText: Colors.white);
                                                      }
                                                    });
                                                  }
                                                },
                                              ),
                                            );
                                          } else {
                                            controller.currentIndex.value = controller.currentIndex.value + 1;
                                          }
                                        },                                          ),

                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
        ),
      ),
    );
  }

  Widget treatmentWidget() {
    return Obx(
      () => Column(
        spacing: 17,
        children: [
          NewTitleDropdown(
            isRequired:true,
              title: 'Intervention',
              hint: 'Select Intervention',
              items: controller.lookupList.value!.interventions!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId: controller.hangModel.value!.hanging!.interventions,
              onChanged: (value) {
                controller.hangModel.value!.hanging!.interventions = value;
                controller.hangModel.refresh();
              }),
          if (controller.hangModel.value!.hanging!.interventions == 3)
            TitleTextFormField(
              title: 'Intervention specify',
              hintText: 'Enter Intervention specify',
              controller: TextEditingController(
                  text: controller.hangModel.value!.hanging!.othInterventions),
              keyboardType: TextInputType.name,
              onChanged: (v) {
                controller.hangModel.value!.hanging!.othInterventions = v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Intervention specify';
                }
                return null;
              },
            ),
          NewTitleDropdown(
              isRequired: true,
              title: 'Supportive care provided',
              hint: 'Select Supportive care provided',
              items: controller.lookupList.value!.supportiveCareProvided!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId:
                  controller.hangModel.value!.hanging!.supportiveCareProvided,
              onChanged: (value) {
                controller.hangModel.value!.hanging!.supportiveCareProvided =
                    value;
                controller.hangModel.refresh();
              }),
          if (controller.hangModel.value!.hanging!.supportiveCareProvided == 4)
            TitleTextFormField(
              title: 'Supportive care specify',
              hintText: 'Enter Supportive care specify',
              controller: TextEditingController(
                  text: controller
                      .hangModel.value!.hanging!.othSupportiveCareProvided),
              keyboardType: TextInputType.name,
              onChanged: (v) {
                controller.hangModel.value!.hanging!.othSupportiveCareProvided =
                    v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Supportive care specify';
                }
                return null;
              },
            ),
          NewTitleYesRadio(
            isRequired: true,
              title: 'Counselling provided before discharge',
              initialValue:
                  controller.hangModel.value!.hanging!.isCounsellingProvided,
              onChanged: (value) {
                controller.hangModel.value!.hanging!.isCounsellingProvided =
                    value;
                controller.hangModel.refresh();
              }),
          TitleTextFormField(
            title: 'Duration of hospital stay',
            hintText: 'Enter Duration of hospital stay',
            controller: TextEditingController(
                text: controller
                            .hangModel.value!.hanging!.durationOfHospitalStay ==
                        null
                    ? ""
                    : controller
                        .hangModel.value!.hanging!.durationOfHospitalStay
                        .toString()),
            keyboardType: TextInputType.name,
            onChanged: (v) {
              if (v.isNotEmpty) {
                controller.hangModel.value!.hanging!.durationOfHospitalStay =
                    int.parse(v);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Duration';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget detailWidget() {
    return Obx(
      () => Column(
        spacing: 17,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonDateTimeWidget(
              title: 'Entry Date',
              dateTime: controller.hangModel.value!.hanging!.dateTimeOfEntry
                  .toString(),
              onChanged: (value) {
                controller.hangModel.value!.hanging!.dateTimeOfEntry = value;
              }),
          NewTitleYesRadio(
             isRequired: true,
              title: 'Patient admitted',
              initialValue:
                  controller.hangModel.value!.hanging!.patientAdmitted,
              onChanged: (value) {
                controller.hangModel.value!.hanging!.patientAdmitted = value;
                if (value) {
                  controller.hangModel.value!.hanging!.dateOfAdmit =
                      DateTime.now().toString();
                } else {
                  controller.hangModel.value!.hanging!.dateOfAdmit = null;
                }
                controller.hangModel.refresh();
              }),
          if (controller.hangModel.value!.hanging!.patientAdmitted == true)
            Column(
              spacing: 17,
              children: [
                TitleTextFormField(
                  isRequired: true,
                  title: 'Name of The Admitting Department',
                  hintText: 'Enter Name of The Admitting Department',
                  controller: TextEditingController(
                      text: controller.hangModel.value!.hanging!.nameOfDept),
                  keyboardType: TextInputType.name,
                  onChanged: (v) {
                    controller.hangModel.value!.hanging!.nameOfDept = v;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Department';
                    }
                    return null;
                  },
                ),
                // DateTimeRowPicker(
                //   dateTitle: "Date of Admission",
                //   timeTitle: "Time of Admission",
                //   apiDate: controller.hangModel.value!.hanging!.dateOfAdmit!
                //       .toString(),
                //   apiTime: controller.hangModel.value!.hanging!.dateOfAdmit ==
                //           null
                //       ? null
                //       : DateFormat('hh:mm a').format(
                //           controller.hangModel.value!.hanging!.dateOfAdmit!),
                //   onDateTimeChanged: (date) {
                //     controller.hangModel.value!.hanging!.dateOfAdmit = date;
                //   },
                // ),
                CommonDateTimeWidget(
                    isRequired: true,
                    title: 'Date of Admission',
                    dateTime: controller.hangModel.value!.hanging!.dateOfAdmit
                        .toString(),
                    onChanged: (value) {
                      controller.hangModel.value!.hanging!.dateOfAdmit = value;
                    }),
              ],
            ),
          NewTitleDropdown(
            isRequired: true,
              title: 'Nature of incident',
              hint: 'Select Nature of incident',
              items: controller.lookupList.value!.natureOfIncident!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId: controller.hangModel.value!.hanging!.natureOfIncident,
              onChanged: (value) {
                controller.hangModel.value!.hanging!.natureOfIncident = value;
                controller.hangModel.refresh();
              }),
          NewTitleDropdown(
             isRequired: true,
              title: 'Suspension of Body',
              hint: 'Select Suspension of Body',
              items: controller.lookupList.value!.suspensionOfBody!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId: controller.hangModel.value!.hanging!.suspensionOfBody,
              onChanged: (value) {
                controller.hangModel.value!.hanging!.suspensionOfBody = value;
                controller.hangModel.refresh();
              }),
          NewTitleDropdown(
             isRequired: true,
              title: 'Materials used for hanging',
              hint: 'Select Materials',
              items: controller.lookupList.value!.materialsUsed!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId:
                  controller.hangModel.value!.hanging!.materialsUsedForHanging,
              onChanged: (value) {
                controller.hangModel.value!.hanging!.materialsUsedForHanging =
                    value;
                controller.hangModel.refresh();
              }),
          NewCheckboxList(
             isRequired: true,
              title: 'Symptoms at presentation',
              options: controller.lookupList.value?.symptomsPresentation ?? [],
              initialSelectedIndexes:
                  controller.hangModel.value!.hanging!.symptomsAtPresentation ??
                      [],
              onChanged: (value) {
                controller.hangModel.value!.hanging!.symptomsAtPresentation =
                    value;
                controller.hangModel.refresh();
              }),
        ],
      ),
    );
  }

  Widget outcomeWidget() {
    return Column(
      spacing: 17,
      children: [
        NewTitleDropdown(
           isRequired: true,
            title: 'Outcome',
            hint: 'Select Outcome',
            items: controller.lookupList.value?.outcome
                    ?.map((e) => {
                          "id": e.id ?? "",
                          "name": e.name ?? "",
                        })
                    .toList() ??
                [],
            selectedId: controller.hangModel.value?.outcome?.outcome,
            onChanged: (value) {
              controller.hangModel.value?.outcome?.outcome = value;
              controller.hangModel.refresh();
            }),
        if (controller.hangModel.value?.outcome?.outcome != null &&
                controller.hangModel.value?.outcome?.outcome == 1 ||
            controller.hangModel.value?.outcome?.outcome == 3 ||
            controller.hangModel.value?.outcome?.outcome == 2)
          // DateTimeRowPicker(
          //   dateTitle: "Discharged Date",
          //   timeTitle: "Discharged Time",
          //   apiDate:
          //       controller.hangModel.value?.outcome?.dischargeDate?.toString(),
          //   apiTime: controller.hangModel.value?.outcome?.dischargeDate == null
          //       ? null
          //       : DateFormat('hh:mm a').format(
          //           controller.hangModel.value!.outcome!.dischargeDate!),
          //   onDateTimeChanged: (date) {
          //     log(date.toString());
          //     controller.hangModel.value!.outcome?.dischargeDate = date;
          //   },
          // ),
          CommonDateTimeWidget(
              title: 'Discharged Date',
              dateTime:
                  controller.hangModel.value?.outcome?.dischargeDate.toString(),
              onChanged: (value) {
                controller.hangModel.value?.outcome?.dischargeDate = value;
              }),
        if (controller.hangModel.value?.outcome?.outcome != null &&
            controller.hangModel.value?.outcome?.outcome == 4)
          // DateTimeRowPicker(
          //   dateTitle: "Absconded Date",
          //   timeTitle: "Absconded Time",
          //   apiDate:
          //       controller.hangModel.value?.outcome?.abscondedDate?.toString(),
          //   apiTime: controller.hangModel.value?.outcome?.abscondedDate == null
          //       ? null
          //       : DateFormat('hh:mm a').format(
          //           controller.hangModel.value!.outcome!.abscondedDate!),
          //   onDateTimeChanged: (date) {
          //     log(date.toString());
          //     controller.hangModel.value?.outcome?.abscondedDate = date;
          //   },
          // ),
          CommonDateTimeWidget(
              title: 'Absconded Date',
              dateTime:
                  controller.hangModel.value?.outcome?.abscondedDate.toString(),
              onChanged: (value) {
                controller.hangModel.value?.outcome?.abscondedDate = value;
              }),
        if (controller.hangModel.value?.outcome?.outcome != null &&
            controller.hangModel.value?.outcome?.outcome == 5)
          Column(
            spacing: 17,
            children: [
              // DateTimeRowPicker(
              //   dateTitle: "Death Date",
              //   timeTitle: "Death Time",
              //   apiDate:
              //       controller.hangModel.value?.outcome?.deathDate?.toString(),
              //   apiTime: controller.hangModel.value?.outcome?.deathDate == null
              //       ? null
              //       : DateFormat('hh:mm a').format(
              //           controller.hangModel.value!.outcome!.deathDate!),
              //   onDateTimeChanged: (date) {
              //     log(date.toString());
              //     controller.hangModel.value?.outcome?.deathDate = date;
              //   },
              // ),
              CommonDateTimeWidget(
                  title: 'Death Date',
                  dateTime:
                      controller.hangModel.value?.outcome?.deathDate.toString(),
                  onChanged: (value) {
                    controller.hangModel.value?.outcome?.deathDate = value;
                  }),
              TitleTextFormField(
                title: 'Cause of Death',
                controller: TextEditingController(
                    text: controller.hangModel.value?.outcome?.causeOfDeath),
                keyboardType: TextInputType.name,
                hintText: 'Enter Cause of Death',
                onChanged: (v) {
                  controller.hangModel.value?.outcome?.causeOfDeath = v;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Doctor Name';
                  } else {
                    return null;
                  }
                },
              ),
            ],
          ),
        if (controller.hangModel.value?.outcome?.outcome != null &&
            controller.hangModel.value?.outcome?.outcome == 6)
          Column(
            spacing: 18,
            children: [
              NewTitleDropdown(
                  title: 'Hospital Type',
                  hint: 'Select Hospital Type',
                  items: controller.lookupList.value?.hospitalType
                          ?.map((e) => {
                                "id": e.id ?? "",
                                "name": e.name ?? "",
                              })
                          .toList() ??
                      [],
                  selectedId: controller.hangModel.value?.outcome?.hospitalType,
                  onChanged: (value) {
                    controller.hangModel.value?.outcome?.hospitalType = value;
                    controller.hangModel.refresh();
                  }),
              if (controller.hangModel.value?.outcome?.hospitalType == 1)
                NewTitleDropdown(
                    title: 'Destination hospital',
                    hint: 'Select Destination hospital',
                    items: hospitalController.hospitalList
                            .map((e) => {
                                  "hospitalid": e.hospitalid ?? "",
                                  "hospitalname": e.hospitalname ?? "",
                                })
                            .toList() ??
                        [],
                    selectedId: controller
                        .hangModel.value?.outcome?.destinationTaeiHospital,
                    onChanged: (value) {
                      controller.hangModel.value?.outcome
                          ?.destinationTaeiHospital = value;
                      controller.hangModel.refresh();
                    }),
              if (controller.hangModel.value?.outcome?.hospitalType == 2)
                TitleTextFormField(
                  controller: TextEditingController(
                      text: controller
                          .hangModel.value?.outcome?.destinationHospital),
                  title: 'Destination Non TAEI hospital',
                  hintText: 'Enter Destination Non TAEI hospital',
                  onChanged: (value) {
                    controller.hangModel.value?.outcome?.destinationHospital =
                        value;
                  },
                ),
              NewTitleDropdown(
                  title: 'Reason for referral',
                  hint: 'Select Reason',
                  items: controller.lookupList.value?.reasonForReferral
                          ?.map((e) => {
                                "id": e.id ?? "",
                                "name": e.name ?? "",
                              })
                          .toList() ??
                      [],
                  selectedId:
                      controller.hangModel.value?.outcome?.reasonForReferral,
                  onChanged: (value) {
                    controller.hangModel.value?.outcome?.reasonForReferral =
                        value;
                    controller.hangModel.refresh();
                  }),
              NewTitleDropdown(
                  title: 'Condition of patient',
                  hint: 'Select Condition',
                  items: controller.lookupList.value?.conditionOfPatient
                          ?.map((e) => {
                                "id": e.id ?? "",
                                "name": e.name ?? "",
                              })
                          .toList() ??
                      [],
                  selectedId:
                      controller.hangModel.value?.outcome?.conditionOfPatient,
                  onChanged: (value) {
                    controller.hangModel.value?.outcome?.conditionOfPatient =
                        value;
                    controller.hangModel.refresh();
                  }),
              TitleTextFormField(
                title: 'Referring Doctor Name',
                controller: TextEditingController(
                    text: controller.hangModel.value?.outcome?.referringDoctor),
                keyboardType: TextInputType.name,
                hintText: 'Enter Doctor Name',
                onChanged: (v) {
                  controller.hangModel.value?.outcome?.referringDoctor = v;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Doctor Name';
                  } else {
                    return null;
                  }
                },
              ),
              NewTitleYesRadio(
                  title: 'Whether details documented in TAEI Case sheet',
                  initialValue:
                      controller.hangModel.value?.outcome?.documentedTaeiSheet,
                  onChanged: (value) {
                    controller.hangModel.value?.outcome?.documentedTaeiSheet =
                        value;
                    controller.hangModel.refresh();
                  }),
            ],
          )
      ],
    );
  }
}
