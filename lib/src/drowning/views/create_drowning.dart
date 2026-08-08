import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/drowning/controller/drowning_controller.dart';
import 'package:taei_gov/src/drowning/models/drowning_model.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';

import '../../../utils/common/appbar.dart';
import '../../../utils/common/common_check_box_list.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../../utils/common/date_time_common.dart';
import '../../../utils/common/m_elevate_button.dart';
import '../../../utils/common/new_common_date_time_picker.dart';
import '../../../utils/common/save_submit_dialog.dart';
import '../../../utils/common/space.dart';
import '../../../utils/common/step_indicator.dart';
import '../../../utils/common/title_textfield.dart';
import '../../../utils/common/yes_or_no_radio_button.dart';
import '../../../utils/helpers/no_data_widget.dart';
import '../../prem/controller/prem_controller.dart';

class CreateDrowning extends StatefulWidget {
  const CreateDrowning(
      {super.key,
      this.triageId,
      this.hangId,
      this.isUpdate,
      this.prem,
      this.id,
      this.refFormId,
      this.refId});
  final int? hangId;
  final int? triageId;
  final bool? isUpdate;
  final bool? prem;
  final String? id;
  final int? refFormId;
  final String? refId;

  @override
  State<CreateDrowning> createState() => _CreateDrowningState();
}

class _CreateDrowningState extends State<CreateDrowning> {
  final DrowningController controller = Get.put(DrowningController());
  final PremController controller1 = Get.put(PremController());

  @override
  void initState() {
    super.initState(); // Always call super.initState() first
    fetchData();
  }

  Future<void> fetchData() async {
    controller.drowningModel(
      DrowningModel(
        drowningCases: DrowningCases(
          triageId: widget.triageId,
          id: widget.prem == true
              ? (controller1.refId != null
                  ? int.tryParse(controller1.refId.toString())
                  : int.tryParse(widget.id.toString()))
              : null,
        ),
        drowningOutcome: DrowningOutcome(
          triageId: widget.triageId,
          id: widget.prem == true
              ? (controller1.refId != null
                  ? int.tryParse(controller1.refId.toString())
                  : int.tryParse(widget.id.toString()))
              : null,
        ),
      ),
    );

    // Set the entry date
    controller.drowningModel.value?.drowningCases?.dateTimeEntry =
        DateTime.now().toString();

    // Delay to ensure UI and controller are initialized before async calls
    Future.delayed(Duration.zero, () async {
      await controller.getLookup();

      if (widget.prem == true) {
        await controller.getDrowningByTriageId(id: widget.triageId.toString());
      }

      if (widget.isUpdate == true) {
        await controller.getDrowningByTriageId(id: widget.triageId.toString());
      }
    });
  }

