import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taei_gov/src/hospital/controller/hospital_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/script/controller/script_controller.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import 'package:taei_gov/utils/common/new_common_date_time_picker.dart';
import 'package:taei_gov/utils/common/save_submit_dialog.dart';
import 'package:taei_gov/utils/helpers/page_loader.dart';
import 'package:taei_gov/utils/helpers/space.dart';

import '../../../utils/common/common_check_box_list.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../../utils/common/m_elevate_button.dart';
import '../../../utils/common/title_textfield.dart';
import '../../../utils/common/yes_or_no_radio_button.dart';
import '../../../utils/helpers/snackbar_helper.dart';

class AddScript extends StatefulWidget {
  final String? triageId;
  final String? strokeId;
  final bool isUpdate;

  const AddScript(
      {super.key, this.triageId, this.strokeId, required this.isUpdate});

  @override
  State<AddScript> createState() => _AddScriptState();
}

class _AddScriptState extends State<AddScript> {
  final ScriptController controller = Get.put(ScriptController());
  TextEditingController dateController = TextEditingController();
  HospitalController hospitalController = Get.put(HospitalController());

  @override
  void initState() {
    // fetchDta();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.isLoading(true);
      await controller.getLookup();
      await hospitalController.getHospitalListData();
      if (widget.isUpdate) {
        await controller.getScriptById(id: widget.strokeId!);
      }
      controller.isLoading(false);
    });
    super.initState();
  }

  // Helper method to validate all required fields
  bool _validateForm() {
    // Check if all required fields are filled
    if (controller.scriptModel.value.stroke?.dateTimeOfEntry == null) {
      Fluttertoast.showToast(msg: "Please select Entry Date");
      return false;
    }

    if (controller.scriptModel.value.stroke?.arrivalTimeSymptoms == null) {
      Fluttertoast.showToast(
          msg: "Please select Arrival after stroke symptoms onset");
      return false;
    }

    if (controller.scriptModel.value.stroke?.sceneIft == null) {
      Fluttertoast.showToast(msg: "Please select Scene/IFT");
      return false;
    }

    if (controller.scriptModel.value.stroke?.admitted == null) {
      Fluttertoast.showToast(msg: "Please select Admitted");
      return false;
    }

    if (controller.scriptModel.value.stroke?.lysisDoneOutside == null) {
      Fluttertoast.showToast(msg: "Please select Lysis Done Outside");
      return false;
    }

    if (controller.scriptModel.value.stroke?.symptoms == null ||
        controller.scriptModel.value.stroke!.symptoms!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select Symptoms");
      return false;
    }

    if (controller.scriptModel.value.stroke?.riskFactors == null ||
        controller.scriptModel.value.stroke!.riskFactors!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select Risk Factors");
      return false;
    }

    if (controller.scriptModel.value.stroke?.nihsScale == null ||
        controller.scriptModel.value.stroke!.nihsScale!.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter NIHS Scale");
      return false;
    }

    if (controller.scriptModel.value.stroke?.isAbsoluteContraindication ==
        null) {
      Fluttertoast.showToast(
          msg: "Please select Absolute Contraindication for Thrombolysis");
      return false;
    }

    if (controller.scriptModel.value.stroke?.cbg == null) {
      Fluttertoast.showToast(msg: "Please select CBG");
      return false;
    }

    if (controller.scriptModel.value.stroke?.historyOfAnticoagulant == null) {
      Fluttertoast.showToast(msg: "Please select History of Anticoagulant");
      return false;
    }

    if (controller.scriptModel.value.stroke?.ctScan == null) {
      Fluttertoast.showToast(msg: "Please select CT Scan");
      return false;
    }

    if (controller.scriptModel.value.stroke?.mriScan == null) {
      Fluttertoast.showToast(msg: "Please select MRI Scan");
      return false;
    }

    if (controller.scriptModel.value.stroke?.cathLabProcedure == null) {
      Fluttertoast.showToast(msg: "Please select CATH Lab Procedure Done");
      return false;
    }

    if (controller.scriptModel.value.stroke?.type == null) {
      Fluttertoast.showToast(msg: "Please select Type");
      return false;
    }

    if (controller.scriptModel.value.stroke?.lysisDone == null) {
      Fluttertoast.showToast(msg: "Please select Lysis Done");
      return false;
    }

    if (controller.scriptModel.value.stroke?.lysisDone == true &&
        controller.scriptModel.value.stroke?.thrombolysisByDrug == null) {
      Fluttertoast.showToast(msg: "Please select Thrombolysis by Drug");
      return false;
    }

    if (controller.scriptModel.value.stroke?.thrombectomy == null) {
      Fluttertoast.showToast(msg: "Please select Thrombectomy");
      return false;
    }

    if (controller.scriptModel.value.stroke?.decompressionCraniectomy == null) {
      Fluttertoast.showToast(msg: "Please select Decompression Craniectomy");
      return false;
    }

    if (controller.scriptModel.value.outcome?.outcome == null) {
      Fluttertoast.showToast(msg: "Please select Outcome");
      return false;
    }

    // if (controller.scriptModel.value.outcome?.durationStay == null) {
    //   Fluttertoast.showToast(msg: "Please enter Duration of hospital stay");
    //   return false;
    // }

    // Additional conditional validations
    if (controller.scriptModel.value.stroke?.arrivalTimeSymptoms != null &&
        controller.scriptModel.value.stroke!.arrivalTimeSymptoms != 1 &&
        controller.scriptModel.value.stroke?.reasonForDelay == null) {
      Fluttertoast.showToast(msg: "Please select Reason for the Delay");
      return false;
    }

    if (controller.scriptModel.value.stroke?.reasonForDelay != null &&
        controller.scriptModel.value.stroke!.reasonForDelay == 4 &&
        (controller.scriptModel.value.stroke?.othReasonForDelay == null ||
            controller.scriptModel.value.stroke!.othReasonForDelay!.isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Others Specify");
      return false;
    }

    if (controller.scriptModel.value.stroke?.sceneIft == 2 &&
        controller.scriptModel.value.stroke?.reasonForReferral == 5 &&
        (controller.scriptModel.value.stroke?.othReasonForReferral == null ||
            controller
                .scriptModel.value.stroke!.othReasonForReferral!.isEmpty)) {
      Fluttertoast.showToast(
          msg: "Please enter Others Specify for Reason for Referral");
      return false;
    }

    if (controller.scriptModel.value.stroke?.riskFactors != null &&
        controller.scriptModel.value.stroke!.riskFactors!.contains(13) &&
        (controller.scriptModel.value.stroke?.othRiskFactors == null ||
            controller.scriptModel.value.stroke!.othRiskFactors!.isEmpty)) {
      Fluttertoast.showToast(
          msg: "Please enter Others Specify for Risk Factors");
      return false;
    }

    if (controller.scriptModel.value.stroke?.isAbsoluteContraindication ==
            true &&
        (controller.scriptModel.value.stroke?.othAbsoluteContraindication ==
                null ||
            controller.scriptModel.value.stroke!.othAbsoluteContraindication!
                .isEmpty)) {
      Fluttertoast.showToast(
          msg: "Please enter Specify Absolute Contraindication");
      return false;
    }

    if (controller.scriptModel.value.stroke?.cbg == true &&
        (controller.scriptModel.value.stroke?.cbgTxt == null ||
            controller.scriptModel.value.stroke!.cbgTxt!.isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Specify CBG(mg/dL)");
      return false;
    }

    if (controller.scriptModel.value.stroke?.ctScan == true &&
        (controller.scriptModel.value.stroke?.ctScanFindings == null ||
            controller.scriptModel.value.stroke!.ctScanFindings!.isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Specify CT Scan");
      return false;
    }

    if (controller.scriptModel.value.stroke?.cathLabProcedure == true) {
      if (controller.scriptModel.value.stroke?.nameOfProcedure == null ||
          controller.scriptModel.value.stroke!.nameOfProcedure!.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter Procedure Name");
        return false;
      }

      if (controller.scriptModel.value.stroke?.cathLabFindings == null ||
          controller.scriptModel.value.stroke!.cathLabFindings!.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter Specify Findings");
        return false;
      }
    }

    if (controller.scriptModel.value.stroke?.lysisDone == true &&
        controller.scriptModel.value.stroke?.thrombectomy == true &&
        (controller.scriptModel.value.stroke?.thrombectomyDtls == null ||
            controller.scriptModel.value.stroke!.thrombectomyDtls!.isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Specify Thrombectomy");
      return false;
    }

    if (controller.scriptModel.value.stroke?.decompressionCraniectomy == true &&
        (controller.scriptModel.value.stroke?.decompressionCraniectomyDtls ==
                null ||
            controller.scriptModel.value.stroke!.decompressionCraniectomyDtls!
                .isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Specific Craniectomy");
      return false;
    }

    // Outcome validations
    if (controller.scriptModel.value.outcome?.outcome == 1) {
      if (controller.scriptModel.value.outcome?.drugPrescribed == null ||
          controller.scriptModel.value.outcome!.drugPrescribed!.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter Drug Prescribed");
        return false;
      }

      if (controller.scriptModel.value.outcome?.treatmentGiven == null ||
          controller.scriptModel.value.outcome!.treatmentGiven!.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter Treatment given");
        return false;
      }
    }

    if (controller.scriptModel.value.outcome?.outcome == 6) {
      if (controller.scriptModel.value.outcome?.hospitalType == null) {
        Fluttertoast.showToast(msg: "Please select Hospital Type");
        return false;
      }

      if (controller.scriptModel.value.outcome?.hospitalType == 1 &&
          controller.scriptModel.value.outcome?.destinationTaeiHospital ==
              null) {
        Fluttertoast.showToast(msg: "Please select Destination hospital");
        return false;
      }

      if (controller.scriptModel.value.outcome?.hospitalType == 2 &&
          (controller.scriptModel.value.outcome?.destinationHospital == null ||
              controller
                  .scriptModel.value.outcome!.destinationHospital!.isEmpty)) {
        Fluttertoast.showToast(
            msg: "Please enter Destination Non TAEI hospital");
        return false;
      }

      if (controller.scriptModel.value.outcome?.reasonForReferral == null) {
        Fluttertoast.showToast(msg: "Please select Reason for referral");
        return false;
      }

      if (controller.scriptModel.value.outcome?.conditionOfPatient == null) {
        Fluttertoast.showToast(msg: "Please select Condition of patient");
        return false;
      }

      if (controller.scriptModel.value.outcome?.referringDoctor == null ||
          controller.scriptModel.value.outcome!.referringDoctor!.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter Referring Doctor Name");
        return false;
      }

      if (controller.scriptModel.value.outcome?.documentedTaeiSheet == null) {
        Fluttertoast.showToast(
            msg: "Please select Whether details documented in TAEI Case sheet");
        return false;
      }
    }

    return true;
  }

  bool _validateFormSave() {
    // Check if all required fields are filled
    if (controller.scriptModel.value.stroke?.dateTimeOfEntry == null) {
      Fluttertoast.showToast(msg: "Please select Entry Date");
      return false;
    }

    if (controller.scriptModel.value.stroke?.arrivalTimeSymptoms == null) {
      Fluttertoast.showToast(
          msg: "Please select Arrival after stroke symptoms onset");
      return false;
    }

    if (controller.scriptModel.value.stroke?.sceneIft == null) {
      Fluttertoast.showToast(msg: "Please select Scene/IFT");
      return false;
    }

    if (controller.scriptModel.value.stroke?.admitted == null) {
      Fluttertoast.showToast(msg: "Please select Admitted");
      return false;
    }

    if (controller.scriptModel.value.stroke?.lysisDoneOutside == null) {
      Fluttertoast.showToast(msg: "Please select Lysis Done Outside");
      return false;
    }

    if (controller.scriptModel.value.stroke?.symptoms == null ||
        controller.scriptModel.value.stroke!.symptoms!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select Symptoms");
      return false;
    }

    if (controller.scriptModel.value.stroke?.riskFactors == null ||
        controller.scriptModel.value.stroke!.riskFactors!.isEmpty) {
      Fluttertoast.showToast(msg: "Please select Risk Factors");
      return false;
    }

    if (controller.scriptModel.value.stroke?.nihsScale == null ||
        controller.scriptModel.value.stroke!.nihsScale!.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter NIHS Scale");
      return false;
    }

    if (controller.scriptModel.value.stroke?.isAbsoluteContraindication ==
        null) {
      Fluttertoast.showToast(
          msg: "Please select Absolute Contraindication for Thrombolysis");
      return false;
    }

    if (controller.scriptModel.value.stroke?.cbg == null) {
      Fluttertoast.showToast(msg: "Please select CBG");
      return false;
    }

    if (controller.scriptModel.value.stroke?.historyOfAnticoagulant == null) {
      Fluttertoast.showToast(msg: "Please select History of Anticoagulant");
      return false;
    }

    if (controller.scriptModel.value.stroke?.ctScan == null) {
      Fluttertoast.showToast(msg: "Please select CT Scan");
      return false;
    }

    if (controller.scriptModel.value.stroke?.mriScan == null) {
      Fluttertoast.showToast(msg: "Please select MRI Scan");
      return false;
    }

    if (controller.scriptModel.value.stroke?.cathLabProcedure == null) {
      Fluttertoast.showToast(msg: "Please select CATH Lab Procedure Done");
      return false;
    }

    if (controller.scriptModel.value.stroke?.type == null) {
      Fluttertoast.showToast(msg: "Please select Type");
      return false;
    }

    if (controller.scriptModel.value.stroke?.lysisDone == null) {
      Fluttertoast.showToast(msg: "Please select Lysis Done");
      return false;
    }

    if (controller.scriptModel.value.stroke?.lysisDone == true &&
        controller.scriptModel.value.stroke?.thrombolysisByDrug == null) {
      Fluttertoast.showToast(msg: "Please select Thrombolysis by Drug");
      return false;
    }

    if (controller.scriptModel.value.stroke?.thrombectomy == null) {
      Fluttertoast.showToast(msg: "Please select Thrombectomy");
      return false;
    }

    if (controller.scriptModel.value.stroke?.decompressionCraniectomy == null) {
      Fluttertoast.showToast(msg: "Please select Decompression Craniectomy");
      return false;
    }

    // if (controller.scriptModel.value.outcome?.outcome == null) {
    //   Fluttertoast.showToast(msg: "Please select Outcome");
    //   return false;
    // }

    // if (controller.scriptModel.value.outcome?.durationStay == null) {
    //   Fluttertoast.showToast(msg: "Please enter Duration of hospital stay");
    //   return false;
    // }

    // Additional conditional validations
    if (controller.scriptModel.value.stroke?.arrivalTimeSymptoms != null &&
        controller.scriptModel.value.stroke!.arrivalTimeSymptoms != 1 &&
        controller.scriptModel.value.stroke?.reasonForDelay == null) {
      Fluttertoast.showToast(msg: "Please select Reason for the Delay");
      return false;
    }

    if (controller.scriptModel.value.stroke?.reasonForDelay != null &&
        controller.scriptModel.value.stroke!.reasonForDelay == 4 &&
        (controller.scriptModel.value.stroke?.othReasonForDelay == null ||
            controller.scriptModel.value.stroke!.othReasonForDelay!.isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Others Specify");
      return false;
    }

    if (controller.scriptModel.value.stroke?.sceneIft == 2 &&
        controller.scriptModel.value.stroke?.reasonForReferral == 5 &&
        (controller.scriptModel.value.stroke?.othReasonForReferral == null ||
            controller
                .scriptModel.value.stroke!.othReasonForReferral!.isEmpty)) {
      Fluttertoast.showToast(
          msg: "Please enter Others Specify for Reason for Referral");
      return false;
    }

    if (controller.scriptModel.value.stroke?.riskFactors != null &&
        controller.scriptModel.value.stroke!.riskFactors!.contains(13) &&
        (controller.scriptModel.value.stroke?.othRiskFactors == null ||
            controller.scriptModel.value.stroke!.othRiskFactors!.isEmpty)) {
      Fluttertoast.showToast(
          msg: "Please enter Others Specify for Risk Factors");
      return false;
    }

    if (controller.scriptModel.value.stroke?.isAbsoluteContraindication ==
            true &&
        (controller.scriptModel.value.stroke?.othAbsoluteContraindication ==
                null ||
            controller.scriptModel.value.stroke!.othAbsoluteContraindication!
                .isEmpty)) {
      Fluttertoast.showToast(
          msg: "Please enter Specify Absolute Contraindication");
      return false;
    }

    if (controller.scriptModel.value.stroke?.cbg == true &&
        (controller.scriptModel.value.stroke?.cbgTxt == null ||
            controller.scriptModel.value.stroke!.cbgTxt!.isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Specify CBG(mg/dL)");
      return false;
    }

    if (controller.scriptModel.value.stroke?.ctScan == true &&
        (controller.scriptModel.value.stroke?.ctScanFindings == null ||
            controller.scriptModel.value.stroke!.ctScanFindings!.isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Specify CT Scan");
      return false;
    }

    if (controller.scriptModel.value.stroke?.cathLabProcedure == true) {
      if (controller.scriptModel.value.stroke?.nameOfProcedure == null ||
          controller.scriptModel.value.stroke!.nameOfProcedure!.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter Procedure Name");
        return false;
      }

      if (controller.scriptModel.value.stroke?.cathLabFindings == null ||
          controller.scriptModel.value.stroke!.cathLabFindings!.isEmpty) {
        Fluttertoast.showToast(msg: "Please enter Specify Findings");
        return false;
      }
    }

    if (controller.scriptModel.value.stroke?.lysisDone == true &&
        controller.scriptModel.value.stroke?.thrombectomy == true &&
        (controller.scriptModel.value.stroke?.thrombectomyDtls == null ||
            controller.scriptModel.value.stroke!.thrombectomyDtls!.isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Specify Thrombectomy");
      return false;
    }

    if (controller.scriptModel.value.stroke?.decompressionCraniectomy == true &&
        (controller.scriptModel.value.stroke?.decompressionCraniectomyDtls ==
                null ||
            controller.scriptModel.value.stroke!.decompressionCraniectomyDtls!
                .isEmpty)) {
      Fluttertoast.showToast(msg: "Please enter Specific Craniectomy");
      return false;
    }

    // Outcome validations
    // if (controller.scriptModel.value.outcome?.outcome == 1) {
    //   if (controller.scriptModel.value.outcome?.drugPrescribed == null ||
    //       controller.scriptModel.value.outcome!.drugPrescribed!.isEmpty) {
    //     Fluttertoast.showToast(msg: "Please enter Drug Prescribed");
    //     return false;
    //   }
    //
    //   if (controller.scriptModel.value.outcome?.treatmentGiven == null ||
    //       controller.scriptModel.value.outcome!.treatmentGiven!.isEmpty) {
    //     Fluttertoast.showToast(msg: "Please enter Treatment given");
    //     return false;
    //   }
    // }
    //
    // if (controller.scriptModel.value.outcome?.outcome == 6) {
    //   if (controller.scriptModel.value.outcome?.hospitalType == null) {
    //     Fluttertoast.showToast(msg: "Please select Hospital Type");
    //     return false;
    //   }
    //
    //   if (controller.scriptModel.value.outcome?.hospitalType == 1 &&
    //       controller.scriptModel.value.outcome?.destinationTaeiHospital == null) {
    //     Fluttertoast.showToast(msg: "Please select Destination hospital");
    //     return false;
    //   }
    //
    //   if (controller.scriptModel.value.outcome?.hospitalType == 2 &&
    //       (controller.scriptModel.value.outcome?.destinationHospital == null ||
    //           controller.scriptModel.value.outcome!.destinationHospital!.isEmpty)) {
    //     Fluttertoast.showToast(msg: "Please enter Destination Non TAEI hospital");
    //     return false;
    //   }
    //
    //   if (controller.scriptModel.value.outcome?.reasonForReferral == null) {
    //     Fluttertoast.showToast(msg: "Please select Reason for referral");
    //     return false;
    //   }
    //
    //   if (controller.scriptModel.value.outcome?.conditionOfPatient == null) {
    //     Fluttertoast.showToast(msg: "Please select Condition of patient");
    //     return false;
    //   }
    //
    //   if (controller.scriptModel.value.outcome?.referringDoctor == null ||
    //       controller.scriptModel.value.outcome!.referringDoctor!.isEmpty) {
    //     Fluttertoast.showToast(msg: "Please enter Referring Doctor Name");
    //     return false;
    //   }
    //
    //   if (controller.scriptModel.value.outcome?.documentedTaeiSheet == null) {
    //     Fluttertoast.showToast(msg: "Please select Whether details documented in TAEI Case sheet");
    //     return false;
    //   }
    // }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
      appBar: CommonAppBar(
        title: 'Script',
        id: widget.triageId,
      ),
      body: Obx(
            () => controller.isLoading.value
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
            behavior: const ScrollBehavior().copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Padding(
                padding: context.isDesktop
                    ? EdgeInsets.only(
                    left: 30, right: 30, top: 8, bottom: 8)
                    : EdgeInsets.all(10),
                child: Column(
                  spacing: 12,
                  children: [
                    Center(
                      child: Text(
                        'Add SCRIPT',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Space(
                      height: 10,
                    ),
                    CommonDateTimeWidget(
                        isRequired: true,
                        title: 'Entry Date',
                        dateTime: controller
                            .scriptModel.value.stroke?.dateTimeOfEntry
                            .toString(),
                        onChanged: (value) {
                          controller.scriptModel.value.stroke
                              ?.dateTimeOfEntry = value;
                        }),
                    NewTitleDropdown(
                      isRequired: true,
                      title: 'Arrival after stroke sysmptoms on set',
                      hint:
                      'Select Arrival after stroke sysmptoms on set',
                      items: controller
                          .lookupList.value?.arrivalTimeSymptoms
                          ?.map((e) => {"id": e.id, "name": e.name})
                          .toList() ??
                          [],
                      selectedId: controller
                          .scriptModel.value.stroke?.arrivalTimeSymptoms,
                      onChanged: (value) {
                        controller.scriptModel.value.stroke
                            ?.arrivalTimeSymptoms = value;
                        controller.scriptModel.value.stroke
                            ?.reasonForDelay = null;
                        controller.scriptModel.value.stroke
                            ?.othReasonForDelay = null;
                        controller.scriptModel.refresh();
                      },
                    ),
                    if (controller.scriptModel.value.stroke
                        ?.arrivalTimeSymptoms !=
                        null &&
                        controller.scriptModel.value.stroke
                            ?.arrivalTimeSymptoms !=
                            1)
                      NewTitleDropdown(
                          isRequired: true,
                          title: 'Reason for the Delay',
                          hint: 'Select Reason for the Delay',
                          items: controller
                              .lookupList.value?.reasonForDelay
                              ?.map(
                                  (e) => {"id": e.id, "name": e.name})
                              .toList() ??
                              [],
                          selectedId: controller
                              .scriptModel.value.stroke?.reasonForDelay,
                          onChanged: (value) {
                            controller.scriptModel.value.stroke
                                ?.reasonForDelay = value;
                            controller.scriptModel.refresh();
                          }),
                    if (controller.scriptModel.value.stroke
                        ?.reasonForDelay !=
                        null &&
                        controller.scriptModel.value.stroke
                            ?.reasonForDelay ==
                            4)
                      TitleTextFormField(
                        isRequired: true,
                        title: "Others Specify",
                        controller: TextEditingController(
                            text: controller.scriptModel.value.stroke
                                ?.othReasonForDelay),
                        keyboardType: TextInputType.name,
                        hintText: 'Enter Specify',
                        onChanged: (v) {
                          controller.scriptModel.value.stroke
                              ?.othReasonForDelay = v;
                        },
                      ),
                    NewTitleDropdown(
                        isRequired: true,
                        title: 'Scene/IFT',
                        hint: 'Select Scene/IFT',
                        items: controller.lookupList.value?.sceneIft
                            ?.map((e) => {"id": e.id, "name": e.name})
                            .toList() ??
                            [],
                        selectedId:
                        controller.scriptModel.value.stroke?.sceneIft,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke?.sceneIft =
                              value;
                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke?.sceneIft == 2)
                      Column(
                        spacing: 17,
                        children: [
                          NewTitleDropdown(
                              title: 'Referred from',
                              hint: 'Select eferred from',
                              items: controller
                                  .lookupList.value?.referredFrom
                                  ?.map((e) =>
                              {"id": e.id, "name": e.name})
                                  .toList() ??
                                  [],
                              selectedId: controller
                                  .scriptModel.value.stroke?.referredFrom,
                              onChanged: (value) {
                                controller.scriptModel.value.stroke
                                    ?.referredFrom = value;
                              }),
                          NewTitleDropdown(
                              title: 'Reason for Referral',
                              hint: 'Select Reason for Referral',
                              items: controller.lookupList.value
                                  ?.strokeReasonForReferral
                                  ?.map((e) =>
                              {"id": e.id, "name": e.name})
                                  .toList() ??
                                  [],
                              selectedId: controller.scriptModel.value
                                  .stroke?.reasonForReferral,
                              onChanged: (value) {
                                controller.scriptModel.value.stroke
                                    ?.reasonForReferral = value;
                                controller.scriptModel.refresh();
                              }),
                        ],
                      ),
                    if (controller.scriptModel.value.stroke
                        ?.reasonForReferral ==
                        5)
                      TitleTextFormField(
                        isRequired: true,
                        title: "Others Specify",
                        controller: TextEditingController(
                            text: controller.scriptModel.value.stroke
                                ?.othReasonForReferral),
                        keyboardType: TextInputType.name,
                        hintText: 'Enter Specify',
                        onChanged: (v) {
                          controller.scriptModel.value.stroke
                              ?.othReasonForReferral = v;
                        },
                      ),
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'Admitted',
                        initialValue:
                        controller.scriptModel.value.stroke?.admitted,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke?.admitted =
                              value;
                          if (value) {
                            controller.scriptModel.value.stroke
                                ?.admittedDateTime =
                                DateTime.now().toString();
                          } else {
                            controller.scriptModel.value.stroke
                                ?.admittedDateTime = null;
                          }

                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke?.admitted !=
                        null &&
                        controller.scriptModel.value.stroke?.admitted ==
                            true)
                      CommonDateTimeWidget(
                        title: "Admitted Date",
                        dateTime: controller
                            .scriptModel.value.stroke?.admittedDateTime,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke
                              ?.admittedDateTime = value;
                        },
                      ),
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'Lysis Done out side',
                        initialValue: controller
                            .scriptModel.value.stroke?.lysisDoneOutside,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke!
                              .lysisDoneOutside = value;
                          if (value) {
                            controller.scriptModel.value.stroke
                                ?.lysisDoneOutsideDate =
                                DateTime.now().toString();
                          } else {
                            controller.scriptModel.value.stroke
                                ?.lysisDoneOutsideDate = null;
                          }
                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke
                        ?.lysisDoneOutside !=
                        null &&
                        controller.scriptModel.value.stroke
                            ?.lysisDoneOutside ==
                            true)
                      CommonDateTimeWidget(
                        title: "Lysis Done Outside Date",
                        dateTime: controller.scriptModel.value.stroke
                            ?.lysisDoneOutsideDate,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke
                              ?.lysisDoneOutsideDate = value;
                        },
                      ),
                    NewCheckboxList(
                        title: 'Symptoms',
                        isRequired: true,
                        options:
                        controller.lookupList.value?.symptoms ?? [],
                        initialSelectedIndexes: controller
                            .scriptModel.value.stroke?.symptoms ??
                            [],
                        onChanged: (value) {
                          controller.scriptModel.value.stroke?.symptoms =
                              value;
                          controller.scriptModel.refresh();
                        }),
                    NewCheckboxList(
                        title: 'Risk factors',
                        isRequired: true,
                        options: controller.lookupList.value
                            ?.absoluteContraindication ??
                            [],
                        initialSelectedIndexes: controller
                            .scriptModel.value.stroke?.riskFactors ??
                            [],
                        onChanged: (value) {
                          controller.scriptModel.value.stroke?.riskFactors =
                              value;
                          controller.scriptModel.refresh();
                        }),
                    if (controller
                        .scriptModel.value.stroke?.riskFactors !=
                        null &&
                        (controller.scriptModel.value.stroke?.riskFactors
                            ?.contains(13) ??
                            false))
                      TitleTextFormField(
                        isRequired: true,
                        title: "Others Specify",
                        controller: TextEditingController(
                            text: controller.scriptModel.value.stroke
                                ?.othRiskFactors),
                        keyboardType: TextInputType.name,
                        hintText: 'Enter Specify',
                        onChanged: (v) {
                          controller.scriptModel.value.stroke
                              ?.othRiskFactors = v;
                        },
                      ),
                    TitleTextFormField(
                      isRequired: true,
                      title: "NIHS Scale",
                      controller: TextEditingController(
                          text: controller
                              .scriptModel.value.stroke?.nihsScale),
                      keyboardType: TextInputType.name,
                      hintText: 'Enter NIHS Scale',
                      onChanged: (v) {
                        controller.scriptModel.value.stroke?.nihsScale = v;
                      },
                    ),
                    TitleTextFormField(
                      title: "Pre-Morbid score",
                      controller: TextEditingController(
                          text: controller
                              .scriptModel.value.stroke?.preMorbitScroe),
                      keyboardType: TextInputType.name,
                      hintText: 'Enter Pre-Morbid score',
                      onChanged: (v) {
                        controller.scriptModel.value.stroke?.preMorbitScroe =
                            v;
                      },
                    ),
                    NewTitleYesRadio(
                        isRequired: true,
                        title:
                        'Absolute Contraindication for Thrombolysis',
                        initialValue: controller.scriptModel.value.stroke
                            ?.isAbsoluteContraindication,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke!
                              .isAbsoluteContraindication = value;
                          if (value) {
                          } else {}
                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke
                        ?.isAbsoluteContraindication !=
                        null &&
                        controller.scriptModel.value.stroke
                            ?.isAbsoluteContraindication ==
                            true)
                      TitleTextFormField(
                          isRequired: true,
                          title: 'Specify Absolute Contraindication',
                          controller: TextEditingController(
                            text: controller.scriptModel.value.stroke
                                ?.othAbsoluteContraindication,
                          ),
                          hintText: 'Specify Absolute Contraindication',
                          onChanged: (value) {
                            controller.scriptModel.value.stroke
                                ?.othAbsoluteContraindication = value;
                          }),
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'CBG',
                        initialValue:
                        controller.scriptModel.value.stroke!.cbg,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke!.cbg = value;
                          if (value) {
                            controller.scriptModel.value.stroke?.cbgDate =
                                DateTime.now().toString();
                          } else {
                            controller.scriptModel.value.stroke?.cbgDate =
                            null;
                          }
                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke!.cbg !=
                        null &&
                        controller.scriptModel.value.stroke!.cbg == true)
                      Column(
                        spacing: 17,
                        children: [
                          CommonDateTimeWidget(
                            title: "CBG Date",
                            dateTime: controller
                                .scriptModel.value.stroke?.cbgDate,
                            onChanged: (value) {
                              controller.scriptModel.value.stroke?.cbgDate =
                                  value;
                            },
                          ),
                          TitleTextFormField(
                              isRequired: true,
                              title: 'Specify CBG(mg/dL)',
                              controller: TextEditingController(
                                text: controller
                                    .scriptModel.value.stroke?.cbgTxt,
                              ),
                              hintText: 'Specify CBG(mg/dL)',
                              onChanged: (value) {
                                controller.scriptModel.value.stroke?.cbgTxt =
                                    value;
                              }),
                        ],
                      ),
                    Row(
                      children: [
                        /// BP
                        Expanded(
                          child: TitleTextFormField(
                            title: 'BP Systolic',
                            hintText: 'Enter BP Systolic',
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(
                              text: controller
                                  .scriptModel.value.stroke?.bpSbp,
                            ),
                            onChanged: (value) {
                              controller.scriptModel.value.stroke?.bpSbp =
                                  value;
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TitleTextFormField(
                            title: 'BP Diastolic',
                            hintText: 'Enter BP Diastolic',
                            maxLength: 3,
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(
                              text: controller
                                  .scriptModel.value.stroke?.bpDbp,
                            ),
                            onChanged: (value) {
                              controller.scriptModel.value.stroke?.bpDbp =
                                  value;
                            },
                          ),
                        ),
                      ],
                    ),
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'History of Anticoagulant',
                        initialValue: controller.scriptModel.value.stroke
                            ?.historyOfAnticoagulant,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke
                              ?.historyOfAnticoagulant = value;
                          controller.scriptModel.refresh();
                        }),
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'CT scan',
                        initialValue:
                        controller.scriptModel.value.stroke!.ctScan,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke!.ctScan =
                              value;
                          if (value) {
                            controller.scriptModel.value.stroke
                                ?.ctScanDate = DateTime.now().toString();
                          } else {
                            controller.scriptModel.value.stroke
                                ?.ctScanDate = null;
                          }
                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke!.ctScan !=
                        null &&
                        controller.scriptModel.value.stroke!.ctScan ==
                            true)
                      Column(
                        spacing: 17,
                        children: [
                          CommonDateTimeWidget(
                            title: "CT Scan Date",
                            dateTime: controller
                                .scriptModel.value.stroke?.ctScanDate,
                            onChanged: (value) {
                              controller.scriptModel.value.stroke
                                  ?.ctScanDate = value;
                            },
                          ),
                          TitleTextFormField(
                              isRequired: true,
                              title: 'Specify CT Scan',
                              controller: TextEditingController(
                                text: controller.scriptModel.value.stroke!
                                    .ctScanFindings,
                              ),
                              keyboardType: TextInputType.name,
                              hintText: 'Specify CT Scan',
                              onChanged: (value) {
                                controller.scriptModel.value.stroke
                                    ?.ctScanFindings = value;
                              }),
                        ],
                      ),
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'MRI Scan (Wakeup Stroke)',
                        initialValue:
                        controller.scriptModel.value.stroke!.mriScan,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke!.mriScan =
                              value;
                          if (value) {
                            controller.scriptModel.value.stroke
                                ?.mriScanDate = DateTime.now().toString();
                          } else {
                            controller.scriptModel.value.stroke
                                ?.mriScanDate = null;
                          }
                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke!.mriScan !=
                        null &&
                        controller.scriptModel.value.stroke!.mriScan ==
                            true)
                      Column(
                        spacing: 18,
                        children: [
                          CommonDateTimeWidget(
                            title: "MRI Scan Date",
                            dateTime: controller
                                .scriptModel.value.stroke?.mriScanDate,
                            onChanged: (value) {
                              controller.scriptModel.value.stroke
                                  ?.mriScanDate = value;
                            },
                          ),
                          NewTitleYesRadio(
                              title: 'Eligility status for Thrombolysis',
                              initialValue: controller.scriptModel.value
                                  .stroke?.mriScanEligibility ==
                                  1
                                  ? true
                                  : false,
                              onChanged: (value) {
                                controller.scriptModel.value.stroke
                                    ?.mriScanEligibility =
                                value == "Yes" ? 1 : 2;
                                controller.scriptModel.refresh();
                              }),
                        ],
                      ),
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'CATH Lab Procedure Done',
                        initialValue: controller
                            .scriptModel.value.stroke!.cathLabProcedure,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke!
                              .cathLabProcedure = value;
                          if (value) {
                            controller.scriptModel.value.stroke
                                ?.cathLabProcedureDate =
                                DateTime.now().toString();
                          } else {
                            controller.scriptModel.value.stroke
                                ?.cathLabProcedureDate = null;
                          }
                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke
                        ?.cathLabProcedure !=
                        null &&
                        controller.scriptModel.value.stroke
                            ?.cathLabProcedure ==
                            true)
                      Column(
                        spacing: 17,
                        children: [
                          TitleTextFormField(
                              isRequired: true,
                              title: 'Procedure Name',
                              controller: TextEditingController(
                                text: controller.scriptModel.value.stroke!
                                    .nameOfProcedure,
                              ),
                              hintText: 'Procedure Name ',
                              onChanged: (value) {
                                controller.scriptModel.value.stroke
                                    ?.nameOfProcedure = value;
                              }),
                          CommonDateTimeWidget(
                            title: "Cath Lab Procedure Date",
                            dateTime: controller.scriptModel.value.stroke!
                                .cathLabProcedureDate,
                            onChanged: (value) {
                              controller.scriptModel.value.stroke
                                  ?.cathLabProcedureDate = value;
                            },
                          ),
                          TitleTextFormField(
                              isRequired: true,
                              title: 'Specify Findings',
                              controller: TextEditingController(
                                text: controller.scriptModel.value.stroke
                                    ?.cathLabFindings,
                              ),
                              hintText: 'Specify Findings',
                              onChanged: (value) {
                                controller.scriptModel.value.stroke
                                    ?.cathLabFindings = value;
                              }),
                        ],
                      ),
                    NewTitleDropdown(
                      title: 'Type',
                      hint: 'Select Type',
                      isRequired: true,
                      items: controller.lookupList.value?.type
                          ?.map((e) => {"id": e.id, "name": e.name})
                          .toList() ??
                          [],
                      selectedId:
                      controller.scriptModel.value.stroke?.type,
                      onChanged: (value) {
                        controller.scriptModel.value.stroke?.type = value;
                        controller.scriptModel.refresh();
                      },
                    ),
                    if (controller.scriptModel.value.stroke?.type !=
                        null &&
                        controller.scriptModel.value.stroke?.type == 1)
                      TitleTextFormField(
                        title: 'Aspect Score',
                        hintText: 'Enter Aspect Score',
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                          text: controller
                              .scriptModel.value.stroke?.aspectScore,
                        ),
                        onChanged: (value) {
                          controller.scriptModel.value.stroke?.aspectScore =
                              value;
                        },
                      ),
                    if (controller.scriptModel.value.stroke?.type !=
                        null &&
                        controller.scriptModel.value.stroke?.type == 2)
                      TitleTextFormField(
                        title: 'Specify Hemorrhagic',
                        hintText: 'Enter Specify Hemorrhagic',
                        keyboardType: TextInputType.number,
                        controller: TextEditingController(
                          text: controller.scriptModel.value.stroke
                              ?.hemorrhagicSpecify,
                        ),
                        onChanged: (value) {
                          controller.scriptModel.value.stroke
                              ?.hemorrhagicSpecify = value;
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Treatment",
                        style: GoogleFonts.poppins(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'Lysis Done',
                        initialValue: controller
                            .scriptModel.value.stroke!.lysisDone,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke!.lysisDone =
                              value;
                          if (value) {
                            controller.scriptModel.value.stroke?.lysisDate =
                                DateTime.now().toString();
                          } else {
                            controller.scriptModel.value.stroke?.lysisDate =
                            null;
                          }
                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke?.lysisDone !=
                        null &&
                        controller.scriptModel.value.stroke?.lysisDone ==
                            true) ...[
                      CommonDateTimeWidget(
                        title: "Lysis Date",
                        dateTime: controller
                            .scriptModel.value.stroke?.lysisDate,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke?.lysisDate =
                              value;
                        },
                      ),
                      NewTitleDropdown(
                          isRequired: true,
                          title: 'Thrombolysis by Drug',
                          hint: 'Select Thrombolysis by Drug',
                          items: controller
                              .lookupList.value?.thrombolysisByDrug
                              ?.map(
                                  (e) => {"id": e.id, "name": e.name})
                              .toList() ??
                              [],
                          selectedId: controller.scriptModel.value.stroke
                              ?.thrombolysisByDrug,
                          onChanged: (value) {
                            controller.scriptModel.value.stroke
                                ?.thrombolysisByDrug = value;
                          }),
                    ],
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'Thrombectomy',
                        initialValue: controller
                            .scriptModel.value.stroke?.thrombectomy,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke!.thrombectomy =
                              value;
                          controller.scriptModel.refresh();
                        }),
                    if (controller
                        .scriptModel.value.stroke?.thrombectomy !=
                        null &&
                        controller
                            .scriptModel.value.stroke?.thrombectomy ==
                            true)
                      TitleTextFormField(
                        isRequired: true,
                        title: "Specify Thrombectomy",
                        controller: TextEditingController(
                            text: controller.scriptModel.value.stroke
                                ?.thrombectomyDtls ??
                                ""),
                        keyboardType: TextInputType.name,
                        hintText: 'Enter Specify Thrombectomy',
                        onChanged: (v) {
                          controller.scriptModel.value.stroke
                              ?.thrombectomyDtls = v;
                        },
                      ),
                    NewTitleYesRadio(
                        isRequired: true,
                        title: 'Decompression Craniectomy',
                        initialValue: controller.scriptModel.value.stroke!
                            .decompressionCraniectomy,
                        onChanged: (value) {
                          controller.scriptModel.value.stroke
                              ?.decompressionCraniectomy = value;
                          controller.scriptModel.refresh();
                        }),
                    if (controller.scriptModel.value.stroke
                        ?.decompressionCraniectomy !=
                        null &&
                        controller.scriptModel.value.stroke
                            ?.decompressionCraniectomy ==
                            true)
                      TitleTextFormField(
                        isRequired: true,
                        title: "Specific Craniectomy",
                        controller: TextEditingController(
                            text: controller.scriptModel.value.stroke
                                ?.decompressionCraniectomyDtls ??
                                ""),
                        keyboardType: TextInputType.name,
                        hintText: 'Enter Specific Craniectomy',
                        onChanged: (v) {
                          controller.scriptModel.value.stroke
                              ?.decompressionCraniectomyDtls = v;
                        },
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "DISCHARGE STATUS",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    outcomeWidget(),
                    TitleTextFormField(
                      isRequired: false,
                      title: "Duration of hospital stay",
                      controller: TextEditingController(
                          text: controller.scriptModel.value.outcome
                              ?.durationStay !=
                              null
                              ? controller.scriptModel.value.outcome
                              ?.durationStay
                              .toString()
                              : ""),
                      keyboardType: TextInputType.name,
                      hintText: 'Enter Duration',
                      onChanged: (v) {
                        controller.scriptModel.value.outcome?.durationStay =
                            int.tryParse(v);
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CommonElevatedButtonM(
                        text: 'Proceed',
                        onPressed: () async {
                          controller.scriptModel.value.stroke?.triageId =
                              int.parse(widget.triageId!);

                          // Validate the form using our helper method
                          /// Save or Submit
                          showDialog(
                            context: context,
                            builder: (context) => SaveOrSubmitDialog(
                                title: 'Script',
                                content: 'Do you want to save or submit?',
                                onSave: () async {
                                  if (_validateFormSave()) {
                                    controller.scriptModel.value.stroke
                                        ?.triageId =
                                        int.parse(widget.triageId!);
                                    controller.scriptModel.value.outcome
                                        ?.isDischarged = false;
                                    log('Script Data :${controller.scriptModel.value}');
                                    if (widget.isUpdate) {
                                      await controller.updateScript(
                                        data:
                                        controller.scriptModel.value,
                                        id: widget.strokeId!,
                                      );
                                      Get.back();
                                    } else {
                                      await controller.createScript(
                                        data:
                                        controller.scriptModel.value,
                                      );
                                      Get.back();
                                    }
                                    Get.back();
                                  }
                                },
                                onSubmit: () async {
                                  if (_validateForm()) {
                                    controller.scriptModel.value.stroke
                                        ?.triageId =
                                        int.parse(widget.triageId!);
                                    controller.scriptModel.value.outcome
                                        ?.isDischarged = true;
                                    if (widget.isUpdate) {
                                      await controller.updateScript(
                                        data:
                                        controller.scriptModel.value,
                                        id: widget.strokeId!,
                                      );
                                      Get.back();
                                    } else {
                                      await controller.createScript(
                                        data:
                                        controller.scriptModel.value,
                                      );
                                      Get.back();
                                    }
                                    Get.back();
                                  }
                                }),
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget outcomeWidget() {
    return Column(
      spacing: 18,
      children: [
        NewTitleDropdown(
            title: 'Out come',
            isRequired: true,
            hint: 'Select Out come',
            items: controller.lookupList.value?.outcome
                ?.map((e) => {
              "id": e.id ?? "",
              "name": e.name ?? "",
            })
                .toList() ??
                [],
            selectedId: controller.scriptModel.value.outcome?.outcome,
            onChanged: (value) {
              controller.scriptModel.value.outcome?.outcome = value;
              log(controller.scriptModel.value.outcome!.outcome.toString());
              controller.scriptModel.refresh();
            }),
        if (controller.scriptModel.value.outcome?.outcome != null &&
            controller.scriptModel.value.outcome?.outcome == 1)
          Column(
            spacing: 17,
            children: [
              CommonDateTimeWidget(
                title: "Discharged Date",
                dateTime: controller.scriptModel.value.outcome?.dischargeDate,
                onChanged: (value) {
                  controller.scriptModel.value.outcome?.dischargeDate = value;
                },
              ),
              TitleTextFormField(
                isRequired: true,
                title: 'Drug Prescribed',
                hintText: 'Enter Drug Prescribed',
                controller: TextEditingController(
                  text: controller.scriptModel.value.outcome?.drugPrescribed,
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  controller.scriptModel.value.outcome?.drugPrescribed = value;
                },
              ),
              TitleTextFormField(
                isRequired: true,
                title: 'Treatment given',
                hintText: 'Enter Treatment given',
                controller: TextEditingController(
                  text: controller.scriptModel.value.outcome?.treatmentGiven,
                ),
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  controller.scriptModel.value.outcome?.treatmentGiven = value;
                },
              ),
            ],
          ),
        if (controller.scriptModel.value.outcome?.outcome != null &&
            controller.scriptModel.value.outcome?.outcome == 2)
          CommonDateTimeWidget(
            title: "Discharged Static Date",
            dateTime: controller.scriptModel.value.outcome?.dischargeStaticDate,
            onChanged: (value) {
              controller.scriptModel.value.outcome?.dischargeStaticDate = value;
            },
          ),
        if (controller.scriptModel.value.outcome?.outcome != null &&
            controller.scriptModel.value.outcome?.outcome == 3)
          CommonDateTimeWidget(
            title: "DAMA Date",
            dateTime: controller.scriptModel.value.outcome?.damaDate,
            onChanged: (value) {
              controller.scriptModel.value.outcome?.damaDate = value;
            },
          ),
        if (controller.scriptModel.value.outcome?.outcome != null &&
            controller.scriptModel.value.outcome?.outcome == 4)
          CommonDateTimeWidget(
            title: "Absconded Date",
            dateTime: controller.scriptModel.value.outcome?.abscondedDate,
            onChanged: (value) {
              controller.scriptModel.value.outcome?.abscondedDate = value;
            },
          ),
        if (controller.scriptModel.value.outcome?.outcome != null &&
            controller.scriptModel.value.outcome?.outcome == 5)
          CommonDateTimeWidget(
            title: "Death Date",
            dateTime: controller.scriptModel.value.outcome?.deathDate,
            onChanged: (value) {
              controller.scriptModel.value.outcome?.deathDate = value;
            },
          ),
        if (controller.scriptModel.value.outcome?.outcome != null &&
            controller.scriptModel.value.outcome?.outcome == 6)
          Column(
            spacing: 18,
            children: [
              NewTitleDropdown(
                  title: 'Hospital Type',
                  hint: 'Select Hospital Type',
                  isRequired: true,
                  items: controller.lookupList.value?.hospitalType
                      ?.map((e) => {
                    "id": e.id ?? "",
                    "name": e.name ?? "",
                  })
                      .toList() ??
                      [],
                  selectedId: controller.scriptModel.value.outcome?.hospitalType,
                  onChanged: (value) {
                    controller.scriptModel.value.outcome?.hospitalType = value;
                    controller.scriptModel.refresh();
                  }),
              if (controller.scriptModel.value.outcome?.hospitalType != null &&
                  controller.scriptModel.value.outcome?.hospitalType == 1)
                NewTitleDropdown(
                    title: 'Destination hospital',
                    hint: 'Select Destination hospital',
                    isRequired: true,
                    items: hospitalController.hospitalList
                        .map((e) => {
                      "hospitalid": e.hospitalid ?? "",
                      "hospitalname": e.hospitalname ?? "",
                    })
                        .toList(),
                    selectedId: controller
                        .scriptModel.value.outcome?.destinationTaeiHospital,
                    onChanged: (value) {
                      controller.scriptModel.value.outcome
                          ?.destinationTaeiHospital = value;
                      controller.scriptModel.refresh();
                    }),
              if (controller.scriptModel.value.outcome?.hospitalType != null &&
                  controller.scriptModel.value.outcome?.hospitalType == 2)
                TitleTextFormField(
                  isRequired: true,
                  title: 'Destination Non TAEI hospital',
                  hintText: 'Enter Destination Non TAEI hospital',
                  controller: TextEditingController(
                    text: controller
                        .scriptModel.value.outcome?.destinationHospital,
                  ),
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    controller.scriptModel.value.outcome?.destinationHospital =
                        value;
                  },
                ),
              NewTitleDropdown(
                  title: 'Reason for referral',
                  hint: 'Select Reason',
                  isRequired: true,
                  items: controller.lookupList.value?.reasonForReferral
                      ?.map((e) => {
                    "id": e.id ?? "",
                    "name": e.name ?? "",
                  })
                      .toList() ??
                      [],
                  selectedId:
                  controller.scriptModel.value.outcome?.reasonForReferral,
                  onChanged: (value) {
                    controller.scriptModel.value.outcome?.reasonForReferral =
                        value;
                    controller.scriptModel.refresh();
                  }),
              NewTitleDropdown(
                  title: 'Condition of patient',
                  hint: 'Select Condition',
                  isRequired: true,
                  items: controller.lookupList.value?.conditionOfPatient
                      ?.map((e) => {
                    "id": e.id ?? "",
                    "name": e.name ?? "",
                  })
                      .toList() ??
                      [],
                  selectedId:
                  controller.scriptModel.value.outcome?.conditionOfPatient,
                  onChanged: (value) {
                    controller.scriptModel.value.outcome?.conditionOfPatient =
                        value;
                    controller.scriptModel.refresh();
                  }),
              TitleTextFormField(
                isRequired: true,
                title: 'Referring Doctor Name',
                controller: TextEditingController(
                    text:
                    controller.scriptModel.value.outcome?.referringDoctor),
                keyboardType: TextInputType.name,
                hintText: 'Enter Doctor Name',
                onChanged: (v) {
                  controller.scriptModel.value.outcome?.referringDoctor = v;
                },
              ),
              NewTitleYesRadio(
                  isRequired: true,
                  title: 'Whether details documented in TAEI Case sheet',
                  initialValue:
                  controller.scriptModel.value.outcome?.documentedTaeiSheet,
                  onChanged: (value) {
                    controller.scriptModel.value.outcome?.documentedTaeiSheet =
                        value;
                    controller.scriptModel.refresh();
                  }),
            ],
          )
      ],
    );
  }
}