  bool validateDrowningForm({required bool outcome}) {
    final drowning = controller.drowningModel.value;

    // Step 0: Details of Drowning Validation
    if (controller.currentIndex.value == 0) {
      if (drowning?.drowningCases?.patientAdmittedId == null) {
        showValidationError("Please specify if patient was admitted");
        return false;
      }

      if (drowning?.drowningCases?.patientAdmittedId == 1) {
        if (drowning?.drowningCases?.admittingDepartment == null ||
            drowning?.drowningCases!.admittingDepartment! == '') {
          showValidationError("Name of The Admitting Department is required");
          return false;
        }

        if (drowning?.drowningCases?.admissionDatetime == null) {
          showValidationError("Admission Date is required");
          return false;
        }
      }

      if (drowning?.drowningCases?.placeOfIncidentId == null) {
        showValidationError("Place of incident is required");
        return false;
      }

      // If place of incident is "Other" (id: 7), validate other specification
      if (drowning?.drowningCases?.placeOfIncidentId == 7 &&
          (drowning?.drowningCases?.otherPlace == null ||
              drowning?.drowningCases!.otherPlace == '')) {
        showValidationError("Please specify other place of incident");
        return false;
      }

      if (drowning?.drowningCases?.typeOfWaterId == null) {
        showValidationError("Type of water is required");
        return false;
      }

      // If type of water is "Other" (id: 7), validate other specification
      // if (drowning?.drowningCases?.typeOfWaterId == 7 &&
      //     (drowning?.drowningCases?.otherTypeWater == null ||
      //         drowning?.drowningCases!.otherTypeWater! == "")) {
      //   showValidationError("Please specify other type of water");
      //   return false;
      // }

      if (drowning?.drowningCases?.activityDuringDrowningId == null) {
        showValidationError("Activity during drowning is required");
        return false;
      }

      // If activity during drowning is "Other" (id: 7), validate other specification
      if (drowning?.drowningCases?.activityDuringDrowningId == 7 &&
          (drowning?.drowningCases?.otherActivity == null ||
              drowning?.drowningCases!.otherActivity! == "")) {
        showValidationError("Please specify other activity during drowning");
        return false;
      }

      // Complications at admission validation (comma-separated string)
      if (drowning?.drowningCases?.complicationsAdmission == null ||
          drowning?.drowningCases!.complicationsAdmission! == "") {
        showValidationError("Complication at admission is required");
        return false;
      }

      // If "Other" (contains "7") complication is selected, validate other specification
      if (drowning?.drowningCases?.complicationsAdmission! == "7" &&
          (drowning?.drowningCases?.otherComplicationAdmitted == null ||
              drowning?.drowningCases!.otherComplicationAdmitted! == '')) {
        showValidationError("Please specify other complication at admission");
        return false;
      }

      if (drowning?.drowningCases?.assessmentId == null) {
        showValidationError("Assessment is required");
        return false;
      }

      if (drowning?.drowningCases?.interventionId == null) {
        showValidationError("Interventions is required");
        return false;
      }

      // If intervention is "Other" (id: 3), validate other specification
      if (drowning?.drowningCases?.interventionId == 3 &&
          (drowning?.drowningCases?.otherActivity == null ||
              drowning?.drowningCases!.otherActivity! == "")) {
        showValidationError("Please specify other interventions");
        return false;
      }

      // Supportive care provided validation (comma-separated string)
      if (drowning?.drowningCases?.supportiveCare == null ||
          drowning?.drowningCases!.supportiveCare! == "") {
        showValidationError("Supportive care provided is required");
        return false;
      }

      // If "Other" (contains "5") supportive care is selected, validate other specification
      if (drowning?.drowningCases!.supportiveCare! == "5" &&
          (drowning?.drowningCases?.otherSupportiveCare == null ||
              drowning?.drowningCases?.otherSupportiveCare! == "")) {
        showValidationError("Please specify other supportive care provided");
        return false;
      }

      if (drowning?.drowningCases?.counsellingBeforeDischargeId == null) {
        showValidationError(
            "Counselling provided before discharge is required");
        return false;
      }

      // if (drowning?.drowningCases?.durationOfHospitalStay == null ||
      //     drowning?.drowningCases!.durationOfHospitalStay! <= 0) {
      //   showValidationError("Duration of hospital stay is required");
      //   return false;
      // }

      // Complications developed validation (optional field, but if "Other" is selected, validate)
      if (drowning?.drowningCases?.complicationsDeveloped != null &&
          drowning?.drowningCases!.complicationsDeveloped! == "5" &&
          (drowning?.drowningCases?.otherSupportiveCare == null ||
              drowning?.drowningCases!.otherSupportiveCare! == "")) {
        showValidationError("Please specify other complications developed");
        return false;
      }
    }
    // Step 1: Outcome Validation
    else if (controller.currentIndex.value == 1) {
      // if (outcome == true) {
      //   if (drowning?.drowningOutcome?.outcomeTypeId == null) {
      //     showValidationError("Outcome is required");
      //     return false;
      //   }
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
    return Scaffold(
      backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
      appBar: CommonAppBar(
        title: 'Drowning',
      ),
      body: Obx(
        () => controller.isLookupLoading.value
            ? pageLoader()
            : controller.lookupList.value == null
                ? noDataWidget(msg: "Something went wrong")
                : (((widget.isUpdate ?? widget.prem) ?? false) &&
                        controller.isUpdateDrowningLoading.value)
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
                                      ? 'Details of Drowning'
                                      : 'Outcome',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )),
                                Space(height: 20),
                                widget.prem == true
                                    ? SizedBox()
                                    : FancyStepIndicator(
                                        currentIndex: controller.currentIndex,
                                        stepCount: 2,
                                      ),
                                Space(height: 26),
                                controller.currentIndex.value == 0
                                    ? detailWidget()
                                    : widget.prem == true
                                        ? SizedBox()
                                        : outcomeWidget(),
                                Space(height: 26),
                                Row(
                                  children: [
                                    controller.currentIndex.value == 0
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
                                              if (controller
                                                      .currentIndex.value ==
                                                  1) {
                                                controller.currentIndex.value =
                                                    0;
                                              }
                                            }),
                                    Spacer(),
                                    widget.prem == true
                                        ? Row(
                                            children: [
                                              const SizedBox(width: 20),
                                              CommonElevatedButtonM(
                                                text:
                                                    controller.notFound.value ==
                                                            false
                                                        ? 'Submit From Prem'
                                                        : 'Update From Prem',
                                                onPressed:
                                                    _showDrowningSaveSubmitDialog,
                                              ),
                                            ],
                                          )
                                        : CommonElevatedButtonM(
                                            text:
                                                controller.currentIndex.value ==
                                                        0
                                                    ? 'Next'
                                                    : widget.isUpdate == true
                                                        ? "Update"
                                                        : "Submit",
                                            onPressed: controller
                                                        .currentIndex.value ==
                                                    0
                                                ? _handleNextStep
                                                : _showDrowningSaveSubmitDialog,
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
      ),
    );
  }

  Future<void> _handleNextStep() async {
    if (!validateDrowningForm(outcome: false)) return;
    controller.currentIndex.value = 1;
  }

  void _showDrowningSaveSubmitDialog() {
    showDialog(
      context: context,
      builder: (_) => SaveOrSubmitDialog(
        title: 'Save or Submit',
        content: 'Do you want to save or submit?',
        // onSave: () => _handleStemiAction(isSubmit: true),
        // onSubmit: () => _handleStemiAction(isSubmit: false),
        onSave: () => _handleDrowningAction(isSave: true),
        onSubmit: () => _handleDrowningAction(isSave: false),
      ),
    );
  }

  Future<void> _handleDrowningAction({required bool isSave}) async {
    Get.back(); // close dialog

    if (!validateDrowningForm(outcome: false)) return;

    // 🔥 MAIN DIFFERENCE
    controller.drowningModel.value?.drowningOutcome?.is_discharged = isSave;

    controller.isDrowningLoading(true);

    final success = await controller.createDrowning();

    controller.isDrowningLoading(false);

    if (success) {
      if (widget.prem == true) {
        Get.back();
        Get.back();
      } else {
        Get.back();
        Get.snackbar(
          "Success",
          isSave
              ? "Drowning Saved Successfully"
              : "Drowning Submitted Successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handleDrowningPrem() async {
    controller.drowningModel.value?.drowningOutcome?.is_discharged = true;
    if (!validateDrowningForm(outcome: false)) return;

    controller.isDrowningLoading(true);

    final success = await controller.createDrowning();

    controller.isDrowningLoading(false);

    if (success) {
      Get.back();
      Get.back();
    } else {
      Fluttertoast.showToast(msg: "Failed to submit");
    }
  }

  Future<void> _handleDrowningNormal() async {
    if (!validateDrowningForm(outcome: false)) return;

    // Step 1 → Move to next tab
    if (controller.currentIndex.value == 0) {
      controller.currentIndex.value = 1;
      return;
    }

    // Step 2 → Final Submit / Update
    controller.isDrowningLoading(true);

    final success = await controller.createDrowning();

    controller.isDrowningLoading(false);

    if (success) {
      Get.back();
      Get.snackbar(
        "Success",
        widget.isUpdate == true
            ? "Drowning Updated Successfully"
            : "Drowning Added Successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Something went wrong",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget detailWidget() {
    return Obx(
      () => Column(
        spacing: 17,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonDateTimeWidget(
              title: 'Entry Date',
              dateTime: controller
                  .drowningModel.value!.drowningCases!.dateTimeEntry
                  .toString(),
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!.dateTimeEntry =
                    value;
              }),
          NewTitleYesRadio(
              isRequired: true,
              title: 'Patient admitted',
              initialValue: controller.drowningModel.value!.drowningCases!
                          .patientAdmittedId ==
                      null
                  ? null
                  : controller.drowningModel.value!.drowningCases!
                              .patientAdmittedId ==
                          1
                      ? true
                      : false,
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!
                    .patientAdmittedId = value == true ? 1 : 2;
                if (value) {
                  controller.drowningModel.value!.drowningCases!
                      .admissionDatetime = DateTime.now().toString();
                } else {
                  controller.drowningModel.value!.drowningCases!
                      .admissionDatetime = null;
                }
                controller.drowningModel.refresh();
              }),
          if (controller
                      .drowningModel.value!.drowningCases!.patientAdmittedId !=
                  null &&
              controller
                      .drowningModel.value!.drowningCases!.patientAdmittedId ==
                  1)
            Column(
              spacing: 17,
              children: [
                TitleTextFormField(
                  isRequired: true,
                  title: 'Name of The Admitting Department',
                  hintText: 'Enter Name of The Admitting Department',
                  controller: TextEditingController(
                      text: controller.drowningModel.value!.drowningCases!
                          .admittingDepartment),
                  keyboardType: TextInputType.name,
                  onChanged: (v) {
                    controller.drowningModel.value!.drowningCases!
                        .admittingDepartment = v;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Department';
                    }
                    return null;
                  },
                ),
                CommonDateTimeWidget(
                  isRequired: true,
                  title: 'Admission Date',
                  dateTime: controller
                      .drowningModel.value!.drowningCases!.admissionDatetime
                      .toString(),
                  onChanged: (value) {
                    controller.drowningModel.value!.drowningCases!
                        .admissionDatetime = value;
                  },
                ),
              ],
            ),
          NewTitleDropdown(
              isRequired: true,
              title: 'Place of incident',
              hint: 'Select Place of incident',
              items: controller.lookupList.value!.placeOfIncident!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId: controller
                  .drowningModel.value!.drowningCases!.placeOfIncidentId,
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!
                    .placeOfIncidentId = value;
                controller.drowningModel.refresh();
              }),
          if (controller
                      .drowningModel.value!.drowningCases!.placeOfIncidentId !=
                  null &&
              controller
                      .drowningModel.value!.drowningCases!.placeOfIncidentId ==
                  7)
            TitleTextFormField(
              title: 'Other Place of incident',
              hintText: 'Other Place of incident',
              controller: TextEditingController(
                  text: controller
                      .drowningModel.value!.drowningCases!.otherPlace),
              keyboardType: TextInputType.name,
              onChanged: (v) {
                controller.drowningModel.value!.drowningCases!.otherPlace = v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Other Place of incident';
                }
                return null;
              },
            ),
          NewTitleDropdown(
              isRequired: true,
              title: 'Type of water',
              hint: 'Select Type of water',
              items: controller.lookupList.value!.typeOfWater!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId:
                  controller.drowningModel.value!.drowningCases!.typeOfWaterId,
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!.typeOfWaterId =
                    value;
                controller.drowningModel.refresh();
              }),
          if (controller.drowningModel.value!.drowningCases!.typeOfWaterId !=
                  null &&
              controller.drowningModel.value!.drowningCases!.typeOfWaterId == 7)
            TitleTextFormField(
              title: 'Other Water Type',
              hintText: 'Other Water Type',
              controller: TextEditingController(
                  text: controller
                      .drowningModel.value!.drowningCases!.otherTypeWater),
              keyboardType: TextInputType.name,
              onChanged: (v) {
                controller.drowningModel.value!.drowningCases!.otherTypeWater =
                    v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Other Water Type';
                }
                return null;
              },
            ),
          NewTitleDropdown(
              isRequired: true,
              title: 'Activity during drowning',
              hint: 'Select Activity',
              items: controller.lookupList.value!.activityDuringDrowning!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId: controller
                  .drowningModel.value!.drowningCases!.activityDuringDrowningId,
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!
                    .activityDuringDrowningId = value;
                controller.drowningModel.refresh();
              }),
          if (controller.drowningModel.value!.drowningCases!
                      .activityDuringDrowningId !=
                  null &&
              controller.drowningModel.value!.drowningCases!
                      .activityDuringDrowningId ==
                  7)
            TitleTextFormField(
              title: 'Other Activity during drowning',
              hintText: 'Other Activity during drowning',
              controller: TextEditingController(
                  text: controller
                      .drowningModel.value!.drowningCases!.otherActivity),
              keyboardType: TextInputType.name,
              onChanged: (v) {
                controller.drowningModel.value!.drowningCases!.otherActivity =
                    v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Other Activity during drowning';
                }
                return null;
              },
            ),
          NewCheckboxList(
              isRequired: true,
              title: 'Complication at admission',
              options:
                  controller.lookupList.value?.complicationsAdmission ?? [],
              initialSelectedIndexes: controller.drowningModel.value!
                              .drowningCases!.complicationsAdmission ==
                          null ||
                      controller.drowningModel.value!.drowningCases!
                          .complicationsAdmission!.isEmpty
                  ? []
                  : controller.drowningModel.value!.drowningCases!
                      .complicationsAdmission!
                      .split(',')
                      .map((e) => int.parse(e.trim()))
                      .toList(),
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!
                    .complicationsAdmission = value.join(',');
                controller.drowningModel.refresh();
              }),
          if (controller.drowningModel.value!.drowningCases!
                      .complicationsAdmission !=
                  null &&
              controller
                  .drowningModel.value!.drowningCases!.complicationsAdmission!
                  .contains("7"))
            TitleTextFormField(
              title: 'Other Complication at admission',
              hintText: 'Other Complication at admission',
              controller: TextEditingController(
                  text: controller.drowningModel.value!.drowningCases!
                      .otherComplicationAdmitted),
              keyboardType: TextInputType.name,
              onChanged: (v) {
                controller.drowningModel.value!.drowningCases!
                    .otherComplicationAdmitted = v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Other Complication at admission';
                }
                return null;
              },
            ),
          NewTitleDropdown(
              isRequired: true,
              title: 'Assessment',
              hint: 'Select Assessment',
              items: controller.lookupList.value!.assessment!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId:
                  controller.drowningModel.value!.drowningCases!.assessmentId,
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!.assessmentId =
                    value;
                controller.drowningModel.refresh();
              }),
          NewTitleDropdown(
              isRequired: true,
              title: 'Interventions',
              hint: 'Select Interventions',
              items: controller.lookupList.value!.interventions!
                  .map((e) => {"id": e.id, "name": e.name})
                  .toList(),
              selectedId:
                  controller.drowningModel.value!.drowningCases!.interventionId,
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!.interventionId =
                    value;
                controller.drowningModel.refresh();
              }),
          if (controller.drowningModel.value!.drowningCases!.interventionId !=
                  null &&
              controller.drowningModel.value!.drowningCases!.interventionId ==
                  3)
            TitleTextFormField(
              title: 'Other Interventions',
              hintText: 'Other Interventions',
              controller: TextEditingController(
                  text: controller
                      .drowningModel.value!.drowningCases!.otherActivity),
              keyboardType: TextInputType.name,
              onChanged: (v) {
                controller.drowningModel.value!.drowningCases!.otherActivity =
                    v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Other Interventions';
                }
                return null;
              },
            ),
          NewCheckboxList(
              isRequired: true,
              title: 'Supportive care provided',
              options: controller.lookupList.value?.supportiveCare ?? [],
              initialSelectedIndexes: controller.drowningModel.value!
                              .drowningCases!.supportiveCare ==
                          null ||
                      controller.drowningModel.value!.drowningCases!
                          .supportiveCare!.isEmpty
                  ? []
                  : controller
                      .drowningModel.value!.drowningCases!.supportiveCare!
                      .split(',')
                      .map((e) => int.parse(e.trim()))
                      .toList(),
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!.supportiveCare =
                    value.join(',');
                controller.drowningModel.refresh();
              }),
          if (controller.drowningModel.value!.drowningCases!.supportiveCare !=
                  null &&
              controller.drowningModel.value!.drowningCases!.supportiveCare!
                  .contains("5"))
            TitleTextFormField(
              title: 'Other Supportive care provided',
              hintText: 'Other Supportive care provided',
              controller: TextEditingController(
                  text: controller
                      .drowningModel.value!.drowningCases!.otherSupportiveCare),
              keyboardType: TextInputType.name,
              onChanged: (v) {
                controller.drowningModel.value!.drowningCases!
                    .otherSupportiveCare = v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Other Supportive care provided';
                }
                return null;
              },
            ),
          NewTitleYesRadio(
              isRequired: true,
              title: 'Counselling provided before discharge',
              initialValue: controller.drowningModel.value!.drowningCases!
                          .counsellingBeforeDischargeId ==
                      null
                  ? null
                  : controller.drowningModel.value!.drowningCases!
                              .counsellingBeforeDischargeId ==
                          1
                      ? true
                      : false,
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!
                    .counsellingBeforeDischargeId = value == true ? 1 : 2;

                controller.drowningModel.refresh();
              }),
          TitleTextFormField(
            title: 'Duration of hospital stay',
            hintText: 'Enter Duration',
            controller: TextEditingController(
                text: controller.drowningModel.value!.drowningCases!
                            .durationOfHospitalStay ==
                        null
                    ? ""
                    : controller.drowningModel.value!.drowningCases!
                        .durationOfHospitalStay
                        .toString()),
            keyboardType: TextInputType.number,
            onChanged: (v) {
              if (v.isNotEmpty) {
                controller.drowningModel.value!.drowningCases!
                    .durationOfHospitalStay = int.parse(v);
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please Enter Duration';
              }
              return null;
            },
          ),
          NewCheckboxList(
              title: 'Complications developed',
              options:
                  controller.lookupList.value?.complicationsDeveloped ?? [],
              initialSelectedIndexes: controller.drowningModel.value!
                              .drowningCases!.complicationsDeveloped ==
                          null ||
                      controller.drowningModel.value!.drowningCases!
                          .complicationsDeveloped!.isEmpty
                  ? []
                  : controller.drowningModel.value!.drowningCases!
                      .complicationsDeveloped!
                      .split(',')
                      .map((e) => int.parse(e.trim()))
                      .toList(),
              onChanged: (value) {
                controller.drowningModel.value!.drowningCases!
                    .complicationsDeveloped = value.join(',');
                controller.drowningModel.refresh();
              }),
          if (controller.drowningModel.value!.drowningCases!
                      .complicationsDeveloped !=
                  null &&
              controller
                  .drowningModel.value!.drowningCases!.complicationsDeveloped!
                  .contains("5"))
            TitleTextFormField(
              title: 'Other Complications developed',
              hintText: 'Other Complications developed',
              controller: TextEditingController(
                  text: controller
                      .drowningModel.value!.drowningCases!.otherSupportiveCare),
              keyboardType: TextInputType.name,
              onChanged: (v) {
                controller.drowningModel.value!.drowningCases!
                    .otherSupportiveCare = v;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Complications developed';
                }
                return null;
              },
            ),
        ],
      ),
    );
  }

  Widget outcomeWidget() {
    return Column(
      spacing: 17,
      children: [
        NewTitleDropdown(
            // isRequired: true,
            title: 'Out come',
            hint: 'Select Out come',
            items: controller.lookupList.value?.outcomeType
                    ?.map((e) => {
                          "id": e.id ?? "",
                          "name": e.name ?? "",
                        })
                    .toList() ??
                [],
            selectedId:
                controller.drowningModel.value?.drowningOutcome?.outcomeTypeId,
            onChanged: (value) {
              controller.drowningModel.value?.drowningOutcome?.outcomeTypeId =
                  value;
              controller.drowningModel.refresh();
            }),
        if (controller.drowningModel.value?.drowningOutcome?.outcomeTypeId !=
                    null &&
                controller
                        .drowningModel.value?.drowningOutcome?.outcomeTypeId ==
                    1 ||
            controller.drowningModel.value?.drowningOutcome?.outcomeTypeId ==
                3 ||
            controller.drowningModel.value?.drowningOutcome?.outcomeTypeId == 2)
          // DateTimeRowPicker(
          //   dateTitle: "Discharged Date",
          //   timeTitle: "Discharged Time",
          //   apiDate: controller
          //       .drowningModel.value?.drowningOutcome?.dischargeDatetime
          //       ?.toString(),
          //   apiTime: controller.drowningModel.value?.drowningOutcome
          //               ?.dischargeDatetime ==
          //           null
          //       ? null
          //       : DateFormat('hh:mm a').format(controller.drowningModel.value!.drowningOutcome!.dischargeDatetime!.toString()),
          //   onDateTimeChanged: (date) {
          //     log(date.toString());
          //     controller.drowningModel.value!.drowningOutcome
          //         ?.dischargeDatetime = date;
          //   },
          // ),
          CommonDateTimeWidget(
            title: 'Discharge Date',
            dateTime: controller
                .drowningModel.value?.drowningOutcome?.dischargeDatetime
                ?.toString(),
            onChanged: (value) {
              controller.drowningModel.value!.drowningOutcome
                  ?.dischargeDatetime = value;
            },
          ),
        if (controller.drowningModel.value?.drowningOutcome?.outcomeTypeId !=
                null &&
            controller.drowningModel.value?.drowningOutcome?.outcomeTypeId == 4)
          DateTimeRowPicker(
            dateTitle: "Absconded Date",
            timeTitle: "Absconded Time",
            apiDate: controller
                .drowningModel.value?.drowningOutcome?.abscondedDatetime
                ?.toString(),
            apiTime: controller.drowningModel.value?.drowningOutcome
                        ?.abscondedDatetime ==
                    null
                ? null
                : DateFormat('hh:mm a').format(controller
                    .drowningModel.value!.drowningOutcome!.abscondedDatetime!),
            onDateTimeChanged: (date) {
              log(date.toString());
              controller.drowningModel.value?.drowningOutcome
                  ?.abscondedDatetime = date;
            },
          ),
        if (controller.drowningModel.value?.drowningOutcome?.outcomeTypeId !=
                null &&
            controller.drowningModel.value?.drowningOutcome?.outcomeTypeId == 5)
          Column(
            spacing: 17,
            children: [
              DateTimeRowPicker(
                dateTitle: "Death Date",
                timeTitle: "Death Time",
                apiDate: controller
                    .drowningModel.value?.drowningOutcome?.deathDatetime
                    ?.toString(),
                apiTime: controller.drowningModel.value?.drowningOutcome
                            ?.deathDatetime ==
                        null
                    ? null
                    : DateFormat('hh:mm a').format(controller
                        .drowningModel.value!.drowningOutcome!.deathDatetime!),
                onDateTimeChanged: (date) {
                  log(date.toString());
                  controller.drowningModel.value?.drowningOutcome
                      ?.deathDatetime = date;
                },
              ),
              TitleTextFormField(
                title: 'Cause of Death',
                controller: TextEditingController(
                    text: controller
                        .drowningModel.value?.drowningOutcome?.causeOfDeath),
                keyboardType: TextInputType.name,
                hintText: 'Enter Cause of Death',
                onChanged: (v) {
                  controller
                      .drowningModel.value?.drowningOutcome?.causeOfDeath = v;
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
        if (controller.drowningModel.value?.drowningOutcome?.outcomeTypeId !=
                null &&
            controller.drowningModel.value?.drowningOutcome?.outcomeTypeId == 6)
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
                  selectedId: controller
                      .drowningModel.value?.drowningOutcome?.hospitalTypeId,
                  onChanged: (value) {
                    controller.drowningModel.value?.drowningOutcome
                        ?.hospitalTypeId = value;
                    controller.drowningModel.refresh();
                  }),
              if (controller
                      .drowningModel.value?.drowningOutcome?.hospitalTypeId ==
                  1)
                NewTitleDropdown(
                    title: 'Destination hospital',
                    hint: 'Select Destination hospital',
                    items: controller.lookupList.value?.destinationHospital
                            ?.map((e) => {
                                  "id": e.id ?? "",
                                  "name": e.name ?? "",
                                })
                            .toList() ??
                        [],
                    selectedId: controller.drowningModel.value?.drowningOutcome
                        ?.destinationTaeiHospital,
                    onChanged: (value) {
                      controller.drowningModel.value?.drowningOutcome
                          ?.destinationTaeiHospital = value;
                    }),
              if (controller
                      .drowningModel.value?.drowningOutcome?.hospitalTypeId ==
                  1)
                TitleTextFormField(
                  title: 'Destination Non TAEI Hospital',
                  controller: TextEditingController(
                      text: controller.drowningModel.value?.drowningOutcome
                          ?.destinationHospital),
                  keyboardType: TextInputType.name,
                  hintText: 'Enter Destination Non TAEI Hospital Name',
                  onChanged: (v) {
                    controller.drowningModel.value?.drowningOutcome
                        ?.destinationHospital = v;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Doctor Name';
                    } else {
                      return null;
                    }
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
                  selectedId: controller
                      .drowningModel.value?.drowningOutcome?.referralReasonId,
                  onChanged: (value) {
                    controller.drowningModel.value?.drowningOutcome
                        ?.referralReasonId = value;
                    controller.drowningModel.refresh();
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
                  selectedId: controller
                      .drowningModel.value?.drowningOutcome?.patientConditionId,
                  onChanged: (value) {
                    controller.drowningModel.value?.drowningOutcome
                        ?.patientConditionId = value;
                    controller.drowningModel.refresh();
                  }),
              TitleTextFormField(
                title: 'Referring Doctor Name',
                controller: TextEditingController(
                    text: controller
                        .drowningModel.value?.drowningOutcome?.referringDoctor),
                keyboardType: TextInputType.name,
                hintText: 'Enter Doctor Name',
                onChanged: (v) {
                  controller.drowningModel.value?.drowningOutcome
                      ?.referringDoctor = v;
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
                  initialValue: controller.drowningModel.value?.drowningOutcome
                      ?.documentedInTaeiCaseSheet,
                  onChanged: (value) {
                    controller.drowningModel.value?.drowningOutcome
                        ?.documentedInTaeiCaseSheet = value;
                    controller.drowningModel.refresh();
                  }),
            ],
          )
      ],
    );
  }
}
