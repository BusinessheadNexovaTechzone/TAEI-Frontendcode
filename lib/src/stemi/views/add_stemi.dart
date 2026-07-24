import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/hospital/controller/hospital_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/stemi/views/stemi_op.dart';
import 'package:taei_gov/src/stemi/views/widget.dart';
import 'package:taei_gov/utils/common/appbar.dart';
import '../../../utils/common/common_check_box_list.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../../utils/common/list_data_radio_button.dart';
import '../../../utils/common/m_elevate_button.dart';
import '../../../utils/common/new_common_date_time_picker.dart';
import '../../../utils/common/newchecklistbox.dart';
import '../../../utils/common/save_submit_dialog.dart';
import '../../../utils/common/title_textfield.dart';
import '../../../utils/common/yes_or_no_radio_button.dart';
import '../../emo_user/model/emo_lookup_model.dart';
import '../../login/controller/login_controller.dart';
import '../../nurse_triage/controller/nurse_triage_controller.dart';
import '../controller/stemi_controller.dart'; // Adjust path
import '../model/request_model.dart';
import '../timemetric.dart';

class StemiFormPage extends StatefulWidget {
  final String? id;
  final bool? create;
  final String? triageId;
  final String? patientId;
  final String? triageDate;
  final bool? appbar;
  final int? discharge;
  const StemiFormPage(
      {Key? key,
      this.id,
      this.triageId,
      this.create = false,
      this.patientId,
      this.triageDate,
      this.appbar = true,
      this.discharge})
      : super(key: key);

  @override
  State<StemiFormPage> createState() => _StemiFormPageState();
}

class _StemiFormPageState extends State<StemiFormPage> {
  final StemiController stemiController = Get.put(StemiController());
  final NurseTriageController controller = Get.put(NurseTriageController());
  final LoginController localdata = Get.put(LoginController());
  final HospitalController hospitalController = Get.put(HospitalController());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var entryDate;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    debugPrint(widget.triageDate.toString() + "KKKKK");
    debugPrint(widget.id.toString() + "id");
    if (widget.triageDate != null) {
      entryDate = widget.triageDate;
    }
    debugPrint(entryDate.toString() + "triage Date");
    debugPrint(
      "${widget.create} 00-0 ${localdata.userDetails.value?.user?.hospital?.hospitalid ?? 'null'}",
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final model = stemiController.stemiModel.value;
    await Future.wait([
      stemiController.getStemiLookup(),
      controller.getLookup(),
    ]);
    // model
    //   ..opPatient = OpPatient()
    //   ..stemiAdmission = StemiAdmission()
    //   ..stemiClinicalAssessment = StemiClinicalAssessment()
    //   ..stemiTreatment = StemiTreatment()
    //   ..stemiOutcome = StemiOutcome()
    //   ..nstemiTreatment = NstemiTreatment()
    //   ..nstemiOutcome = NstemiOutcome()
    //   ..unstableanginaTreatment = UnstableAnginaTreatment()
    //   ..unstableanginaOutcome = UnstableAnginaOutcome()
    //   ..othersTreatment = OthersTreatment();    // model
    model..opPatient = OpPatient()
      ..stemiAdmission =
      StemiAdmission(triageId: int.parse(widget.triageId.toString()))
      ..stemiClinicalAssessment = StemiClinicalAssessment(
          triageId: int.parse(widget.triageId.toString()))
      ..stemiTreatment =
      StemiTreatment(triageId: int.parse(widget.triageId.toString()))
      ..stemiOutcome =
      StemiOutcome(triageId: int.parse(widget.triageId.toString()))
      ..nstemiTreatment =
      NstemiTreatment(triageId: int.parse(widget.triageId.toString()))
      ..nstemiOutcome =
      NstemiOutcome(triageId: int.parse(widget.triageId.toString()))
      ..unstableanginaTreatment = UnstableAnginaTreatment(
          triageId: int.parse(widget.triageId.toString()))
      ..unstableanginaOutcome =
      UnstableAnginaOutcome(triageId: int.parse(widget.triageId.toString()))
      ..othersTreatment =
      OthersTreatment(triageId: int.parse(widget.triageId.toString()));

    // Initialize models (done synchronously — very fast)


    // Run lookups in parallel to speed up

    // Fetch based on widget statsub

    if (widget.id != null) {
      if (widget.create == true) {
        debugPrint("op");
        await stemiController.getStemiOpById(id: widget.id!);
      } else {
        debugPrint("stemi");
        setState(() {
          stemiController.stemiModel.value.triageId =
              int.parse(widget.id.toString());
        });
        debugPrint(stemiController.stemiModel.value.triageId.toString());
        await stemiController.getStemiById(id: widget.id!);
      }
    } else {
      debugPrint(widget.triageId.toString());
      stemiController.stemiModel.refresh();
    }
    debugPrint(
        stemiController.stemiLookup.value.conservativeManagement.toString() +
            "999");
  }



  // fetchData() {
  //   // controller.createTriageModel(TriageModel(
  //   //     triage: Triage(),
  //   //     triageBy108: TriageBy108(),
  //   //     triageDtls: TriageDtls()));
  //   Future.delayed(Duration.zero, () async {
  //     if (widget.isUpdate == true) {
  //       await controller.getTriageById(id: widget.id ?? '');
  //     }
  //   });
  // }

  int day = 0;

  void updateHospitalStayDuration(String? dischargeDatetime) {
    final admissionStr = stemiController
        .stemiModel.value.stemiAdmission?.dateTimeAdmission
        ?.toString();
    final dischargeStrStemi = dischargeDatetime;
    final admission =
        (admissionStr != null) ? DateTime.tryParse(admissionStr) : null;
    final discharge = (dischargeStrStemi != null)
        ? DateTime.tryParse(dischargeStrStemi)
        : null;

    if (admission != null && discharge != null) {
      final duration = discharge.difference(admission);
      final days = duration.inDays;
      if (stemiController.stemiModel.value.stemiClinicalAssessment?.diagnosis ==
          1) {
        stemiController
            .stemiModel.value.unstableanginaTreatment?.hospitalStayDays = days;
      } else if (stemiController
              .stemiModel.value.stemiClinicalAssessment?.diagnosis ==
          2) {
        stemiController.stemiModel.value.nstemiTreatment?.hospitalStayDays =
            days;
      } else {
        stemiController.stemiModel.value.stemiTreatment?.hospitalStayDays =
            days;
      }
    } else {
      stemiController.stemiModel.value.stemiTreatment?.hospitalStayDays = 0;
      stemiController.stemiModel.value.nstemiTreatment?.hospitalStayDays = 0;
      stemiController
          .stemiModel.value.unstableanginaTreatment?.hospitalStayDays = 0;
    }
  }

  void calculateTimeDifferenceStemi(String? symptomOnset, String? fmcTime) {
    var minutes = 0;
    String display = "0 minutes";
    if (symptomOnset != null &&
        fmcTime != null &&
        symptomOnset.trim().isNotEmpty &&
        fmcTime.trim().isNotEmpty) {
      try {
        final onset = DateTime.tryParse(symptomOnset.trim());
        final fmc = DateTime.tryParse(fmcTime.trim());
        if (onset != null && fmc != null) {
          minutes = fmc.difference(onset).inMinutes;
          if (minutes < 0) minutes = 0;
          final hrs = minutes ~/ 60; // integer division
          final mins = minutes % 60; // remainder
          if (hrs > 0 && mins > 0) {
            display =
                "$hrs hour${hrs > 1 ? 's' : ''} $mins minute${mins > 1 ? 's' : ''}";
          } else if (hrs > 0) {
            display = "$hrs hour${hrs > 1 ? 's' : ''}";
          } else {
            display = "$mins minute${mins > 1 ? 's' : ''}";
          }
        } else {
          display = "null";
          minutes = 0;
        }
      } catch (e) {
        display = "null";
        minutes = 0;
      }
    }

    // if (stemiController.stemiModel.value.stemiClinicalAssessment?.diagnosis ==
    //     3) {
    stemiController.stemiModel.value.unstableanginaTreatment?.symptomToFmc =
        display;
    // } else if (stemiController
    //     .stemiModel.value.stemiClinicalAssessment?.diagnosis ==
    //     2) {
    stemiController.stemiModel.value.nstemiTreatment?.symptomToFmc = display;

    // } else if(stemiController
    //     .stemiModel.value.stemiClinicalAssessment?.diagnosis ==
    //     1) {
    stemiController.stemiModel.value.stemiTreatment?.symptomToFmc = display;
    setState(() {});
  }

  void calculateTimeDifference1Stemi(String? symptomOnset, String? fmcTime) {
    int minutes = 0;
    var display = "0";
    if (symptomOnset != null &&
        fmcTime != null &&
        symptomOnset.trim().isNotEmpty &&
        fmcTime.trim().isNotEmpty) {
      try {
        final onset = DateTime.tryParse(symptomOnset.trim());
        final fmc = DateTime.tryParse(fmcTime.trim());
        if (onset != null && fmc != null) {
          minutes = onset.difference(fmc).inMinutes;
          if (minutes < 0) minutes = 0;
          final hrs = minutes ~/ 60; // integer division
          final mins = minutes % 60; // remainder
          if (hrs > 0 && mins > 0) {
            display =
                "$hrs hour${hrs > 1 ? 's' : ''} $mins minute${mins > 1 ? 's' : ''}";
          } else if (hrs > 0) {
            display = "$hrs hour${hrs > 1 ? 's' : ''}";
          } else {
            display = "$mins minute${mins > 1 ? 's' : ''}";
          }
        } else {
          display = "null";
          minutes = 0;
        }
      } catch (e) {
        display = "null";
        minutes = 0;
      }
    }
    // if (stemiController.stemiModel.value.stemiClinicalAssessment?.diagnosis ==
    //     3) {
    stemiController.stemiModel.value.unstableanginaTreatment?.fmcToEcg =
        display;
    // } else if (stemiController
    //         .stemiModel.value.stemiClinicalAssessment?.diagnosis ==
    //     2) {

    stemiController.stemiModel.value.nstemiTreatment?.fmcToEcg = display;

    // } else if(stemiController
    //     .stemiModel.value.stemiClinicalAssessment?.diagnosis ==
    //     1) {
    stemiController.stemiModel.value.stemiTreatment?.fmcToEcg = display;
    setState(() {});
  }

  void calculateTimeDifference2Stemi(String? symptomOnset, String? fmcTime) {
    debugPrint("FMC Time: $fmcTime");
    var display = "0";

    if (symptomOnset != null &&
        fmcTime != null &&
        symptomOnset.trim().isNotEmpty &&
        fmcTime.trim().isNotEmpty) {
      try {
        // Parse dates and normalize to UTC
        final onset = DateTime.tryParse(symptomOnset.trim())?.toUtc();
        final fmc = DateTime.tryParse(fmcTime.trim())?.toUtc();

        debugPrint("Parsed onset (UTC): $onset");
        debugPrint("Parsed FMC (UTC): $fmc");

        if (onset != null && fmc != null) {
          int minutes = fmc.difference(onset).inMinutes;
          if (minutes < 0) minutes = 0;

          final hrs = minutes ~/ 60;
          final mins = minutes % 60;

          if (hrs > 0 && mins > 0) {
            display =
                "$hrs hour${hrs > 1 ? 's' : ''} $mins minute${mins > 1 ? 's' : ''}";
          } else if (hrs > 0) {
            display = "$hrs hour${hrs > 1 ? 's' : ''}";
          } else {
            display = "$mins minute${mins > 1 ? 's' : ''}";
          }
        } else {
          display = "Invalid date";
        }
      } catch (e) {
        display = "Invalid date";
        debugPrint("Error parsing dates: $e");
      }
    }

    // Assign safely
    final treatment = stemiController.stemiModel.value.stemiTreatment;
    if (treatment != null) {
      treatment.doorToNeedle = display;
    }

    setState(() {}); // refresh UI
    debugPrint("Door-to-Needle: ${treatment?.doorToNeedle}");
  }

  void calculateTimeDifference3Stemi(String? symptomOnset, String? fmcTime) {
    String display = "0 minutes";

    debugPrint("Symptom onset: $symptomOnset");
    debugPrint("FMC time: $fmcTime");

    if (symptomOnset != null &&
        fmcTime != null &&
        symptomOnset.trim().isNotEmpty &&
        fmcTime.trim().isNotEmpty) {
      final onset = DateTime.tryParse(symptomOnset.trim())?.toUtc();
      final fmc = DateTime.tryParse(fmcTime.trim())?.toUtc();

      debugPrint("Parsed onset (UTC): $onset");
      debugPrint("Parsed fmc (UTC): $fmc");

      if (onset != null && fmc != null) {
        int minutes = fmc.difference(onset).inMinutes;
        if (minutes < 0) minutes = 0;

        final hrs = minutes ~/ 60;
        final mins = minutes % 60;

        if (hrs > 0 && mins > 0) {
          display =
              "$hrs hour${hrs > 1 ? 's' : ''} $mins minute${mins > 1 ? 's' : ''}";
        } else if (hrs > 0) {
          display = "$hrs hour${hrs > 1 ? 's' : ''}";
        } else {
          display = "$mins minute${mins > 1 ? 's' : ''}";
        }
      } else {
        display = "Invalid date";
      }
    }

    final treatment = stemiController.stemiModel.value.stemiTreatment;
    if (treatment != null) {
      treatment.doorToBalloon = display;
    }

    setState(() {});
    debugPrint("Door-to-balloon: ${treatment?.doorToBalloon}");
  }

  void calculateTimeDifference2NStemi(
      String? balloonInflation, String? triage) {
    int minutes = 0;
    String display = "0 minutes";
    debugPrint(triage.toString() + "Time Checker");
    if (balloonInflation != null &&
        triage != null &&
        balloonInflation.trim().isNotEmpty &&
        triage.trim().isNotEmpty) {
      try {
        final onset = DateTime.tryParse(balloonInflation.trim());
        final fmc = DateTime.tryParse(triage.trim());

        if (onset != null && fmc != null) {
          minutes = fmc.difference(onset).inMinutes;
          if (minutes < 0) minutes = 0;
          final hrs = minutes ~/ 60; // integer division
          final mins = minutes % 60; // remainder
          if (hrs > 0 && mins > 0) {
            display =
                "$hrs hour${hrs > 1 ? 's' : ''} $mins minute${mins > 1 ? 's' : ''}";
          } else if (hrs > 0) {
            display = "$hrs hour${hrs > 1 ? 's' : ''}";
          } else {
            display = "$mins minute${mins > 1 ? 's' : ''}";
          }
        } else {
          display = "null";
          minutes = 0;
        }
      } catch (e) {
        display = "null";
        minutes = 0;
      }
    }
    stemiController.stemiModel.value.nstemiTreatment?.doorToBalloon = display;
    setState(() {});
  }

  void calculateTimeDifference2Unstable(String? symptomOnset, String? fmcTime) {
    int minutes = 0;
    String display = "0 minutes";
    if (symptomOnset != null &&
        fmcTime != null &&
        symptomOnset.trim().isNotEmpty &&
        fmcTime.trim().isNotEmpty) {
      try {
        final onset = DateTime.tryParse(symptomOnset.trim());
        final fmc = DateTime.tryParse(fmcTime.trim());

        if (onset != null && fmc != null) {
          minutes = fmc.difference(onset).inMinutes;
          if (minutes < 0) minutes = 0;
          final hrs = minutes ~/ 60; // integer division
          final mins = minutes % 60; // remainder
          if (hrs > 0 && mins > 0) {
            display =
                "$hrs hour${hrs > 1 ? 's' : ''} $mins minute${mins > 1 ? 's' : ''}";
          } else if (hrs > 0) {
            display = "$hrs hour${hrs > 1 ? 's' : ''}";
          } else {
            display = "$mins minute${mins > 1 ? 's' : ''}";
          }
        } else {
          display = "null";
          minutes = 0;
        }
      } catch (e) {
        display = "null";
        minutes = 0;
      }
    }
    stemiController.stemiModel.value.unstableanginaTreatment?.doorToBalloon =
        display;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // updateHospitalStayDuration();
    return Scaffold(
      backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
      appBar: widget.appbar == false
          ? null
          : CommonAppBar(
              title: widget.create == true
                  ? context.isDesktop
                      ? 'OP Form'
                      : 'OP Form'
                  : context.isDesktop
                      ? 'Form'
                      : 'Form',
              id: widget.triageId,
            ),
      // appBar: AppBar(
      //   backgroundColor: Colors.redAccent,
      //   title: widget.create == true
      //       ? context.isDesktop
      //           ? Center(child: Text('OP Form'))
      //           : Text('OP Form')
      //       : context.isDesktop
      //           ? Center(child: Text('Form'))
      //           : Text('Form'),
      // ),
      body: Obx(() {
        if (stemiController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final model = stemiController.stemiModel.value;
        final stemiAdmission = model.stemiAdmission;
        final op = model.opPatient;
        final stemiClinicalAssessment = model.stemiClinicalAssessment;
        final stemiTreatment = model.stemiTreatment;
        final stemiOutcome = model.stemiOutcome;
        final nstemiOutcome = model.nstemiOutcome;
        final nstemiTreatment = model.nstemiTreatment;
        final unstableanginaOutcome = model.unstableanginaOutcome;
        final unstableanginaTreatment = model.unstableanginaTreatment;
        final otherTreatment = model.othersTreatment;
        final triageId = int.tryParse(widget.triageId?.toString() ?? "");
        model.stemiOutcome?.outcomeTypeId ?? 1;

        if (widget.create == true) {
          model.patientId = 0;
          model.triageId = 0;
          model.opPatient?.institutionId =
              localdata.userDetails.value?.user?.hospital?.hospitalid;
          stemiAdmission?.triageId = 0;
          stemiClinicalAssessment?.triageId = 0;
          stemiTreatment?.triageId = 0;
          stemiOutcome?.triageId = 0;
          nstemiOutcome?.triageId = 0;
          nstemiTreatment?.triageId = 0;
          unstableanginaOutcome?.triageId = 0;
          unstableanginaTreatment?.triageId = 0;
          otherTreatment?.triageId = 0;
        } else {
          // model.triageId = int.tryParse(widget.triageId.toString())!;
          if (triageId != null) {
            // model.triageId = int.tryParse(widget.triageId.toString());
            stemiAdmission?.triageId = triageId;
            stemiClinicalAssessment?.triageId = triageId;
            stemiTreatment?.triageId = triageId;
            stemiOutcome?.triageId = triageId;
            nstemiOutcome?.triageId = triageId;
            nstemiTreatment?.triageId = triageId;
            unstableanginaOutcome?.triageId = triageId;
            unstableanginaTreatment?.triageId = triageId;
          }
        }

        return SafeArea(
          child: Container(
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
            child: Form(
              key: _formKey,
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: context.isDesktop
                        ? EdgeInsets.only(
                            left: 30, right: 30, top: 8, bottom: 8)
                        : EdgeInsets.all(10),
                    child: Column(
                      spacing: 25,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.create == true) ...[
                          TitleTextFormField(
                            title: "Name of Patient",
                            hintText: "Enter Name",
                            initialValue: op?.nameOfPatient,
                            onChanged: (val) {
                              op?.nameOfPatient = val;
                              stemiController.stemiModel.refresh();
                            },
                          ),
                          TitleTextFormField(
                            title: "Age",
                            hintText: "Enter Name",
                            initialValue:
                                op?.age != null ? op!.age.toString() : "",
                            onChanged: (val) {
                              op?.age = int.parse(val.toString());
                              stemiController.stemiModel.refresh();
                            },
                          ),

                          // Obx(() {
                          //   final list =
                          //       stemiController.stemiLookup.value.agelist ?? [];
                          //   if (list.isEmpty) {
                          //     return const Text("No Age options available");
                          //   }
                          //   return NewTitleDropdown(
                          //     title: "Age",
                          //     hint: "Select Age",
                          //     items: list
                          //         .map((e) => {"id": e.id, "name": e.name})
                          //         .toList(),
                          //     selectedId: op!.age != null
                          //         ? (op.age!.toInt() > 4)
                          //             ? 1
                          //             : op.age
                          //         : op.gender,
                          //     onChanged: (val) {
                          //       op.age = val;
                          //       stemiController.stemiModel.refresh();
                          //     },
                          //   );
                          // }),

                          // if (op.age! < 1 || op.age! > 18)
                          TitleTextFormField(
                            title: "Father/Mother Name",
                            hintText: "Enter Name",
                            initialValue: op?.fathername,
                            onChanged: (val) {
                              op?.fathername = val;
                              stemiController.stemiModel.refresh();
                            },
                          ),

                          // TitleTextFormField(
                          //   title: "Father/Mother Name",
                          //   hintText: "Enter Name",
                          //   initialValue: op?.mothername,
                          //   onChanged: (val) {
                          //     op?.fathername = val;
                          //     stemiController.stemiModel.refresh();
                          //   },
                          // ),

                          /// Gender
                          Obx(() {
                            final list = stemiController.stemiLookup.value
                                    .triageResponse?.genders ??
                                [];
                            if (list.isEmpty) {
                              return const Text("No Gender options available");
                            }
                            return NewTitleDropdown(
                              isRequired: true,
                              title: "Gender",
                              hint: "Select Gender",
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: op?.gender,
                              onChanged: (val) {
                                op?.gender = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),

                          /// IP No
                          TitleTextFormField(
                            title: "Patient IP No",
                            hintText: "Enter IP Number",
                            initialValue: op?.patientOpNumber,
                            onChanged: (val) {
                              op?.patientOpNumber = val;
                              stemiController.stemiModel.refresh();
                            },
                          ),

                          /// Marital Status
                          Obx(() {
                            final list = stemiController
                                    .stemiLookup.value.triageResponse?.mtSts ??
                                [];
                            if (list.isEmpty) {
                              return const Text(
                                  "No Marital Status options available");
                            }
                            return NewTitleDropdown(
                              isRequired: true,
                              title: "Marital Status",
                              hint: "Select Marital Status",
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: op?.maritalStatus,
                              onChanged: (val) {
                                op?.maritalStatus = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),

                          /// Mobile Number
                          TitleTextFormField(
                            title: "Patient Mobile Number",
                            hintText: "Enter Mobile Number",
                            initialValue: op?.patientMobileNumber,
                            onChanged: (val) =>
                                setState(() => op?.patientMobileNumber = val),
                          ),

                          /// Education
                          Obx(() {
                            final list = stemiController
                                    .stemiLookup.value.triageResponse?.edu ??
                                [];
                            if (list.isEmpty) {
                              return const Text(
                                  "No Education options available");
                            }
                            return NewTitleDropdown(
                              title: "Education",
                              hint: "Select Education",
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: op?.education,
                              onChanged: (val) {
                                op?.education = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),

                          /// Employment Status
                          Obx(() {
                            final list = stemiController
                                    .stemiLookup.value.triageResponse!.empSts ??
                                [];
                            if (list.isEmpty) {
                              return const Text(
                                  "No Employment Status options available");
                            }
                            return NewTitleDropdown(
                              title: "Employment Status",
                              hint: "Select Employment Status",
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: op?.employmentStatus,
                              onChanged: (val) {
                                op?.employmentStatus = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),

                          /// Occupation
                          Obx(() {
                            final list = stemiController
                                    .stemiLookup.value.triageResponse?.occ ??
                                [];
                            if (list.isEmpty) {
                              return const Text(
                                  "No Occupation options available");
                            }
                            return NewTitleDropdown(
                              title: "Occupation",
                              hint: "Select Occupation",
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: op?.occupation,
                              onChanged: (val) {
                                op?.occupation = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),

                          /// Income
                          TitleTextFormField(
                            title: "Income/month",
                            hintText: "Enter Income",
                            initialValue: op?.income,
                            onChanged: (val) =>
                                setState(() => op?.income = val),
                          ),

                          /// Other Text Fields
                          // Obx(() {
                          //   final list = stemiController.stemiLookup.value.ehrId ?? [];
                          //   if (list.isEmpty) {
                          //     return const Text("No options available");
                          //   }
                          //   return NewTitleDropdown(
                          //     title: "Patient EHR ID",
                          //     hint: "Select",
                          //     items: list
                          //         .map((e) => {"id": e.id, "name": e.name})
                          //         .toList(),
                          //     selectedId: op!.patientEhrId == 1 ? false : true, // map 1 to false, 0 to true
                          //     onChanged: (val) {
                          //       setState(() {
                          //         // Map boolean from dropdown to 0/1 in your model
                          //         if (val == true) {
                          //           op!.patientEhrId = val as bool?; // true -> 0
                          //         } else {
                          //           op!.patientEhrId = val; // false -> 1
                          //         }
                          //       });
                          //       stemiController.stemiModel.refresh();
                          //     },
                          //   );
                          // }),

                          // Patient EHR (ID) - all health related ID should be autopopulated at latest stage
                          TitleTextFormField(
                            title: "CMCHIS Card",
                            hintText: "Enter CMCHIS ID",
                            initialValue: op?.cmchisCard ?? "",
                            onChanged: (val) =>
                                setState(() => op?.cmchisCard = val),
                          ),
                          TitleTextFormField(
                            title: "ABHA Card",
                            hintText: "Enter ABHA ID",
                            initialValue: op?.abhaCard ?? "",
                            onChanged: (val) =>
                                setState(() => op?.abhaCard = val),
                          ),
                          TitleTextFormField(
                            title: "PHR ID",
                            hintText: "Enter PHR ID",
                            initialValue: op?.phrId ?? "",
                            onChanged: (val) => setState(() => op?.phrId = val),
                          ),
                          TitleTextFormField(
                            title: "HMIS ID",
                            hintText: "Enter HMIS ID",
                            initialValue: op?.hmisId ?? "",
                            onChanged: (val) =>
                                setState(() => op?.hmisId = val),
                          ),
                          Column(
                            mainAxisSize:
                                MainAxisSize.min, // shrink to fit children
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Residential Address",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              ReusableAddressWidget(
                                title: "Residential Address",
                                op: op,
                                stemiController: stemiController,
                              ),
                            ],
                          )
                        ],
                        CommonDateTimeWidget(
                          isRequired: true,
                          title: "Date of entry",
                          dateTime: model.stemiAdmission?.dateTimeEntry ?? "",
                          onChanged: (picked) {
                            final pickedDate = picked.toString() ?? "";
                            model.stemiAdmission?.dateTimeEntry = pickedDate;
                            entryDate = widget.triageDate ?? pickedDate;
                            stemiController.stemiModel.refresh();
                          },
                        ),
                        NewTitleYesRadio(
                          initialValue:
                              model.stemiAdmission?.isAdmitted,
                          title: "Patient Admitted",
                          onChanged: (value) {
                            model.stemiAdmission?.isAdmitted = value;
                            stemiController.stemiModel.refresh();
                            updateHospitalStayDuration(
                                stemiOutcome?.dischargeDatetime.toString());
                          },
                        ),
                        if (model.stemiAdmission?.isAdmitted == true) ...[
                          TitleTextFormField(
                              title: "Name of the Admitting Department",
                              hintText: "Enter Department",
                              initialValue:
                                  stemiAdmission?.departmentName ?? "",
                              onChanged: (value) {
                                stemiAdmission?.departmentName = value;
                                stemiController.stemiModel.refresh();
                              }),
                          CommonDateTimeWidget(
                            title: "Date of Admission",
                            dateTime: model.stemiAdmission?.dateTimeAdmission
                                    ?.toString() ??
                                "",
                            onChanged: (picked) {
                              stemiAdmission?.dateTimeAdmission =
                                  picked.toString();
                              // updateHospitalStayDuration();
                              stemiController.stemiModel.refresh();
                            },
                          ),
                        ],
                        Center(child: Text("Clinical Assessment & Diagnosis")),
                        CommonDateTimeWidget(
                          title: "Date and Time of Symptom Onset",
                          dateTime: stemiClinicalAssessment
                                  ?.symptomOnsetDatetime
                                  ?.toString() ??
                              "",
                          onChanged: (picked) {
                            stemiClinicalAssessment?.symptomOnsetDatetime =
                                picked.toString();
                            debugPrint(stemiClinicalAssessment!
                                    .symptomOnsetDatetime
                                    .toString() +
                                "))");

                            calculateTimeDifferenceStemi(
                              stemiClinicalAssessment?.symptomOnsetDatetime,
                              stemiClinicalAssessment?.fmcDatetime,
                            );

                            stemiController.stemiModel.refresh();
                          },
                        ),

                        // Obx(() {
                        //   final lookupList =
                        //       stemiController.stemiLookup.value.signSymptom ?? [];
                        //
                        //   if (lookupList.isEmpty) {
                        //     return const Text(
                        //         "No Type of Signs/Symptoms available");
                        //   }
                        //
                        //   // Convert to the format your custom checkbox widget expects
                        //   final options = lookupList
                        //       .map((e) => LooksUpItem(id: e.id, name: e.name))
                        //       .toList();
                        //
                        //   // Get selected IDs from your model as a list of ints
                        //   final selectedIds = (model
                        //               .stemiClinicalAssessment?.signsSymtoms
                        //               ?.split(',') ??
                        //           [])
                        //       .map((e) => int.tryParse(e.trim()) ?? 0)
                        //       .where((e) => e != 0)
                        //       .toList();
                        //
                        //   return Column(
                        //     spacing: 25,
                        //     // crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       // NewCustomCheckboxList(
                        //       //   title: "Presenting signs & symptoms",
                        //       //   options: options,
                        //       //   initialIds: selectedIds, // Pass initial selection
                        //       //   onChanged: (ids) {
                        //       //     model.stemiClinicalAssessment!.signsSymtoms =
                        //       //         ids.join(',');
                        //       //     stemiController.stemiModel
                        //       //         .refresh(); // Refresh UI
                        //       //   },
                        //       // ),
                        //       if (selectedIds.contains(10)) ...[
                        //         TitleTextFormField(
                        //           title: "Enter the Symptoms",
                        //           hintText: "Enter Symptoms",
                        //           initialValue: model.stemiClinicalAssessment
                        //                   ?.otherSignsSymtoms ??
                        //               '',
                        //           onChanged: (value) {
                        //             model.stemiClinicalAssessment
                        //                 ?.otherSignsSymtoms = value;
                        //           },
                        //         ),
                        //       ],
                        //     ],
                        //   );
                        // }),

                        Obx(() {
                          final lookupList =
                              stemiController.stemiLookup.value.signSymptom ??
                                  [];

                          if (lookupList.isEmpty) {
                            return const Text(
                              "No Type of Signs/Symptoms available",
                              style: TextStyle(color: Colors.black54),
                            );
                          }

                          // Convert lookup data to LooksUpItem
                          final options = lookupList
                              .map((e) => LooksUpItem(id: e.id, name: e.name))
                              .toList();

                          // Parse selected IDs from the model
                          final selectedIds = (model
                                      .stemiClinicalAssessment?.signsSymtoms
                                      ?.split(',') ??
                                  [])
                              .map((e) => int.tryParse(e.trim()) ?? 0)
                              .where((id) => id != 0)
                              .toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NewCheckboxList(
                                isRequired: true,
                                title: "Presenting signs & symptoms",
                                options: options,
                                initialSelectedIndexes: selectedIds,
                                onChanged: (selectedValues) {
                                  model.stemiClinicalAssessment?.signsSymtoms =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // Refresh GetX reactive state
                                },
                              ),
                              if (selectedIds.contains(10)) ...[
                                const SizedBox(height: 16),
                                TitleTextFormField(
                                  title: "Enter the Symptoms",
                                  hintText: "Enter Symptoms",
                                  initialValue: model.stemiClinicalAssessment
                                          ?.otherSignsSymtoms ??
                                      '',
                                  onChanged: (value) {
                                    model.stemiClinicalAssessment
                                        ?.otherSignsSymtoms = value;
                                  },
                                ),
                              ],
                            ],
                          );
                        }),
                        Obx(() {
                          final list =
                              stemiController.stemiLookup.value.cvRiskFactor ??
                                  [];

                          if (list.isEmpty) {
                            return const Text(
                              "No Type of Cardiovascular Risk Factors available",
                              style: TextStyle(color: Colors.black54),
                            );
                          }

                          // Convert lookup list to LooksUpItem model (used by your custom checkbox widget)
                          final options = list
                              .map((e) => LooksUpItem(id: e.id, name: e.name))
                              .toList();

                          // Parse comma-separated IDs from model string to List<int>
                          final selectedIds = (stemiClinicalAssessment
                                      ?.riskFactors
                                      ?.split(',') ??
                                  [])
                              .map((e) => int.tryParse(e.trim()) ?? 0)
                              .where((id) => id != 0)
                              .toList();

                          return NewCheckboxList(
                            isRequired: true,
                            title: "Known cardiovascular risk",
                            options: options,
                            initialSelectedIndexes: selectedIds,
                            onChanged: (selectedValues) {
                              stemiClinicalAssessment?.riskFactors =
                                  selectedValues.join(',');
                              stemiController.stemiModel
                                  .refresh(); // ✅ Refresh GetX reactive model
                            },
                          );
                        }),

                        Obx(() {
                          final list =
                              stemiController.stemiLookup.value.fmc ?? [];
                          if (list.isEmpty) {
                            return const Text("No Type of Sting available");
                          }
                          return NewTitleDropdown(
                            isRequired: true,
                            title: 'Type of first medical contact',
                            hint: 'Select Type',
                            items: list
                                .map((e) => {"id": e.id, "name": e.name})
                                .toList(),
                            selectedId: stemiClinicalAssessment?.fmcType,
                            onChanged: (val) {
                              stemiClinicalAssessment?.fmcType = val;
                              stemiController.stemiModel.refresh();
                            },
                          );
                        }),
                        CommonDateTimeWidget(
                          title: "Date and Time of First Medical Contact (FMC)",
                          dateTime: stemiClinicalAssessment?.fmcDatetime
                                  ?.toString() ??
                              "",
                          onChanged: (picked) {
                            // ✅ Update the model
                            stemiClinicalAssessment?.fmcDatetime =
                                picked.toString();

                            // ✅ Recalculate only after both are selected

                            calculateTimeDifferenceStemi(
                              stemiClinicalAssessment?.symptomOnsetDatetime,
                              stemiClinicalAssessment?.fmcDatetime,
                            );

                            calculateTimeDifference1Stemi(
                              stemiClinicalAssessment?.ecgDatetime,
                              stemiClinicalAssessment?.fmcDatetime,
                            );

                            stemiController.stemiModel.refresh();
                          },
                        ),
                        // ECG Taken (Date & Time)
                        CommonDateTimeWidget(
                          title: "ECG Taken (Date & Time)",
                          dateTime:
                              stemiClinicalAssessment?.ecgDatetime.toString() ??
                                  "",
                          onChanged: (picked) {
                            stemiClinicalAssessment?.ecgDatetime =
                                picked.toString();
                            calculateTimeDifference1Stemi(
                              stemiClinicalAssessment?.ecgDatetime,
                              stemiClinicalAssessment?.fmcDatetime,
                            );
                            stemiController.stemiModel.refresh();
                          },
                        ),
                        Obx(() {
                          final list =
                              stemiController.stemiLookup.value.ecgLocation ??
                                  [];
                          if (list.isEmpty) {
                            return const Text("No Type of Sting available");
                          }
                          return NewTitleDropdown(
                            title: 'ECG performed at:',
                            hint: 'Select Type',
                            items: list
                                .map((e) => {"id": e.id, "name": e.name})
                                .toList(),
                            selectedId: stemiClinicalAssessment?.ecgLocation,
                            onChanged: (val) {
                              stemiClinicalAssessment?.ecgLocation = val;
                              stemiController.stemiModel.refresh();
                            },
                          );
                        }),
                        Obx(() {
                          final list =
                              stemiController.stemiLookup.value.diagnosis ?? [];
                          if (list.isEmpty) {
                            return const Text("No Type of Sting available");
                          }
                          return NewTitleDropdown(
                            isRequired: true,
                            title: 'Diagnosis (STEMI, NSTEMI, Unstable Angina)',
                            hint: 'Select Type',
                            items: list
                                .map((e) => {"id": e.id, "name": e.name})
                                .toList(),
                            selectedId: stemiClinicalAssessment?.diagnosis,
                            onChanged: (val) {
                              stemiClinicalAssessment?.diagnosis = val;
                              stemiController.stemiModel.refresh();
                            },
                          );
                        }),
                        if (stemiClinicalAssessment?.diagnosis == 4) ...[
                          TitleTextFormField(
                            title: "Other Specify",
                            hintText: "Others",
                            initialValue:
                                model.stemiClinicalAssessment?.otherDignosis,
                            onChanged: (value) {
                              model.stemiClinicalAssessment?.otherDignosis =
                                  value;
                            },
                          ),
                        ],

                        // Center(
                        //     child: Text(
                        //   "Treatment",
                        //   style: TextStyle(),
                        // )),
                        //3
                        if (stemiClinicalAssessment?.diagnosis == 3) ...[
                          Center(child: Text("Stemi")),
                          CommonDateTimeWidget(
                            isRequired: true,
                            title: "STEMI Confirmed (Date & Time)",
                            dateTime:
                                model.stemiTreatment?.stemiConfirmedAt ?? "",
                            onChanged: (picked) {
                              // Ensure stemiTreatment object exists
                              model.stemiTreatment ??= StemiTreatment();
                              model.stemiTreatment!.stemiConfirmedAt =
                                  picked.toString();

                              // Refresh the reactive model so UI updates
                              stemiController.stemiModel.refresh();
                            },
                          ),
                          //3a
                          Obx(() {
                            final list = stemiController
                                    .stemiLookup.value.infarctionLocation ??
                                [];
                            if (list.isEmpty) {
                              return const Text("No Type of Sting available");
                            }
                            return NewTitleDropdown(
                              isRequired: true,
                              title: 'Location of Infarction based on ECG',
                              hint: 'Select Type',
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: stemiTreatment?.infarctionLocationId,
                              onChanged: (val) {
                                stemiTreatment?.infarctionLocationId = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),

                          //3b
                          // Obx(() {
                          //   final list = stemiController
                          //           .stemiLookup.value.loadingDoseLocation ??
                          //       [];
                          //
                          //   final selectedId = stemiController.stemiModel.value
                          //       .stemiTreatment?.loadingDoseLocationId;
                          //
                          //   if (list.isEmpty) {
                          //     return const SizedBox();
                          //   }
                          //
                          //   return NewCustomRadioList(
                          //     title: "Loading Dose given at",
                          //     options: list
                          //         .map((e) =>
                          //             LooksUpItem(id: e.id, name: e.name))
                          //         .toList(),
                          //     initialId: selectedId,
                          //     onChanged: (id) {
                          //       stemiController.stemiModel.update((model) {
                          //         model?.stemiTreatment?.loadingDoseLocationId =
                          //             id;
                          //       });
                          //       debugPrint(
                          //           "Updated loadingDoseLocationId: $id");
                          //     },
                          //   );
                          // }),

                          Obx(() {
                            final list = stemiController
                                    .stemiLookup.value.loadingDoseLocation ??
                                [];

                            if (list.isEmpty) {
                              return const Text("No Type of Sting available");
                            }

                            int? selectedId =
                                stemiTreatment?.loadingDoseLocationId;

                            return Container(
                              // margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        'Loading Dose given at',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  initiallyExpanded: true,
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  children: list.map<Widget>((option) {
                                    return RadioListTile<int>(
                                      title: Text(option.name ?? ""),
                                      value: option.id!,
                                      groupValue: selectedId,
                                      onChanged: (id) {
                                        stemiController.stemiModel
                                            .update((model) {
                                          model?.stemiTreatment
                                              ?.loadingDoseLocationId = id;
                                        });
                                        debugPrint(
                                            "Updated loadingDoseLocationId: $id");
                                      },
                                      contentPadding: EdgeInsets.zero,
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }),

                          // 3c
                          if (stemiTreatment?.loadingDoseLocationId == 3) ...[
                            CommonDateTimeWidget(
                              title: "date of time of administration",
                              dateTime:
                                  stemiTreatment?.loadingDoseTime.toString() ??
                                      "",
                              onChanged: (picked) {
                                stemiTreatment?.loadingDoseTime =
                                    picked.toString();
                                stemiController.stemiModel.refresh();
                              },
                            ),
                          ],
                          NewCustomRadioList(
                            title: "Thrombolysis done at",
                            options: (stemiController.stemiLookup.value
                                        .thrombolysisLocation ??
                                    [])
                                .map((e) => LooksUpItem(id: e.id, name: e.name))
                                .toList(),
                            initialId:
                                model.stemiTreatment?.thrombolysisLocationId,
                            onChanged: (id) {
                              model.stemiTreatment!.thrombolysisLocationId = id;
                              stemiController.stemiModel
                                  .refresh(); // 🔑 force UI update
                              debugPrint("Updated thrombolysisLocationId: $id");
                            },
                          ),
                          // if (stemiTreatment?.thrombolysisLocationId == 4) ...[
                          //   TitleTextFormField(
                          //     title: "Enter the Reason",
                          //     hintText: "Enter Reason",
                          //     initialValue:
                          //     model.stemiTreatment?.thrombolysisNotDoneReason,
                          //     onChanged: (value) {
                          //       model.stemiTreatment?.thrombolysisNotDoneReason =
                          //           value;
                          //     },
                          //   ),
                          // ],
                          if (stemiTreatment?.thrombolysisLocationId == 3) ...[
                            // if (stemiTreatment?.thrombolysisLocationId == 1 ||
                            //     stemiTreatment?.thrombolysisLocationId == 2) ...[
                            NewTitleYesRadio(
                              initialValue: stemiTreatment?.plannedCag,
                              title: "Patient planned for CAG",
                              onChanged: (value) {
                                stemiTreatment?.plannedCag = value;
                                stemiController.stemiModel.refresh();
                              },
                            ),
                            if (stemiTreatment?.plannedCag == true) ...[
                              Obx(() {
                                final list = stemiController.stemiLookup.value
                                        .stemiCoronoryAngiography ??
                                    [];

                                if (list.isEmpty) {
                                  return const Text(
                                      "No Angiography Types available");
                                }

                                return NewCustomRadioList(
                                  isRequired: true,
                                  title: "Coronary angiography",
                                  options: list
                                      .map((e) =>
                                          LooksUpItem(id: e.id, name: e.name))
                                      .toList(),
                                  initialId:
                                      stemiTreatment?.coronoryAngiographyId,
                                  onChanged: (id) {
                                    stemiTreatment?.coronoryAngiographyId = id;
                                    stemiController.stemiModel
                                        .refresh(); // 🔁 refresh UI
                                    debugPrint(
                                        "Updated coronoryAngiographyId: $id");
                                  },
                                );
                              }),

                              CommonDateTimeWidget(
                                isRequired: true,
                                title: "Cath Lab Arrival Date & Time",
                                dateTime:
                                    stemiTreatment?.cathLabArrival.toString() ??
                                        "",
                                onChanged: (picked) {
                                  stemiTreatment?.cathLabArrival =
                                      picked.toString();
                                  stemiController.stemiModel.refresh();
                                },
                              ),

                              CommonDateTimeWidget(
                                isRequired: true,
                                title: "Date and Time of Balloon inflation",
                                dateTime: stemiTreatment?.balloonInflation
                                        .toString() ??
                                    "",
                                onChanged: (picked) {
                                  stemiTreatment?.balloonInflation =
                                      picked.toString();
                                  stemiController.stemiModel.refresh();
                                  calculateTimeDifference3Stemi(
                                    entryDate.toString(),
                                    stemiTreatment?.balloonInflation,
                                  );
                                },
                              ),
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.stentType ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Type of Sting available");
                                }
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: 'Type of Stent used',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: stemiTreatment?.stentTypeId,
                                  onChanged: (val) {
                                    stemiTreatment?.stentTypeId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),

                              // TitleTextFormField(
                              //   title:
                              //       "Complications",
                              //   hintText: "",
                              //   initialValue: "",
                              //   onChanged: (val) => stemiTreatment?.complications = val,
                              // ),

                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.stemiComplications ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Complications available");
                                }

                                // Safely get the selectedId
                                final selectedId =
                                    stemiTreatment?.complications != null &&
                                            stemiTreatment!.complications
                                                .toString()
                                                .isNotEmpty
                                        ? int.tryParse(stemiTreatment!
                                            .complications
                                            .toString())
                                        : null;

                                return NewTitleDropdown(
                                  title: 'Complications',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: selectedId,
                                  onChanged: (val) {
                                    stemiTreatment?.complications =
                                        val.toString();
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              if (stemiTreatment?.complications == 8)
                                TitleTextFormField(
                                  title: "Others",
                                  hintText: "",
                                  initialValue:
                                      stemiTreatment?.otherComplications,
                                  onChanged: (val) {
                                    stemiTreatment?.otherComplications = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                ),
                              // meow
                            ],
                            // ],

                            // if (stemiTreatment?.treatmentStrategyId != 1 ||
                            //     stemiTreatment?.treatmentStrategyId != 2) ...[
                            Obx(() {
                              final list = stemiController
                                      .stemiLookup.value.transferLocation ??
                                  [];
                              if (list.isEmpty) {
                                return const Text("No Type of Sting available");
                              }
                              return NewTitleDropdown(
                                title: 'Patient Transferred to:',
                                hint: 'Select Type',
                                items: list
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId: stemiTreatment?.transferLocationId,
                                onChanged: (val) {
                                  stemiTreatment?.transferLocationId = val;
                                  stemiController.stemiModel.refresh();
                                },
                              );
                            }),
                            // ],
                            // if (stemiTreatment?.treatmentStrategyId == 1 ) ...[
                            Obx(() {
                              final counsellingList = stemiController
                                      .stemiLookup
                                      .value
                                      .preDischargeCounselling ??
                                  [];

                              if (counsellingList.isEmpty) {
                                return const Text(
                                  "No Pre-Discharge Counselling options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup list to LooksUpItem model
                              final options = counsellingList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Get selected IDs from model (comma-separated string → List<int>)
                              final selectedIds = (model
                                          .stemiTreatment?.counsellingId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Pre-Discharge Counselling Given for",
                                options: options,
                                initialSelectedIndexes:
                                    selectedIds, // matches NewCheckboxList API
                                onChanged: (selectedValues) {
                                  // Update model with selected IDs as comma-separated string
                                  model.stemiTreatment?.counsellingId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // Refresh UI
                                },
                              );
                            }),
                            TimeMetricInput(
                              label: "Symptom onset to FMC time",
                              initialValue: stemiTreatment?.symptomToFmc,
                              onChanged: (val) =>
                                  stemiTreatment?.symptomToFmc = val.toString(),
                            ),
                            TimeMetricInput(
                              label: "FMC to ECG time",
                              initialValue: stemiTreatment?.fmcToEcg,
                              onChanged: (val) =>
                                  stemiTreatment?.fmcToEcg = val.toString(),
                            ),
                            // ],
                            // ],
                            // if (stemiTreatment?.treatmentStrategyId == 4 ||
                            //     stemiTreatment?.treatmentStrategyId == 5 ||
                            //     stemiTreatment?.treatmentStrategyId == 6) ...[
                            // if (stemiTreatment?.thrombolysisLocationId == 2) ...[
                            TimeMetricInput(
                              label: "Door-to-needle time (for thrombolysis)",
                              initialValue: stemiTreatment?.doorToNeedle,
                              onChanged: (val) =>
                                  stemiTreatment?.doorToNeedle = val.toString(),
                            ),
                            // // ],
                            // if (stemiTreatment?.treatmentStrategyId != 1 ||
                            //     stemiTreatment?.treatmentStrategyId != 2) ...[
                            TimeMetricInput(
                              label: "Door-to-balloon time (for PCI)",
                              initialValue: stemiTreatment?.doorToBalloon,
                              onChanged: (val) => stemiTreatment
                                  ?.doorToBalloon = val.toString(),
                            ),
                            // ],
                            Obx(() {
                              final hospitalStayDays = stemiController
                                      .stemiModel
                                      .value
                                      .stemiTreatment
                                      ?.hospitalStayDays
                                      ?.toString() ??
                                  "0";
                              return TitleTextFormField(
                                readOnly: true,
                                title: "Duration of hospital stay",
                                hintText: "Days",
                                controller: TextEditingController(
                                    text: hospitalStayDays),
                                keyboardType: TextInputType.number,
                                onChanged: (_) {}, // Prevent manual edits
                              );
                            }),

                            Obx(() {
                              return NewTitleDropdown(
                                isRequired: true,
                                title: "Outcome",
                                hint: "Select",
                                items: stemiController
                                        .stemiLookup.value.outcomeType
                                        ?.map(
                                            (e) => {"id": e.id, "name": e.name})
                                        .toList() ??
                                    [],
                                selectedId: model.stemiOutcome?.outcomeTypeId,
                                onChanged: (val) {
                                  model.stemiOutcome?.outcomeTypeId = val;
                                  stemiController.stemiModel.refresh();
                                },
                              );
                            }),
                            buildOutcomeFields(stemiOutcome),
                          ],
                          if (stemiTreatment?.thrombolysisLocationId == 4) ...[
                            TitleTextFormField(
                              title: "Enter the Reason",
                              hintText: "Enter Reason",
                              initialValue: model
                                  .stemiTreatment?.thrombolysisNotDoneReason,
                              onChanged: (value) {
                                model.stemiTreatment
                                    ?.thrombolysisNotDoneReason = value;
                              },
                            ),
                            Obx(() {
                              final list = stemiController
                                      .stemiLookup.value.treatmentStrategy ??
                                  [];
                              if (list.isEmpty) {
                                return const Text("No Type of Sting available");
                              }
                              return NewTitleDropdown(
                                isRequired: true,
                                title: 'Treatment Strategy',
                                hint: 'Select Type',
                                items: list
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId: stemiTreatment?.treatmentStrategyId,
                                onChanged: (val) {
                                  debugPrint(stemiTreatment?.treatmentStrategyId
                                      .toString());
                                  stemiTreatment?.treatmentStrategyId = val;
                                  stemiController.stemiModel.refresh();
                                  debugPrint(stemiTreatment?.treatmentStrategyId
                                      .toString());
                                },
                              );
                            }),
                            if (stemiTreatment?.treatmentStrategyId == 1) ...[
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Type of Sting available");
                                }
                                return NewTitleDropdown(
                                  title: 'Patient Transferred to:',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId:
                                      stemiTreatment?.transferLocationId,
                                  onChanged: (val) {
                                    stemiTreatment?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              // ],
                              // if (stemiTreatment?.treatmentStrategyId == 1 ) ...[
                              Obx(() {
                                final counsellingList = stemiController
                                        .stemiLookup
                                        .value
                                        .preDischargeCounselling ??
                                    [];

                                if (counsellingList.isEmpty) {
                                  return const Text(
                                    "No Pre-Discharge Counselling options available",
                                    style: TextStyle(color: Colors.black54),
                                  );
                                }

                                // Convert lookup list to LooksUpItem model
                                final options = counsellingList
                                    .map((e) =>
                                        LooksUpItem(id: e.id, name: e.name))
                                    .toList();

                                // Get selected IDs from model (comma-separated string → List<int>)
                                final selectedIds = (model
                                            .stemiTreatment?.counsellingId
                                            ?.split(',') ??
                                        [])
                                    .map((e) => int.tryParse(e.trim()) ?? 0)
                                    .where((id) => id != 0)
                                    .toList();

                                return NewCheckboxList(
                                  title: "Pre-Discharge Counselling Given for",
                                  options: options,
                                  initialSelectedIndexes:
                                      selectedIds, // matches NewCheckboxList API
                                  onChanged: (selectedValues) {
                                    // Update model with selected IDs as comma-separated string
                                    model.stemiTreatment?.counsellingId =
                                        selectedValues.join(',');
                                    stemiController.stemiModel
                                        .refresh(); // Refresh UI
                                  },
                                );
                              }),

                              TimeMetricInput(
                                label: "Symptom onset to FMC time",
                                initialValue: stemiTreatment?.symptomToFmc,
                                onChanged: (val) => stemiTreatment
                                    ?.symptomToFmc = val.toString(),
                              ),
                              TimeMetricInput(
                                label: "FMC to ECG time",
                                initialValue: stemiTreatment?.fmcToEcg,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToNeedle = val.toString(),
                              ),

                              Obx(() {
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: "Outcome",
                                  hint: "Select",
                                  items: stemiController
                                          .stemiLookup.value.outcomeType
                                          ?.map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList() ??
                                      [],
                                  selectedId: model.stemiOutcome?.outcomeTypeId,
                                  onChanged: (val) {
                                    model.stemiOutcome?.outcomeTypeId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              buildOutcomeFields(stemiOutcome),
                            ],
                            if (stemiTreatment?.treatmentStrategyId == 2) ...[
                              Obx(() {
                                final managementList = stemiController
                                        .stemiLookup
                                        .value
                                        .conservativeManagement ??
                                    [];

                                if (managementList.isEmpty) {
                                  return const Text(
                                    "No Management options available",
                                    style: TextStyle(color: Colors.black54),
                                  );
                                }

                                // Convert lookup data to LooksUpItem model
                                final options = managementList
                                    .map((e) =>
                                        LooksUpItem(id: e.id, name: e.name))
                                    .toList();

                                // Parse selected IDs from model (e.g. "1,2,3" → [1,2,3])
                                final selectedIds = (model
                                            .stemiTreatment?.managementId
                                            ?.split(',') ??
                                        [])
                                    .map((e) => int.tryParse(e.trim()) ?? 0)
                                    .where((id) => id != 0)
                                    .toList();

                                return NewCheckboxList(
                                  title: "Conservative Management",
                                  options: options,
                                  initialSelectedIndexes:
                                      selectedIds, // ✅ Widget input
                                  onChanged: (selectedValues) {
                                    // Convert selected IDs back to comma-separated string
                                    model.stemiTreatment?.managementId =
                                        selectedValues.join(',');
                                    stemiController.stemiModel
                                        .refresh(); // ✅ reactive update
                                  },
                                );
                              }),
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Type of Sting available");
                                }
                                return NewTitleDropdown(
                                  title: 'Patient Transferred to:',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId:
                                      stemiTreatment?.transferLocationId,
                                  onChanged: (val) {
                                    stemiTreatment?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              Obx(() {
                                final counsellingList = stemiController
                                        .stemiLookup
                                        .value
                                        .preDischargeCounselling ??
                                    [];

                                if (counsellingList.isEmpty) {
                                  return const Text(
                                    "No Pre-Discharge Counselling options available",
                                    style: TextStyle(color: Colors.black54),
                                  );
                                }

                                // Convert lookup list to LooksUpItem model
                                final options = counsellingList
                                    .map((e) =>
                                        LooksUpItem(id: e.id, name: e.name))
                                    .toList();

                                // Get selected IDs from the model (comma-separated string → List<int>)
                                final selectedIds = (model
                                            .stemiTreatment?.counsellingId
                                            ?.split(',') ??
                                        [])
                                    .map((e) => int.tryParse(e.trim()) ?? 0)
                                    .where((id) => id != 0)
                                    .toList();

                                return NewCheckboxList(
                                  title: "Pre-Discharge Counselling Given for",
                                  options: options,
                                  initialSelectedIndexes:
                                      selectedIds, // ✅ matches NewCheckboxList API
                                  onChanged: (selectedValues) {
                                    model.stemiTreatment?.counsellingId =
                                        selectedValues.join(',');
                                    stemiController.stemiModel
                                        .refresh(); // ✅ refresh reactive state
                                  },
                                );
                              }),
                              TimeMetricInput(
                                label: "Symptom onset to FMC time",
                                initialValue: stemiTreatment?.symptomToFmc,
                                onChanged: (val) => stemiTreatment
                                    ?.symptomToFmc = val.toString(),
                              ),
                              TimeMetricInput(
                                label: "FMC to ECG time",
                                initialValue: stemiTreatment?.fmcToEcg,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToNeedle = val.toString(),
                              ),
                              Obx(() {
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: "Outcome",
                                  hint: "Select",
                                  items: stemiController
                                          .stemiLookup.value.outcomeType
                                          ?.map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList() ??
                                      [],
                                  selectedId: model.stemiOutcome?.outcomeTypeId,
                                  onChanged: (val) {
                                    model.stemiOutcome?.outcomeTypeId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              buildOutcomeFields(stemiOutcome),
                            ],
                            if (stemiTreatment?.treatmentStrategyId == 3 ||
                                stemiTreatment?.treatmentStrategyId == 6 ||
                                stemiTreatment?.treatmentStrategyId == 4 ||
                                stemiTreatment?.treatmentStrategyId == 5) ...[
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.killipRiskScore ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Type of Sting available");
                                }
                                return NewTitleDropdown(
                                  title:
                                      'Cardiac Risk Stratification- Killip risk score for STEMI',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: stemiTreatment?.killipRiskScoreId,
                                  onChanged: (val) {
                                    stemiTreatment?.killipRiskScoreId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              // if (stemiTreatment?.thrombolysisLocationId == 1 ||
                              //     stemiTreatment?.thrombolysisLocationId == 2) ...[
                              NewTitleYesRadio(
                                initialValue: stemiTreatment?.plannedCag,
                                title: "Patient planned for CAG",
                                onChanged: (value) {
                                  stemiTreatment?.plannedCag = value;
                                  stemiController.stemiModel.refresh();
                                },
                              ),
                              if (stemiTreatment?.plannedCag == true) ...[
                                Obx(() {
                                  final list = stemiController.stemiLookup.value
                                          .stemiCoronoryAngiography ??
                                      [];

                                  if (list.isEmpty) {
                                    return const Text(
                                        "No Angiography Types available");
                                  }

                                  return NewCustomRadioList(
                                    isRequired: true,
                                    title: "Coronary angiography",
                                    options: list
                                        .map((e) =>
                                            LooksUpItem(id: e.id, name: e.name))
                                        .toList(),
                                    initialId:
                                        stemiTreatment?.coronoryAngiographyId,
                                    onChanged: (id) {
                                      stemiTreatment?.coronoryAngiographyId =
                                          id;
                                      stemiController.stemiModel
                                          .refresh(); // 🔁 refresh UI
                                      debugPrint(
                                          "Updated coronoryAngiographyId: $id");
                                    },
                                  );
                                }),
                                CommonDateTimeWidget(
                                  isRequired: true,
                                  title: "Cath Lab Arrival Date & Time",
                                  dateTime: stemiTreatment?.cathLabArrival
                                          .toString() ??
                                      "",
                                  onChanged: (picked) {
                                    stemiTreatment?.cathLabArrival =
                                        picked.toString();
                                    stemiController.stemiModel.refresh();
                                  },
                                ),
                                CommonDateTimeWidget(
                                  isRequired: true,
                                  title: "Date and Time of Balloon inflation",
                                  dateTime: stemiTreatment?.balloonInflation
                                          .toString() ??
                                      "",
                                  onChanged: (picked) {
                                    stemiTreatment?.balloonInflation =
                                        picked.toString();
                                    stemiController.stemiModel.refresh();
                                    calculateTimeDifference3Stemi(
                                      entryDate.toString(),
                                      stemiTreatment?.balloonInflation,
                                    );
                                  },
                                ),
                                Obx(() {
                                  final list = stemiController
                                          .stemiLookup.value.stentType ??
                                      [];
                                  if (list.isEmpty) {
                                    return const Text(
                                        "No Type of Sting available");
                                  }
                                  return NewTitleDropdown(
                                    isRequired: true,
                                    title: 'Type of Stent used',
                                    hint: 'Select Type',
                                    items: list
                                        .map(
                                            (e) => {"id": e.id, "name": e.name})
                                        .toList(),
                                    selectedId: stemiTreatment?.stentTypeId,
                                    onChanged: (val) {
                                      stemiTreatment?.stentTypeId = val;
                                      stemiController.stemiModel.refresh();
                                    },
                                  );
                                }),
                                Obx(() {
                                  final list = stemiController.stemiLookup.value
                                          .stemiComplications ??
                                      [];
                                  if (list.isEmpty) {
                                    return const Text(
                                        "No Complications available");
                                  }

                                  // Safely get the selectedId
                                  final selectedId =
                                      stemiTreatment?.complications != null &&
                                              stemiTreatment!.complications
                                                  .toString()
                                                  .isNotEmpty
                                          ? int.tryParse(stemiTreatment!
                                              .complications
                                              .toString())
                                          : null;

                                  return NewTitleDropdown(
                                    title: 'Complications',
                                    hint: 'Select Type',
                                    items: list
                                        .map(
                                            (e) => {"id": e.id, "name": e.name})
                                        .toList(),
                                    selectedId: selectedId,
                                    onChanged: (val) {
                                      stemiTreatment?.complications =
                                          val.toString();
                                      stemiController.stemiModel.refresh();
                                    },
                                  );
                                }),
                                if (stemiTreatment?.complications == 8)
                                  TitleTextFormField(
                                    title: "Others",
                                    hintText: "",
                                    initialValue:
                                        stemiTreatment?.otherComplications,
                                    onChanged: (val) {
                                      stemiTreatment?.otherComplications = val;
                                      stemiController.stemiModel.refresh();
                                    },
                                  ),
                              ],

                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Type of Sting available");
                                }
                                return NewTitleDropdown(
                                  title: 'Patient Transferred to:',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId:
                                      stemiTreatment?.transferLocationId,
                                  onChanged: (val) {
                                    stemiTreatment?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              // ],
                              // if (stemiTreatment?.treatmentStrategyId == 1 ) ...[
                              Obx(() {
                                final counsellingList = stemiController
                                        .stemiLookup
                                        .value
                                        .preDischargeCounselling ??
                                    [];

                                if (counsellingList.isEmpty) {
                                  return const Text(
                                    "No Pre-Discharge Counselling options available",
                                    style: TextStyle(color: Colors.black54),
                                  );
                                }

                                // Convert lookup data to LooksUpItem
                                final options = counsellingList
                                    .map((e) =>
                                        LooksUpItem(id: e.id, name: e.name))
                                    .toList();

                                // Parse selected IDs from model
                                final selectedIds = (model
                                            .stemiTreatment?.counsellingId
                                            ?.split(',') ??
                                        [])
                                    .map((e) => int.tryParse(e.trim()) ?? 0)
                                    .where((id) => id != 0)
                                    .toList();

                                return NewCheckboxList(
                                  title: "Pre-Discharge Counselling Given for",
                                  options: options,
                                  initialSelectedIndexes:
                                      selectedIds, // matches NewCheckboxList API
                                  onChanged: (selectedValues) {
                                    model.stemiTreatment?.counsellingId =
                                        selectedValues.join(',');
                                    stemiController.stemiModel
                                        .refresh(); // refresh reactive state
                                  },
                                );
                              }),

                              TimeMetricInput(
                                label: "Symptom onset to FMC time",
                                initialValue: stemiTreatment?.symptomToFmc,
                                onChanged: (val) => stemiTreatment
                                    ?.symptomToFmc = val.toString(),
                              ),
                              TimeMetricInput(
                                label: "FMC to ECG time",
                                initialValue: stemiTreatment?.fmcToEcg,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToNeedle = val.toString(),
                              ),
                              // ],
                              // ],
                              // if (stemiTreatment?.treatmentStrategyId == 4 ||
                              //     stemiTreatment?.treatmentStrategyId == 5 ||
                              //     stemiTreatment?.treatmentStrategyId == 6) ...[
                              // if (stemiTreatment?.thrombolysisLocationId == 2) ...[
                              TimeMetricInput(
                                label: "Door-to-needle time (for thrombolysis)",
                                initialValue: stemiTreatment?.doorToNeedle,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToNeedle = val.toString(),
                              ),
                              // // ],
                              // if (stemiTreatment?.treatmentStrategyId != 1 ||
                              //     stemiTreatment?.treatmentStrategyId != 2) ...[
                              TimeMetricInput(
                                label: "Door-to-balloon time (for PCI)",
                                initialValue: stemiTreatment?.doorToBalloon,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToBalloon = val.toString(),
                              ),
                              // ],
                              Obx(() {
                                final hospitalStayDays = stemiController
                                        .stemiModel
                                        .value
                                        .stemiTreatment
                                        ?.hospitalStayDays
                                        ?.toString() ??
                                    "0";
                                return TitleTextFormField(
                                  readOnly: true,
                                  title: "Duration of hospital stay",
                                  hintText: "Days",
                                  controller: TextEditingController(
                                      text: hospitalStayDays),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {}, // Prevent manual edits
                                );
                              }),

                              Obx(() {
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: "Outcome",
                                  hint: "Select",
                                  items: stemiController
                                          .stemiLookup.value.outcomeType
                                          ?.map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList() ??
                                      [],
                                  selectedId: model.stemiOutcome?.outcomeTypeId,
                                  onChanged: (val) {
                                    model.stemiOutcome?.outcomeTypeId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              buildOutcomeFields(stemiOutcome),
                            ],
                          ],
                          if (stemiTreatment?.thrombolysisLocationId == 1 ||
                              stemiTreatment?.thrombolysisLocationId == 2) ...[
                            Obx(() {
                              final stemiTreatment = stemiController
                                  .stemiModel.value.stemiTreatment;
                              final list = stemiController
                                      .stemiLookup.value.thrombolyticAgent ??
                                  [];
                              if (list.isEmpty) {
                                return const Text(
                                    "No Thrombolytic Agent available");
                              }
                              return NewTitleDropdown(
                                isRequired: true,
                                title: 'Thrombolytic Agent - Name, Dosage',
                                hint: 'Select Type',
                                items: list
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId: stemiTreatment?.thrombolyticAgentId,
                                onChanged: (val) {
                                  stemiTreatment?.thrombolyticAgentId = val;
                                  stemiController.stemiModel.refresh();
                                },
                              );
                              // }
                              // return const SizedBox.shrink();
                            }),

                            // Center(
                            //     child: Text("Date & Time of thrombolysis",
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.w500, fontSize: 14))),

                            CommonDateTimeWidget(
                              isRequired: true,
                              title: "Date & Time of thrombolysis",
                              dateTime:
                                  stemiTreatment?.thrombolysisDate.toString() ??
                                      "",
                              onChanged: (picked) {
                                stemiTreatment?.thrombolysisDate =
                                    picked.toString();
                                // setState(() {
                                //   entryDate = "2025-10-12 14:30:00";
                                // });
                                debugPrint(entryDate.toString());
                                calculateTimeDifference2Stemi(
                                  entryDate,
                                  stemiTreatment?.thrombolysisDate.toString(),
                                );
                                stemiController.stemiModel.refresh();
                              },
                            ),

                            Obx(() {
                              final list = stemiController
                                      .stemiLookup.value.thrombolysisOutcome ??
                                  [];
                              if (list.isEmpty) {
                                return const Text("No Type of Sting available");
                              }
                              return NewTitleDropdown(
                                title: 'Thrombolysis outcome',
                                hint: 'Select Type',
                                items: list
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId:
                                    stemiTreatment?.thrombolysisOutcomeId,
                                onChanged: (val) {
                                  stemiTreatment?.thrombolysisOutcomeId = val;
                                  stemiController.stemiModel.refresh();
                                },
                              );
                            }),

                            Obx(() {
                              final list = stemiController
                                      .stemiLookup.value.treatmentStrategy ??
                                  [];
                              if (list.isEmpty) {
                                return const Text("No Type of Sting available");
                              }
                              return NewTitleDropdown(
                                isRequired: true,
                                title: 'Treatment Strategy',
                                hint: 'Select Type',
                                items: list
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId: stemiTreatment?.treatmentStrategyId,
                                onChanged: (val) {
                                  debugPrint(stemiTreatment?.treatmentStrategyId
                                      .toString());
                                  stemiTreatment?.treatmentStrategyId = val;
                                  stemiController.stemiModel.refresh();
                                  debugPrint(stemiTreatment?.treatmentStrategyId
                                      .toString());
                                },
                              );
                            }),
                            if (stemiTreatment?.treatmentStrategyId == 1) ...[
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Type of Sting available");
                                }
                                return NewTitleDropdown(
                                  title: 'Patient Transferred to:',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId:
                                      stemiTreatment?.transferLocationId,
                                  onChanged: (val) {
                                    stemiTreatment?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              // ],
                              // if (stemiTreatment?.treatmentStrategyId == 1 ) ...[
                              Obx(() {
                                final counsellingList = stemiController
                                        .stemiLookup
                                        .value
                                        .preDischargeCounselling ??
                                    [];

                                if (counsellingList.isEmpty) {
                                  return const Text(
                                    "No Pre-Discharge Counselling options available",
                                    style: TextStyle(color: Colors.black54),
                                  );
                                }

                                // Convert lookup data to LooksUpItem
                                final options = counsellingList
                                    .map((e) =>
                                        LooksUpItem(id: e.id, name: e.name))
                                    .toList();

                                // Parse selected IDs from model
                                final selectedIds = (model
                                            .stemiTreatment?.counsellingId
                                            ?.split(',') ??
                                        [])
                                    .map((e) => int.tryParse(e.trim()) ?? 0)
                                    .where((id) => id != 0)
                                    .toList();

                                return NewCheckboxList(
                                  title: "Pre-Discharge Counselling Given for",
                                  options: options,
                                  initialSelectedIndexes:
                                      selectedIds, // matches NewCheckboxList API
                                  onChanged: (selectedValues) {
                                    model.stemiTreatment?.counsellingId =
                                        selectedValues.join(',');
                                    stemiController.stemiModel
                                        .refresh(); // refresh reactive state
                                  },
                                );
                              }),
                              TimeMetricInput(
                                label: "Symptom onset to FMC time",
                                initialValue: stemiTreatment?.symptomToFmc,
                                onChanged: (val) => stemiTreatment
                                    ?.symptomToFmc = val.toString(),
                              ),
                              TimeMetricInput(
                                label: "FMC to ECG time",
                                initialValue: stemiTreatment?.fmcToEcg,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToNeedle = val.toString(),
                              ),

                              Obx(() {
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: "Outcome",
                                  hint: "Select",
                                  items: stemiController
                                          .stemiLookup.value.outcomeType
                                          ?.map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList() ??
                                      [],
                                  selectedId: model.stemiOutcome?.outcomeTypeId,
                                  onChanged: (val) {
                                    model.stemiOutcome?.outcomeTypeId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              buildOutcomeFields(stemiOutcome),
                            ],
                            if (stemiTreatment?.treatmentStrategyId == 2) ...[
                              Obx(() {
                                final managementList = stemiController
                                        .stemiLookup
                                        .value
                                        .conservativeManagement ??
                                    [];

                                if (managementList.isEmpty) {
                                  return const Text(
                                    "No Management options available",
                                    style: TextStyle(color: Colors.black54),
                                  );
                                }

                                // Convert lookup data to LooksUpItem model
                                final options = managementList
                                    .map((e) =>
                                        LooksUpItem(id: e.id, name: e.name))
                                    .toList();

                                // Parse selected IDs from model string ("1,2,3" → [1,2,3])
                                final selectedIds = (model
                                            .stemiTreatment?.managementId
                                            ?.split(',') ??
                                        [])
                                    .map((e) => int.tryParse(e.trim()) ?? 0)
                                    .where((id) => id != 0)
                                    .toList();

                                return NewCheckboxList(
                                  title: "Conservative Management",
                                  options: options,
                                  initialSelectedIndexes:
                                      selectedIds, // matches widget param
                                  onChanged: (selectedValues) {
                                    // Update model with selected IDs as comma-separated string
                                    model.stemiTreatment?.managementId =
                                        selectedValues.join(',');
                                    stemiController.stemiModel
                                        .refresh(); // refresh reactive state
                                  },
                                );
                              }),
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Type of Sting available");
                                }
                                return NewTitleDropdown(
                                  title: 'Patient Transferred to:',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId:
                                      stemiTreatment?.transferLocationId,
                                  onChanged: (val) {
                                    stemiTreatment?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              // ],
                              // if (stemiTreatment?.treatmentStrategyId == 1 ) ...[
                              Obx(() {
                                final counsellingList = stemiController
                                        .stemiLookup
                                        .value
                                        .preDischargeCounselling ??
                                    [];

                                if (counsellingList.isEmpty) {
                                  return const Text(
                                    "No Pre-Discharge Counselling options available",
                                    style: TextStyle(color: Colors.black54),
                                  );
                                }

                                // Convert lookup data to LooksUpItem model
                                final options = counsellingList
                                    .map((e) =>
                                        LooksUpItem(id: e.id, name: e.name))
                                    .toList();

                                // Parse selected IDs from model string ("1,2,3" → [1,2,3])
                                final selectedIds = (model
                                            .stemiTreatment?.counsellingId
                                            ?.split(',') ??
                                        [])
                                    .map((e) => int.tryParse(e.trim()) ?? 0)
                                    .where((id) => id != 0)
                                    .toList();

                                return NewCheckboxList(
                                  title: "Pre-Discharge Counselling Given for",
                                  options: options,
                                  initialSelectedIndexes:
                                      selectedIds, // matches widget param
                                  onChanged: (selectedValues) {
                                    // Update model with selected IDs as comma-separated string
                                    model.stemiTreatment?.counsellingId =
                                        selectedValues.join(',');
                                    stemiController.stemiModel
                                        .refresh(); // refresh reactive state
                                  },
                                );
                              }),

                              TimeMetricInput(
                                label: "Symptom onset to FMC time",
                                initialValue: stemiTreatment?.symptomToFmc,
                                onChanged: (val) => stemiTreatment
                                    ?.symptomToFmc = val.toString(),
                              ),
                              TimeMetricInput(
                                label: "FMC to ECG time",
                                initialValue: stemiTreatment?.fmcToEcg,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToNeedle = val.toString(),
                              ),

                              Obx(() {
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: "Outcome",
                                  hint: "Select",
                                  items: stemiController
                                          .stemiLookup.value.outcomeType
                                          ?.map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList() ??
                                      [],
                                  selectedId: model.stemiOutcome?.outcomeTypeId,
                                  onChanged: (val) {
                                    model.stemiOutcome?.outcomeTypeId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              buildOutcomeFields(stemiOutcome),
                            ],
                            if (stemiTreatment?.treatmentStrategyId == 3 ||
                                stemiTreatment?.treatmentStrategyId == 6 ||
                                stemiTreatment?.treatmentStrategyId == 4 ||
                                stemiTreatment?.treatmentStrategyId == 5) ...[
                              // Obx(() {
                              //   final managementList = stemiController
                              //       .stemiLookup.value.conservativeManagement ??
                              //       [];
                              //
                              //   if (managementList.isEmpty) {
                              //     return const Text(
                              //         "No Management options available");
                              //   }
                              //
                              //   // Convert to LooksUpItem format
                              //   final options = managementList
                              //       .map((e) => LooksUpItem(id: e.id, name: e.name))
                              //       .toList();
                              //
                              //   // Get selected IDs from your model
                              //   final selectedIds = (model
                              //       .stemiTreatment?.managementId
                              //       ?.split(',') ??
                              //       [])
                              //       .map((e) => int.tryParse(e) ?? 0)
                              //       .where((e) => e != 0)
                              //       .toList();
                              //
                              //   return NewCustomCheckboxList(
                              //     title: "Conservative Management",
                              //     options: options,
                              //     initialIds:
                              //     selectedIds, // Pre-select based on model
                              //     onChanged: (ids) {
                              //       model.stemiTreatment!.managementId =
                              //           ids.join(',');
                              //       stemiController.stemiModel
                              //           .refresh(); // Refresh UI
                              //     },
                              //   );
                              // }),
                              // ],
                              // if (stemiTreatment?.treatmentStrategyId != 1 ||
                              //     stemiTreatment?.treatmentStrategyId != 2) ...[
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.killipRiskScore ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Type of Sting available");
                                }
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: 'Cardiac Risk Stratification- Killip risk score for STEMI',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: stemiTreatment?.killipRiskScoreId,
                                  onChanged: (val) {
                                    stemiTreatment?.killipRiskScoreId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              // if (stemiTreatment?.thrombolysisLocationId == 1 ||
                              //     stemiTreatment?.thrombolysisLocationId == 2) ...[
                              NewTitleYesRadio(
                                initialValue: stemiTreatment?.plannedCag,
                                title: "Patient planned for CAG",
                                onChanged: (value) {
                                  stemiTreatment?.plannedCag = value;
                                  stemiController.stemiModel.refresh();
                                },
                              ),
                              if (stemiTreatment?.plannedCag == true) ...[
                                Obx(() {
                                  final list = stemiController.stemiLookup.value
                                          .stemiCoronoryAngiography ??
                                      [];

                                  if (list.isEmpty) {
                                    return const Text(
                                        "No Angiography Types available");
                                  }

                                  return NewCustomRadioList(
                                    isRequired: true,
                                    title: "Coronary angiography",
                                    options: list
                                        .map((e) =>
                                            LooksUpItem(id: e.id, name: e.name))
                                        .toList(),
                                    initialId:
                                        stemiTreatment?.coronoryAngiographyId,
                                    onChanged: (id) {
                                      stemiTreatment?.coronoryAngiographyId =
                                          id;
                                      stemiController.stemiModel
                                          .refresh(); // 🔁 refresh UI
                                      debugPrint(
                                          "Updated coronoryAngiographyId: $id");
                                    },
                                  );
                                }),

                                CommonDateTimeWidget(
                                  isRequired: true,
                                  title: "Cath Lab Arrival Date & Time",
                                  dateTime: stemiTreatment?.cathLabArrival
                                          .toString() ??
                                      "",
                                  onChanged: (picked) {
                                    stemiTreatment?.cathLabArrival =
                                        picked.toString();
                                    stemiController.stemiModel.refresh();
                                  },
                                ),

                                CommonDateTimeWidget(
                                  isRequired: true,
                                  title: "Date and Time of Balloon inflation",
                                  dateTime: stemiTreatment?.balloonInflation
                                          .toString() ??
                                      "",
                                  onChanged: (picked) {
                                    stemiTreatment?.balloonInflation =
                                        picked.toString();
                                    stemiController.stemiModel.refresh();
                                    calculateTimeDifference3Stemi(
                                      entryDate.toString(),
                                      stemiTreatment?.balloonInflation,
                                    );
                                  },
                                ),

                                Obx(() {
                                  final list = stemiController
                                          .stemiLookup.value.stentType ??
                                      [];
                                  if (list.isEmpty) {
                                    return const Text(
                                        "No Type of Sting available");
                                  }
                                  return NewTitleDropdown(
                                    isRequired: true,
                                    title: 'Type of Stent used',
                                    hint: 'Select Type',
                                    items: list
                                        .map(
                                            (e) => {"id": e.id, "name": e.name})
                                        .toList(),
                                    selectedId: stemiTreatment?.stentTypeId,
                                    onChanged: (val) {
                                      stemiTreatment?.stentTypeId = val;
                                      stemiController.stemiModel.refresh();
                                    },
                                  );
                                }),

                                // TitleTextFormField(
                                //   title:
                                //       "Complications",
                                //   hintText: "",
                                //   initialValue: "",
                                //   onChanged: (val) => stemiTreatment?.complications = val,
                                // ),

                                Obx(() {
                                  final list = stemiController.stemiLookup.value
                                          .stemiComplications ??
                                      [];
                                  if (list.isEmpty) {
                                    return const Text(
                                        "No Complications available");
                                  }

                                  // Safely get the selectedId
                                  final selectedId =
                                      stemiTreatment?.complications != null &&
                                              stemiTreatment!.complications
                                                  .toString()
                                                  .isNotEmpty
                                          ? int.tryParse(stemiTreatment!
                                              .complications
                                              .toString())
                                          : null;

                                  return NewTitleDropdown(
                                    title: 'Complications',
                                    hint: 'Select Type',
                                    items: list
                                        .map(
                                            (e) => {"id": e.id, "name": e.name})
                                        .toList(),
                                    selectedId: selectedId,
                                    onChanged: (val) {
                                      stemiTreatment?.complications =
                                          val.toString();
                                      stemiController.stemiModel.refresh();
                                    },
                                  );
                                }),
                                if (stemiTreatment?.complications == 8)
                                  TitleTextFormField(
                                    title: "Others",
                                    hintText: "",
                                    initialValue:
                                        stemiTreatment?.otherComplications,
                                    onChanged: (val) {
                                      stemiTreatment?.otherComplications = val;
                                      stemiController.stemiModel.refresh();
                                    },
                                  ),
                              ],
                              // ],

                              // if (stemiTreatment?.treatmentStrategyId != 1 ||
                              //     stemiTreatment?.treatmentStrategyId != 2) ...[
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No Type of Sting available");
                                }
                                return NewTitleDropdown(
                                  title: 'Patient Transferred to:',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId:
                                      stemiTreatment?.transferLocationId,
                                  onChanged: (val) {
                                    stemiTreatment?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              // ],
                              // if (stemiTreatment?.treatmentStrategyId == 1 ) ...[
                              Obx(() {
                                final counsellingList = stemiController
                                        .stemiLookup
                                        .value
                                        .preDischargeCounselling ??
                                    [];

                                if (counsellingList.isEmpty) {
                                  return const Text(
                                    "No Pre-Discharge Counselling options available",
                                    style: TextStyle(color: Colors.black54),
                                  );
                                }

                                // Convert lookup data to LooksUpItem
                                final options = counsellingList
                                    .map((e) =>
                                        LooksUpItem(id: e.id, name: e.name))
                                    .toList();

                                // Parse selected IDs from model
                                final selectedIds = (model
                                            .stemiTreatment?.counsellingId
                                            ?.split(',') ??
                                        [])
                                    .map((e) => int.tryParse(e.trim()) ?? 0)
                                    .where((id) => id != 0)
                                    .toList();

                                return NewCheckboxList(
                                  title: "Pre-Discharge Counselling Given for",
                                  options: options,
                                  initialSelectedIndexes:
                                      selectedIds, // matches NewCheckboxList API
                                  onChanged: (selectedValues) {
                                    model.stemiTreatment?.counsellingId =
                                        selectedValues.join(',');
                                    stemiController.stemiModel
                                        .refresh(); // refresh reactive state
                                  },
                                );
                              }),
                              TimeMetricInput(
                                label: "Symptom onset to FMC time",
                                initialValue: stemiTreatment?.symptomToFmc,
                                onChanged: (val) => stemiTreatment
                                    ?.symptomToFmc = val.toString(),
                              ),
                              TimeMetricInput(
                                label: "FMC to ECG time",
                                initialValue: stemiTreatment?.fmcToEcg,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToNeedle = val.toString(),
                              ),

                              TimeMetricInput(
                                label: "Door-to-needle time (for thrombolysis)",
                                initialValue: stemiTreatment?.doorToNeedle,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToNeedle = val.toString(),
                              ),
                              // // ],
                              // if (stemiTreatment?.treatmentStrategyId != 1 ||
                              //     stemiTreatment?.treatmentStrategyId != 2) ...[
                              TimeMetricInput(
                                label: "Door-to-balloon time (for PCI)",
                                initialValue: stemiTreatment?.doorToBalloon,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToBalloon = val.toString(),
                              ),
                              // ],
                              Obx(() {
                                final hospitalStayDays = stemiController
                                        .stemiModel
                                        .value
                                        .stemiTreatment
                                        ?.hospitalStayDays
                                        ?.toString() ??
                                    "0";
                                return TitleTextFormField(
                                  readOnly: true,
                                  title: "Duration of hospital stay",
                                  hintText: "Days",
                                  controller: TextEditingController(
                                      text: hospitalStayDays),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) {}, // Prevent manual edits
                                );
                              }),
                              // ],
                              // TimeMetricInput(
                              //   label: "Total ischemic time",
                              //   initialValue: stemiTreatment?.totalIschemicTime,
                              //   onChanged: (val) => stemiTreatment?.doorToBalloon = val,
                              // ),

                              // NewTitleYesRadio(
                              //   initialValue: stemiTreatment?.icuAdmission ?? false,
                              //   title: "ICU/CCU admission: Yes/No",
                              //   onChanged: (value) {
                              //     stemiTreatment?.icuAdmission = value;
                              //     stemiController.stemiModel.refresh();
                              //   },
                              // ),

                              //hospital stayng
                              // Text(stemiController.stemiModel.value.stemiTreatment!.hospitalStayDays.toString()),

                              Obx(() {
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: "Outcome",
                                  hint: "Select",
                                  items: stemiController
                                          .stemiLookup.value.outcomeType
                                          ?.map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList() ??
                                      [],
                                  selectedId: model.stemiOutcome?.outcomeTypeId,
                                  onChanged: (val) {
                                    model.stemiOutcome?.outcomeTypeId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              buildOutcomeFields(stemiOutcome),
                            ],
                          ],
                        ],
                        if (stemiClinicalAssessment?.diagnosis == 2) ...[
                          // Center(child: Text("NSTEMI")),
                          Center(child: Text("Nstemi")),

                          CommonDateTimeWidget(
                            isRequired: true,
                            title: "NSTEMI Confirmed (Date & Time)",
                            dateTime:
                                nstemiTreatment?.nstemiConfirmedAt.toString() ??
                                    "",
                            onChanged: (picked) {
                              nstemiTreatment?.nstemiConfirmedAt =
                                  picked.toString();
                              stemiController.stemiModel.refresh();
                            },
                          ),

                          // Loading Dose Location
                          Obx(() {
                            final list = stemiController.stemiLookup.value
                                    .nstemiLoadingDoseLocation ??
                                [];

                            if (list.isEmpty) {
                              return const Text(
                                  "No Loading Dose Locations available");
                            }

                            int? selectedId =
                                nstemiTreatment?.loadingDoseLocationId;

                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        'Loading Dose given at',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  initiallyExpanded: true,
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  children: list.map<Widget>((option) {
                                    return RadioListTile<int>(
                                      title: Text(option.name ?? ""),
                                      value: option.id!,
                                      groupValue: selectedId,
                                      // onChanged: (id) {
                                      //
                                      // },
                                      onChanged: (id) {
                                        stemiController.stemiModel
                                            .update((model) {
                                          model?.nstemiTreatment
                                              ?.loadingDoseLocationId = id;
                                        });
                                        debugPrint(
                                            "Updated loadingDoseLocationId: $id");
                                      },
                                      contentPadding: EdgeInsets.zero,
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }),
                          if (nstemiTreatment?.loadingDoseLocationId == 3) ...[
                            CommonDateTimeWidget(
                              title: "date of time of administration",
                              dateTime:
                                  nstemiTreatment?.loadingDoseTime.toString() ??
                                      "",
                              onChanged: (picked) {
                                nstemiTreatment?.loadingDoseTime =
                                    picked.toString();
                                stemiController.stemiModel.refresh();
                              },
                            ),
                          ],

                          Obx(() {
                            final list = stemiController
                                    .stemiLookup.value.timiRiskScore ??
                                [];
                            if (list.isEmpty)
                              return const Text(
                                  "No TIMI Risk Scores available");
                            return NewTitleDropdown(
                              isRequired: true,
                              title:
                                  "Cardiac Risk Stratification- TIMI risk score for NSTEMI/UA",
                              hint: "Select Score",
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: nstemiTreatment?.timiRiskScoreId,
                              onChanged: (val) {
                                nstemiTreatment?.timiRiskScoreId = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),

                          // Treatment Strategy
                          Obx(() {
                            final list = stemiController.stemiLookup.value
                                    .nstemiTreatmentStrategy ??
                                [];
                            if (list.isEmpty)
                              return const Text(
                                  "No Treatment Strategies available");
                            return NewTitleDropdown(
                              title: "Treatment Strategy",
                              hint: "Select Strategy",
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: nstemiTreatment?.treatmentStrategyId,
                              onChanged: (val) {
                                nstemiTreatment?.treatmentStrategyId = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),
                          if (nstemiTreatment?.treatmentStrategyId == 1) ...[
                            Obx(() {
                              final managementList = stemiController.stemiLookup
                                      .value.conservativeManagement ??
                                  [];

                              if (managementList.isEmpty) {
                                return const Text(
                                  "No Management options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem model
                              final options = managementList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from model string ("1,2,3" → [1,2,3])
                              final selectedIds = (model
                                          .nstemiTreatment?.managementId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Conservative Management",
                                options: options,
                                initialSelectedIndexes:
                                    selectedIds, // matches widget param
                                onChanged: (selectedValues) {
                                  // Update model with selected IDs as comma-separated string
                                  model.nstemiTreatment?.managementId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // refresh reactive state
                                },
                              );
                            }),
                            Obx(() {
                              final counsellingList = stemiController
                                      .stemiLookup
                                      .value
                                      .preDischargeCounselling ??
                                  [];

                              if (counsellingList.isEmpty) {
                                return const Text(
                                  "No Pre-Discharge Counselling options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem
                              final options = counsellingList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from the model
                              final selectedIds = (model
                                          .nstemiTreatment?.counsellingId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Pre-Discharge Counselling Given for",
                                options: options,
                                initialSelectedIndexes:
                                    selectedIds, // matches NewCheckboxList API
                                onChanged: (selectedValues) {
                                  model.nstemiTreatment?.counsellingId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // refresh reactive state
                                },
                              );
                            }),
                            NewTitleDropdown(
                              isRequired: true,
                              title: "Outcome",
                              hint: "Select",
                              items: stemiController
                                      .stemiLookup.value.outcomeType
                                      ?.map((e) => {"id": e.id, "name": e.name})
                                      .toList() ??
                                  [],
                              selectedId: model.nstemiOutcome?.outcomeTypeId,
                              onChanged: (val) {
                                model.nstemiOutcome?.outcomeTypeId = val;
                                stemiController.stemiModel.refresh();
                              },
                            ),
                            buildOutcomeFields1(nstemiOutcome),
                          ],
                          if (nstemiTreatment?.treatmentStrategyId == 4) ...[
                            Obx(() {
                              final managementList = stemiController.stemiLookup
                                      .value.conservativeManagement ??
                                  [];

                              if (managementList.isEmpty) {
                                return const Text(
                                  "No Management options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem model
                              final options = managementList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from model string ("1,2,3" → [1,2,3])
                              final selectedIds = (model
                                          .nstemiTreatment?.managementId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Conservative Management",
                                options: options,
                                initialSelectedIndexes:
                                    selectedIds, // ✅ matches widget API
                                onChanged: (selectedValues) {
                                  // Convert selected IDs back to comma-separated string
                                  model.nstemiTreatment?.managementId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // ✅ refresh reactive UI
                                },
                              );
                            }),
                            NewTitleYesRadio(
                              title: "Patient planned for CAG",
                              initialValue: nstemiTreatment?.plannedCag,
                              onChanged: (val) {
                                nstemiTreatment?.plannedCag = val;
                                stemiController.stemiModel.refresh();
                              },
                            ),
                            // ],
                            if (nstemiTreatment?.plannedCag == true) ...[
                              Obx(() {
                                final list = stemiController.stemiLookup.value
                                        .stemiCoronoryAngiography ??
                                    [];

                                if (list.isEmpty) {
                                  return const Text(
                                      "No Angiography Types available");
                                }

                                return NewCustomRadioList(
                                  isRequired: true,
                                  title: "Coronary angiography",
                                  options: list
                                      .map((e) =>
                                          LooksUpItem(id: e.id, name: e.name))
                                      .toList(),
                                  initialId:
                                      nstemiTreatment?.coronoryAngiographyId,
                                  onChanged: (id) {
                                    nstemiTreatment?.coronoryAngiographyId = id;
                                    stemiController.stemiModel
                                        .refresh(); // 🔁 refresh UI
                                    debugPrint(
                                        "Updated coronoryAngiographyId: $id");
                                  },
                                );
                              }),
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty)
                                  return const Text(
                                      "No Transfer Locations available");
                                return NewTitleDropdown(
                                  title: "Patient Transferred to:",
                                  hint: "Select Location",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId:
                                      nstemiTreatment?.transferLocationId,
                                  onChanged: (val) {
                                    nstemiTreatment?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              TimeMetricInput(
                                label: "Door-to-balloon time (for PCI)",
                                initialValue: stemiTreatment?.doorToBalloon,
                                onChanged: (val) => stemiTreatment
                                    ?.doorToBalloon = val.toString(),
                              ),
                            ],
                            nstemiTreatment?.plannedCag == true
                                ? SizedBox()
                                : Obx(() {
                                    final list = stemiController.stemiLookup
                                            .value.transferLocation ??
                                        [];
                                    if (list.isEmpty)
                                      return const Text(
                                          "No Transfer Locations available");
                                    return NewTitleDropdown(
                                      title: "Patient Transferred to:",
                                      hint: "Select Location",
                                      items: list
                                          .map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList(),
                                      selectedId:
                                          nstemiTreatment?.transferLocationId,
                                      onChanged: (val) {
                                        nstemiTreatment?.transferLocationId =
                                            val;
                                        stemiController.stemiModel.refresh();
                                      },
                                    );
                                  }),
                            Obx(() {
                              final counsellingList = stemiController
                                      .stemiLookup
                                      .value
                                      .preDischargeCounselling ??
                                  [];

                              if (counsellingList.isEmpty) {
                                return const Text(
                                  "No Pre-Discharge Counselling options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem
                              final options = counsellingList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from the model
                              final selectedIds = (model
                                          .nstemiTreatment?.counsellingId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Pre-Discharge Counselling Given for",
                                options: options,
                                initialSelectedIndexes: selectedIds,
                                // ✅ matches your NewCheckboxList API
                                onChanged: (selectedValues) {
                                  model.nstemiTreatment?.counsellingId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // Refresh GetX reactive state
                                },
                              );
                            }),
                            // if (nstemiTreatment?.treatmentStrategyId == 1 ||
                            //     nstemiTreatment?.treatmentStrategyId == 2) ...[
                            TimeMetricInput(
                              label: "Symptom onset to FMC time",
                              initialValue: nstemiTreatment?.symptomToFmc,
                              onChanged: (val) => nstemiTreatment
                                  ?.symptomToFmc = val.toString(),
                            ),
                            TimeMetricInput(
                              label: "Symptom onset to FMC time",
                              initialValue: nstemiTreatment?.symptomToFmc,
                              onChanged: (val) => nstemiTreatment
                                  ?.symptomToFmc = val.toString(),
                            ),
                            TimeMetricInput(
                              label: "FMC to ECG time",
                              initialValue: nstemiTreatment?.fmcToEcg,
                              onChanged: (val) =>
                                  nstemiTreatment?.fmcToEcg = val.toString(),
                            ),
                            Obx(() {
                              final hospitalStayDays = stemiController
                                      .stemiModel
                                      .value
                                      .nstemiTreatment
                                      ?.hospitalStayDays
                                      ?.toString() ??
                                  "0";
                              return TitleTextFormField(
                                readOnly: true,
                                title: "Duration of hospital stay",
                                hintText: "Days",
                                controller: TextEditingController(
                                    text: hospitalStayDays),
                                keyboardType: TextInputType.number,
                                onChanged: (_) {}, // Prevent manual edits
                              );
                            }),
                            NewTitleDropdown(
                              isRequired: true,
                              title: "Outcome",
                              hint: "Select",
                              items: stemiController
                                      .stemiLookup.value.outcomeType
                                      ?.map((e) => {"id": e.id, "name": e.name})
                                      .toList() ??
                                  [],
                              selectedId: model.nstemiOutcome?.outcomeTypeId,
                              onChanged: (val) {
                                model.nstemiOutcome?.outcomeTypeId = val;
                                stemiController.stemiModel.refresh();
                              },
                            ),
                            buildOutcomeFields1(nstemiOutcome),
                          ],
                          if (nstemiTreatment?.treatmentStrategyId == 3 ||
                              nstemiTreatment?.treatmentStrategyId == 2) ...[
                            Obx(() {
                              final managementList = stemiController.stemiLookup
                                      .value.conservativeManagement ??
                                  [];

                              if (managementList.isEmpty) {
                                return const Text(
                                  "No Management options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem model
                              final options = managementList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from model string ("1,2,3" → [1,2,3])
                              final selectedIds = (model
                                          .nstemiTreatment?.managementId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Conservative Management",
                                options: options,
                                initialSelectedIndexes:
                                    selectedIds, // matches widget param
                                onChanged: (selectedValues) {
                                  // Convert selected IDs back to comma-separated string
                                  model.nstemiTreatment?.managementId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // refresh reactive state
                                },
                              );
                            }),
                            NewTitleYesRadio(
                              title: "Patient planned for CAG",
                              initialValue: nstemiTreatment?.plannedCag,
                              onChanged: (val) {
                                nstemiTreatment?.plannedCag = val;
                                stemiController.stemiModel.refresh();
                              },
                            ),
                            // ],
                            if (nstemiTreatment?.plannedCag == true) ...[
                              Obx(() {
                                final list = stemiController.stemiLookup.value
                                        .stemiCoronoryAngiography ??
                                    [];

                                if (list.isEmpty) {
                                  return const Text(
                                      "No Angiography Types available");
                                }

                                return NewCustomRadioList(
                                  isRequired: true,
                                  title: "Coronary angiography",
                                  options: list
                                      .map((e) =>
                                          LooksUpItem(id: e.id, name: e.name))
                                      .toList(),
                                  initialId:
                                      nstemiTreatment?.coronoryAngiographyId,
                                  onChanged: (id) {
                                    nstemiTreatment?.coronoryAngiographyId = id;
                                    stemiController.stemiModel
                                        .refresh(); // 🔁 refresh UI
                                    debugPrint(
                                        "Updated coronoryAngiographyId: $id");
                                  },
                                );
                              }),
                              CommonDateTimeWidget(
                                isRequired: true,
                                title: "Cath Lab Arrival Date & Time",
                                dateTime: nstemiTreatment?.cathLabArrival
                                        .toString() ??
                                    "",
                                onChanged: (picked) {
                                  nstemiTreatment?.cathLabArrival =
                                      picked.toString();
                                  stemiController.stemiModel.refresh();
                                },
                              ),
                              CommonDateTimeWidget(
                                isRequired: true,
                                title: "Date and Time of Balloon inflation",
                                dateTime: nstemiTreatment?.balloonInflation
                                        .toString() ??
                                    "",
                                onChanged: (picked) {
                                  nstemiTreatment?.balloonInflation =
                                      picked.toString();
                                  calculateTimeDifference2NStemi(
                                    widget.triageDate,
                                    nstemiTreatment?.balloonInflation,
                                  );
                                  stemiController.stemiModel.refresh();
                                },
                              ),
                              TimeMetricInput(
                                label: "Door-to-balloon time (for PCI)",
                                initialValue: nstemiTreatment?.doorToBalloon,
                                onChanged: (val) => nstemiTreatment
                                    ?.doorToBalloon = val.toString(),
                              ),

                              // Stent Type
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.stentType ??
                                    [];
                                if (list.isEmpty)
                                  return const Text("No Stent Types available");
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: "Stent Type",
                                  hint: "Select Stent Type",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: nstemiTreatment?.stentTypeId,
                                  onChanged: (val) {
                                    nstemiTreatment?.stentTypeId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),

                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.stemiComplications ??
                                    [];

                                if (list.isEmpty) {
                                  return const Text(
                                      "No Complications available");
                                }

                                // Safely parse selectedId
                                final selectedId =
                                    (nstemiTreatment?.complications != null &&
                                            nstemiTreatment!.complications
                                                .toString()
                                                .isNotEmpty)
                                        ? int.tryParse(nstemiTreatment!
                                            .complications
                                            .toString())
                                        : null;

                                return NewTitleDropdown(
                                  title: 'Complications',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: selectedId,
                                  onChanged: (val) {
                                    nstemiTreatment?.complications =
                                        val.toString();
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              if (nstemiTreatment?.complications == 8)
                                TitleTextFormField(
                                  title: "Others",
                                  hintText: "",
                                  initialValue:
                                      nstemiTreatment?.otherComplications,
                                  onChanged: (val) {
                                    nstemiTreatment?.otherComplications = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                ),

                              // if (nstemiTreatment?.treatmentStrategyId == 2 ||
                              //     nstemiTreatment?.treatmentStrategyId == 3 ||
                              //     nstemiTreatment?.treatmentStrategyId == 4) ...[
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty)
                                  return const Text(
                                      "No Transfer Locations available");
                                return NewTitleDropdown(
                                  title: "Patient Transferred to:",
                                  hint: "Select Location",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId:
                                      nstemiTreatment?.transferLocationId,
                                  onChanged: (val) {
                                    nstemiTreatment?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                            ],
                            // if (nstemiTreatment?.treatmentStrategyId == 1) ...[
                            Obx(() {
                              final counsellingList = stemiController
                                      .stemiLookup
                                      .value
                                      .preDischargeCounselling ??
                                  [];

                              if (counsellingList.isEmpty) {
                                return const Text(
                                  "No Pre-Discharge Counselling options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem
                              final options = counsellingList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from the model
                              final selectedIds = (model
                                          .nstemiTreatment?.counsellingId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Pre-Discharge Counselling Given for",
                                options: options,
                                initialSelectedIndexes: selectedIds,
                                // ✅ matches your NewCheckboxList API
                                onChanged: (selectedValues) {
                                  model.nstemiTreatment?.counsellingId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // Refresh GetX reactive state
                                },
                              );
                            }),
                            // if (nstemiTreatment?.treatmentStrategyId == 1 ||
                            //     nstemiTreatment?.treatmentStrategyId == 2) ...[
                            TimeMetricInput(
                              label: "Symptom onset to FMC time",
                              initialValue: nstemiTreatment?.symptomToFmc,
                              onChanged: (val) => nstemiTreatment
                                  ?.symptomToFmc = val.toString(),
                            ),
                            TimeMetricInput(
                              label: "FMC to ECG time",
                              initialValue: nstemiTreatment?.fmcToEcg,
                              onChanged: (val) =>
                                  nstemiTreatment?.fmcToEcg = val.toString(),
                            ),
                            Obx(() {
                              final hospitalStayDays = stemiController
                                      .stemiModel
                                      .value
                                      .nstemiTreatment
                                      ?.hospitalStayDays
                                      ?.toString() ??
                                  "0";
                              return TitleTextFormField(
                                readOnly: true,
                                title: "Duration of hospital stay",
                                hintText: "Days",
                                controller: TextEditingController(
                                    text: hospitalStayDays),
                                keyboardType: TextInputType.number,
                                onChanged: (_) {}, // Prevent manual edits
                              );
                            }),
                            NewTitleDropdown(
                              isRequired: true,
                              title: "Outcome",
                              hint: "Select",
                              items: stemiController
                                      .stemiLookup.value.outcomeType
                                      ?.map((e) => {"id": e.id, "name": e.name})
                                      .toList() ??
                                  [],
                              selectedId: model.nstemiOutcome?.outcomeTypeId,
                              onChanged: (val) {
                                model.nstemiOutcome?.outcomeTypeId = val;
                                stemiController.stemiModel.refresh();
                              },
                            ),
                            buildOutcomeFields1(nstemiOutcome),
                          ],
                        ],
                        if (stemiClinicalAssessment?.diagnosis == 1) ...[
                          // Center(child: Text("Unstable")),
                          CommonDateTimeWidget(
                            title: "Unstable Angina Confirmed Date",
                            dateTime: unstableanginaTreatment?.nstemiConfirmedAt
                                    .toString() ??
                                "",
                            onChanged: (picked) {
                              unstableanginaTreatment?.nstemiConfirmedAt =
                                  picked.toString();
                              stemiController.stemiModel.refresh();
                            },
                          ),
                          Obx(() {
                            final list = stemiController.stemiLookup.value
                                    .nstemiLoadingDoseLocation ??
                                [];

                            if (list.isEmpty) {
                              return const Text(
                                  "No Loading Dose Locations available");
                            }

                            int? selectedId =
                                unstableanginaTreatment?.loadingDoseLocationId;

                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      Text(
                                        'Loading Dose given at',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        ' *',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ],
                                  ),
                                  initiallyExpanded: true,
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 6),
                                  children: list.map<Widget>((option) {
                                    return RadioListTile<int>(
                                      title: Text(option.name ?? ""),
                                      value: option.id!,
                                      groupValue: selectedId,
                                      onChanged: (id) {
                                        stemiController.stemiModel
                                            .update((model) {
                                          model?.unstableanginaTreatment
                                              ?.loadingDoseLocationId = id;
                                        });
                                        debugPrint(
                                            "Updated loadingDoseLocationId: $id");
                                      },
                                      contentPadding: EdgeInsets.zero,
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          }),

                          // Loading Dose Time
                          // CommonDateTimeWidget(
                          //   title: "Loading Dose Time",
                          //   dateTime: unstableanginaTreatment?.loadingDoseTime
                          //           .toString() ??
                          //       "",
                          //   onChanged: (picked) {
                          //     unstableanginaTreatment?.loadingDoseTime = picked.toString();
                          //     stemiController.stemiModel.refresh();
                          //   },
                          // ),

                          Obx(() {
                            final list = stemiController
                                    .stemiLookup.value.timiRiskScore ??
                                [];
                            if (list.isEmpty)
                              return const Text(
                                  "No TIMI Risk Scores available");
                            return NewTitleDropdown(
                              isRequired: true,
                              title:
                                  "Cardiac Risk Stratification- TIMI risk score for Unstable/UA",
                              hint: "Select Score",
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId:
                                  unstableanginaTreatment?.timiRiskScoreId,
                              onChanged: (val) {
                                unstableanginaTreatment?.timiRiskScoreId = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),
                          // ],

                          // Treatment Strategy
                          Obx(() {
                            final list = stemiController.stemiLookup.value
                                    .nstemiTreatmentStrategy ??
                                [];
                            if (list.isEmpty)
                              return const Text(
                                  "No Treatment Strategies available");
                            return NewTitleDropdown(
                              isRequired: true,
                              title: "Treatment Strategy",
                              hint: "Select Strategy",
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId:
                                  unstableanginaTreatment?.treatmentStrategyId,
                              onChanged: (val) {
                                unstableanginaTreatment?.treatmentStrategyId =
                                    val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),
                          if (unstableanginaTreatment?.treatmentStrategyId ==
                              1) ...[
                            Obx(() {
                              final managementList = stemiController.stemiLookup
                                      .value.conservativeManagement ??
                                  [];

                              if (managementList.isEmpty) {
                                return const Text(
                                  "No Management options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem model
                              final options = managementList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from model string ("1,2,3" → [1,2,3])
                              final selectedIds = (model
                                          .unstableanginaTreatment?.managementId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Conservative Management",
                                options: options,
                                initialSelectedIndexes:
                                    selectedIds, // matches your widget API
                                onChanged: (selectedValues) {
                                  // Update model with selected IDs as comma-separated string
                                  model.unstableanginaTreatment?.managementId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // refresh reactive UI
                                },
                              );
                            }),
                            Obx(() {
                              final counsellingList = stemiController
                                      .stemiLookup
                                      .value
                                      .preDischargeCounselling ??
                                  [];

                              if (counsellingList.isEmpty) {
                                return const Text(
                                  "No Pre-Discharge Counselling options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem
                              final options = counsellingList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from the model
                              final selectedIds = (model.unstableanginaTreatment
                                          ?.counsellingId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Pre-Discharge Counselling Given for",
                                options: options,
                                initialSelectedIndexes: selectedIds,
                                // ✅ matches your NewCheckboxList API
                                onChanged: (selectedValues) {
                                  model.unstableanginaTreatment?.counsellingId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // Refresh GetX reactive state
                                },
                              );
                            }),
                          ],
                          if (unstableanginaTreatment?.treatmentStrategyId ==
                              4) ...[
                            Obx(() {
                              final managementList = stemiController.stemiLookup
                                      .value.conservativeManagement ??
                                  [];

                              if (managementList.isEmpty) {
                                return const Text(
                                  "No Management options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem model
                              final options = managementList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from model string ("1,2,3" → [1,2,3])
                              final selectedIds = (model
                                          .unstableanginaTreatment?.managementId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Conservative Management",
                                options: options,
                                initialSelectedIndexes:
                                    selectedIds, // matches your widget API
                                onChanged: (selectedValues) {
                                  // Update model with selected IDs as comma-separated string
                                  model.unstableanginaTreatment?.managementId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // refresh reactive UI
                                },
                              );
                            }),
                            NewTitleYesRadio(
                              title: "Patient planned for CAG",
                              initialValue: unstableanginaTreatment?.plannedCag,
                              onChanged: (val) {
                                unstableanginaTreatment?.plannedCag = val;
                                stemiController.stemiModel.refresh();
                              },
                            ),
                            // ],
                            if (unstableanginaTreatment?.plannedCag ==
                                true) ...[
                              Obx(() {
                                final list = stemiController.stemiLookup.value
                                        .stemiCoronoryAngiography ??
                                    [];

                                if (list.isEmpty) {
                                  return const Text(
                                      "No Angiography Types available");
                                }

                                return NewCustomRadioList(
                                  isRequired: true,
                                  title: "Coronary angiography",
                                  options: list
                                      .map((e) =>
                                          LooksUpItem(id: e.id, name: e.name))
                                      .toList(),
                                  initialId: unstableanginaTreatment
                                      ?.coronoryAngiographyId,
                                  onChanged: (id) {
                                    unstableanginaTreatment
                                        ?.coronoryAngiographyId = id;
                                    stemiController.stemiModel
                                        .refresh(); // 🔁 refresh UI
                                    debugPrint(
                                        "Updated coronoryAngiographyId: $id");
                                  },
                                );
                              }),
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty)
                                  return const Text(
                                      "No Transfer Locations available");
                                return NewTitleDropdown(
                                  title: "Patient Transferred to:",
                                  hint: "Select Location",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: unstableanginaTreatment
                                      ?.transferLocationId,
                                  onChanged: (val) {
                                    unstableanginaTreatment
                                        ?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                            ],
                            // if (nstemiTreatment?.treatmentStrategyId == 1) ...[
                            Obx(() {
                              final counsellingList = stemiController
                                      .stemiLookup
                                      .value
                                      .preDischargeCounselling ??
                                  [];

                              if (counsellingList.isEmpty) {
                                return const Text(
                                  "No Pre-Discharge Counselling options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem
                              final options = counsellingList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from the model
                              final selectedIds = (model.unstableanginaTreatment
                                          ?.counsellingId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Pre-Discharge Counselling Given for",
                                options: options,
                                initialSelectedIndexes: selectedIds,
                                onChanged: (selectedValues) {
                                  model.unstableanginaTreatment?.counsellingId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // Refresh GetX reactive state
                                },
                              );
                            }),
                            TimeMetricInput(
                              label: "Symptom onset to FMC time",
                              initialValue:
                                  unstableanginaTreatment?.symptomToFmc,
                              onChanged: (val) => unstableanginaTreatment
                                  ?.symptomToFmc = val.toString(),
                            ),
                            TimeMetricInput(
                              label: "FMC to ECG time",
                              initialValue: unstableanginaTreatment?.fmcToEcg,
                              onChanged: (val) => unstableanginaTreatment
                                  ?.fmcToEcg = val.toString(),
                            ),
                            Obx(() {
                              final hospitalStayDays = stemiController
                                      .stemiModel
                                      .value
                                      .unstableanginaTreatment
                                      ?.hospitalStayDays
                                      ?.toString() ??
                                  "0";
                              return TitleTextFormField(
                                readOnly: true,
                                title: "Duration of hospital stay",
                                hintText: "Days",
                                controller: TextEditingController(
                                    text: hospitalStayDays),
                                keyboardType: TextInputType.number,
                                onChanged: (_) {}, // Prevent manual edits
                              );
                            }),
                          ],
                          if (unstableanginaTreatment?.treatmentStrategyId ==
                                  3 ||
                              unstableanginaTreatment?.treatmentStrategyId ==
                                  2) ...[
                            Obx(() {
                              final managementList = stemiController.stemiLookup
                                      .value.conservativeManagement ??
                                  [];

                              if (managementList.isEmpty) {
                                return const Text(
                                  "No Management options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup data to LooksUpItem model
                              final options = managementList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Parse selected IDs from model string ("1,2,3" → [1,2,3])
                              final selectedIds = (model
                                          .unstableanginaTreatment?.managementId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Conservative Management",
                                options: options,
                                initialSelectedIndexes:
                                    selectedIds, // matches NewCheckboxList API
                                onChanged: (selectedValues) {
                                  // Update model with selected IDs as comma-separated string
                                  model.unstableanginaTreatment?.managementId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // refresh reactive UI
                                },
                              );
                            }),

                            NewTitleYesRadio(
                              title: "Patient planned for CAG",
                              initialValue: unstableanginaTreatment?.plannedCag,
                              onChanged: (val) {
                                unstableanginaTreatment?.plannedCag = val;
                                stemiController.stemiModel.refresh();
                              },
                            ),
                            // ],
                            if (unstableanginaTreatment?.plannedCag ==
                                true) ...[
                              Obx(() {
                                final list = stemiController.stemiLookup.value
                                        .stemiCoronoryAngiography ??
                                    [];

                                if (list.isEmpty) {
                                  return const Text(
                                      "No Angiography Types available");
                                }

                                return NewCustomRadioList(
                                  isRequired: true,
                                  title: "Coronary angiography",
                                  options: list
                                      .map((e) =>
                                          LooksUpItem(id: e.id, name: e.name))
                                      .toList(),
                                  initialId: unstableanginaTreatment
                                      ?.coronoryAngiographyId,
                                  onChanged: (id) {
                                    unstableanginaTreatment
                                        ?.coronoryAngiographyId = id;
                                    stemiController.stemiModel
                                        .refresh(); // 🔁 refresh UI
                                    debugPrint(
                                        "Updated coronoryAngiographyId: $id");
                                  },
                                );
                              }),
                              CommonDateTimeWidget(
                                isRequired: true,
                                title: "Cath Lab Arrival Date & Time",
                                dateTime: unstableanginaTreatment
                                        ?.cathLabArrival
                                        .toString() ??
                                    "",
                                onChanged: (picked) {
                                  unstableanginaTreatment?.cathLabArrival =
                                      picked.toString();
                                  stemiController.stemiModel.refresh();
                                },
                              ),
                              CommonDateTimeWidget(
                                isRequired: true,
                                title: "Date and Time of Balloon inflation",
                                dateTime: unstableanginaTreatment
                                        ?.balloonInflation
                                        .toString() ??
                                    "",
                                onChanged: (picked) {
                                  unstableanginaTreatment?.balloonInflation =
                                      picked.toString();
                                  calculateTimeDifference2Unstable(
                                    unstableanginaTreatment?.balloonInflation,
                                    widget.triageDate,
                                  );
                                  stemiController.stemiModel.refresh();
                                },
                              ),

                              // Stent Type
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.stentType ??
                                    [];
                                if (list.isEmpty)
                                  return const Text("No Stent Types available");
                                return NewTitleDropdown(
                                  isRequired: true,
                                  title: "Stent Type",
                                  hint: "Select Stent Type",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId:
                                      unstableanginaTreatment?.stentTypeId,
                                  onChanged: (val) {
                                    unstableanginaTreatment?.stentTypeId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),

                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.stemiComplications ??
                                    [];

                                if (list.isEmpty) {
                                  return const Text(
                                      "No Complications available");
                                }

                                // Safely parse selectedId
                                final selectedId = (unstableanginaTreatment
                                                ?.complications !=
                                            null &&
                                        unstableanginaTreatment!.complications
                                            .toString()
                                            .isNotEmpty)
                                    ? int.tryParse(unstableanginaTreatment!
                                        .complications
                                        .toString())
                                    : null;

                                return NewTitleDropdown(
                                  title: 'Complications',
                                  hint: 'Select Type',
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: selectedId,
                                  onChanged: (val) {
                                    unstableanginaTreatment?.complications =
                                        val.toString();
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                              if (unstableanginaTreatment?.complications == 8)
                                TitleTextFormField(
                                  title: "Others",
                                  hintText: "",
                                  initialValue: unstableanginaTreatment
                                      ?.otherComplications,
                                  onChanged: (val) {
                                    unstableanginaTreatment
                                        ?.otherComplications = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                ),
                              Obx(() {
                                final list = stemiController
                                        .stemiLookup.value.transferLocation ??
                                    [];
                                if (list.isEmpty)
                                  return const Text(
                                      "No Transfer Locations available");
                                return NewTitleDropdown(
                                  title: "Patient Transferred to:",
                                  hint: "Select Location",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: unstableanginaTreatment
                                      ?.transferLocationId,
                                  onChanged: (val) {
                                    unstableanginaTreatment
                                        ?.transferLocationId = val;
                                    stemiController.stemiModel.refresh();
                                  },
                                );
                              }),
                            ],
                            // if (nstemiTreatment?.treatmentStrategyId == 1) ...[
                            Obx(() {
                              final counsellingList = stemiController
                                      .stemiLookup
                                      .value
                                      .preDischargeCounselling ??
                                  [];

                              if (counsellingList.isEmpty) {
                                return const Text(
                                  "No Pre-Discharge Counselling options available",
                                  style: TextStyle(color: Colors.black54),
                                );
                              }

                              // Convert lookup list to LooksUpItem model
                              final options = counsellingList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Get selected IDs from the model (comma-separated string → List<int>)
                              final selectedIds = (model.unstableanginaTreatment
                                          ?.counsellingId
                                          ?.split(',') ??
                                      [])
                                  .map((e) => int.tryParse(e.trim()) ?? 0)
                                  .where((id) => id != 0)
                                  .toList();

                              return NewCheckboxList(
                                title: "Pre-Discharge Counselling Given for",
                                options: options,
                                initialSelectedIndexes:
                                    selectedIds, // matches NewCheckboxList API
                                onChanged: (selectedValues) {
                                  // Update model with selected IDs as comma-separated string
                                  model.unstableanginaTreatment?.counsellingId =
                                      selectedValues.join(',');
                                  stemiController.stemiModel
                                      .refresh(); // Refresh GetX reactive UI
                                },
                              );
                            }),
                            // if (nstemiTreatment?.treatmentStrategyId == 1 ||
                            //     nstemiTreatment?.treatmentStrategyId == 2) ...[
                            TimeMetricInput(
                              label: "Symptom onset to FMC time",
                              initialValue:
                                  unstableanginaTreatment?.symptomToFmc,
                              onChanged: (val) => unstableanginaTreatment
                                  ?.symptomToFmc = val.toString(),
                            ),
                            TimeMetricInput(
                              label: "FMC to ECG time",
                              initialValue: unstableanginaTreatment?.fmcToEcg,
                              onChanged: (val) => unstableanginaTreatment
                                  ?.fmcToEcg = val.toString(),
                            ),
                            Obx(() {
                              final hospitalStayDays = stemiController
                                      .stemiModel
                                      .value
                                      .unstableanginaTreatment
                                      ?.hospitalStayDays
                                      ?.toString() ??
                                  "0";
                              return TitleTextFormField(
                                readOnly: true,
                                title: "Duration of hospital stay",
                                hintText: "Days",
                                controller: TextEditingController(
                                    text: hospitalStayDays),
                                keyboardType: TextInputType.number,
                                onChanged: (_) {}, // Prevent manual edits
                              );
                            }),
                          ],

                          NewTitleDropdown(
                            isRequired: true,
                            title: "Outcome",
                            hint: "Select",
                            items: stemiController.stemiLookup.value.outcomeType
                                    ?.map((e) => {"id": e.id, "name": e.name})
                                    .toList() ??
                                [],
                            selectedId:
                                model.unstableanginaOutcome?.outcomeTypeId,
                            onChanged: (val) {
                              model.unstableanginaOutcome?.outcomeTypeId = val;
                              stemiController.stemiModel.refresh();
                            },
                          ),
                          buildOutcomeFields2(unstableanginaOutcome),
                        ],

                        if (stemiClinicalAssessment?.diagnosis == 4) ...[
                          NewTitleYesRadio(
                            isRequired: true,
                            initialValue:
                                model.othersTreatment?.isProcedureDone,
                            title: "Procedure Done",
                            onChanged: (value) {
                              // Ensure the object exists
                              model.othersTreatment ??= OthersTreatment();
                              model.othersTreatment!.isProcedureDone = value;

                              // Refresh the reactive model
                              stemiController.stemiModel.refresh();
                            },
                          ),
                          CommonDateTimeWidget(
                            isRequired: true,
                            title: "Cath Lab Arrival Date & Time",
                            dateTime:
                                otherTreatment?.cathlabArrivalDate.toString() ??
                                    "",
                            onChanged: (picked) {
                              otherTreatment?.cathlabArrivalDate =
                                  picked.toString();
                              stemiController.stemiModel.refresh();
                            },
                          ),
                          Obx(() {
                            final list = stemiController
                                    .stemiLookup.value.stemiCathLabProcedure ??
                                [];
                            if (list.isEmpty) {
                              return const Text("No Type of Sting available");
                            }
                            return NewTitleDropdown(
                              isRequired: true,
                              title: 'Procedure Done in Cath Lab',
                              hint: 'Select Type',
                              items: list
                                  .map((e) => {"id": e.id, "name": e.name})
                                  .toList(),
                              selectedId: otherTreatment?.procedureId,
                              onChanged: (val) {
                                otherTreatment?.procedureId = val;
                                stemiController.stemiModel.refresh();
                              },
                            );
                          }),
                          if (otherTreatment?.procedureId == 13) ...[
                            TitleTextFormField(
                              title: "Others",
                              hintText: "",
                              initialValue: otherTreatment?.otherProcedure,
                              onChanged: (val) {
                                otherTreatment?.otherProcedure = val;
                                stemiController.stemiModel.refresh();
                              },
                            ),
                          ],
                          Obx(() {
                            final hospitalStayDays = stemiController.stemiModel
                                    .value.othersTreatment?.hospitalStay
                                    ?.toString() ??
                                "0";
                            return TitleTextFormField(
                              readOnly: true,
                              title: "Duration of hospital stay",
                              hintText: "Days",
                              controller:
                                  TextEditingController(text: hospitalStayDays),
                              keyboardType: TextInputType.number,
                              onChanged: (_) {}, // Prevent manual edits
                            );
                          }),
                          NewTitleDropdown(
                            isRequired: true,
                            title: "Outcome",
                            hint: "Select",
                            items: stemiController.stemiLookup.value.outcomeType
                                    ?.map((e) => {"id": e.id, "name": e.name})
                                    .toList() ??
                                [],
                            selectedId: model.othersTreatment?.outcomeTypeId,
                            onChanged: (val) {
                              model.othersTreatment?.outcomeTypeId = val;
                              stemiController.stemiModel.refresh();
                            },
                          ),
                          buildOutcomeFields21(otherTreatment),
                        ],

                        // widget.create == true
                        //     ? Center(
                        //         child: CommonElevatedButton(
                        //           text: widget.id != null ? "Update" : "Submit",
                        //           onPressed: () async {
                        //             // if (!validatePremForm()) return;
                        //             stemiController.stemiModel.value.opPatient
                        //                     ?.dateTimeOfTriage =
                        //                 DateFormat('yyyy-MM-dd HH:mm')
                        //                     .format(now);
                        //             if (widget.id != null) {
                        //               setState(() {
                        //                 stemiController
                        //                     .stemiModel.value.triageId = 0;
                        //                 stemiController
                        //                         .stemiModel.value.patientId =
                        //                     int.parse(widget.id.toString());
                        //               });
                        //             }
                        //             debugPrint(
                        //                 "${stemiController.stemiModel.value.triageId} imman");
                        //             debugPrint(
                        //                 "${stemiController.stemiModel.value.stemiAdmission?.triageId}don't push your self");
                        //             bool success = await stemiController
                        //                 .createSteam(data: model);
                        //             if (success) {
                        //               Fluttertoast.showToast(
                        //                   msg: "Created successfully!");
                        //               _initializeData();
                        //             } else {
                        //               Fluttertoast.showToast(
                        //                   msg: "Failed to create.");
                        //             }
                        //           },
                        //           icon: Icons.save,
                        //         ),
                        //       )
                        //     : Center(
                        //         child: CommonElevatedButton(
                        //           text: widget.id != null ? "Update" : "Submit",
                        //           onPressed: () async {
                        //             // if (!validatePremForm()) return;
                        //             if (widget.id != null) {
                        //               setState(() {
                        //                 stemiController
                        //                         .stemiModel.value.triageId =
                        //                     int.parse(widget.id.toString());
                        //               });
                        //             }
                        //             debugPrint(
                        //                 "${stemiController.stemiModel.value.triageId} imman");
                        //             debugPrint(
                        //                 "${stemiController.stemiModel.value.stemiAdmission?.triageId}don't push your self");
                        //             bool success = await stemiController
                        //                 .createSteam(data: model);
                        //             if (success) {
                        //               Fluttertoast.showToast(
                        //                   msg: "Created successfully!");
                        //               Navigator.pop(context, true);
                        //               //  Navigator.push(
                        //               //   context,
                        //               //   MaterialPageRoute(
                        //               //     builder: (context) => StemiListPageOp(),
                        //               //   ),
                        //               // );
                        //             } else {
                        //               Fluttertoast.showToast(
                        //                   msg: "Failed to create.");
                        //             }
                        //           },
                        //           icon: Icons.save,
                        //         ),
                        //       ),
                        Center(
                          child: CommonElevatedButton(
                            text: widget.id != null ? "Update" : "Submit",
                            icon: Icons.save,
                            onPressed: _showSaveOrSubmitDialog,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void showValidationError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,

      // Mobile (Android/iOS)
      backgroundColor: const Color(0xFFD32F2F), // Material Design red 700
      textColor: Colors.white,

      // Web fix (very important!)
      webBgColor: "#d32f2f", // hex red
      webShowClose: false,

      fontSize: context.isDesktop ? 18.0 : 15.0,
    );
  }

  void _showSaveOrSubmitDialog() {
    showDialog(
      context: context,
      builder: (context) => SaveOrSubmitDialog(
        title: 'Save or Submit',
        content: 'Do you want to save or submit?',
        onSave: () => _handleStemiAction(isSubmit: true),
        onSubmit: () => _handleStemiAction(isSubmit: false),
      ),
    );
  }

  Future<void> _handleStemiAction({required bool isSubmit}) async {
    final model = stemiController.stemiModel.value;
    final now = DateTime.now();

    if (!validatePremForm(isSubmit)) return;

    // Set triage time
    model.opPatient?.dateTimeOfTriage =
        DateFormat('yyyy-MM-dd HH:mm').format(now);

    final int parsedId = int.tryParse(widget.id.toString()) ?? 0;

    if (widget.id != null) {
      if (widget.create == true) {
        // OP Mode
        model.triageId = 0;
        model.patientId = parsedId;
      } else {
        model.triageId = parsedId;
      }
    }

    // 🔥 Important: Save vs Submit difference
    model.stemiAdmission?.is_discharged = isSubmit;

    bool success = await stemiController.createSteam(data: model);

    Get.back(); // Close dialog

    if (success) {
      Fluttertoast.showToast(
        msg: isSubmit ? "Submitted successfully!" : "Saved successfully!",
      );

      if (widget.create == true) {
        _initializeData();
      } else {
        Navigator.pop(context, true);
      }
    } else {
      Fluttertoast.showToast(msg: "Operation failed.");
    }
  }

  // bool validatePremForm() {
  //   final model = stemiController.stemiModel.value;
  //
  //   if (widget.create == true) {
  //     final op = model.opPatient;
  //
  //     if (op?.gender == null) {
  //       showValidationError("Gender is a mandatory field");
  //       return false;
  //     }
  //
  //     if (op?.maritalStatus == null) {
  //       showValidationError("Marital Status is a mandatory field");
  //       return false;
  //     }
  //
  //     if (op?.patientEhrId == null) {
  //       showValidationError("Patient EHR ID is a mandatory field");
  //       return false;
  //     }
  //
  //     final procedureDone = model.othersTreatment?.isProcedureDone;
  //     if (procedureDone == null) {
  //       showValidationError("Procedure Done is a mandatory field");
  //       return false;
  //     }
  //
  //     if (procedureDone == true &&
  //         model.othersTreatment?.procedureId == null) {
  //       showValidationError("Procedure Done (Cath Lab) is mandatory");
  //       return false;
  //     }
  //
  //     if (model.othersTreatment?.outcomeTypeId == null) {
  //       showValidationError("Outcome is a mandatory field");
  //       return false;
  //     }
  //   }
  //
  //   /// ------------------------------------------------
  //   /// CLINICAL ASSESSMENT (COMMON)
  //   /// ------------------------------------------------
  //   final assessment = model.stemiClinicalAssessment;
  //
  //   if (assessment?.signsSymtoms == null ||
  //       assessment!.signsSymtoms!.isEmpty) {
  //     showValidationError("Signs & Symptoms is a mandatory field");
  //     return false;
  //   }
  //
  //   if (assessment?.cvRiskFactors == null){
  //     showValidationError("CV Risk Factors is a mandatory field");
  //     return false;
  //   }
  //
  //   if (assessment?.fmcType == null) {
  //     showValidationError("FMC Type is a mandatory field");
  //     return false;
  //   }
  //
  //   if (assessment?.diagnosis == null) {
  //     showValidationError("Diagnosis is a mandatory field");
  //     return false;
  //   }
  //
  //   final diagnosis = assessment!.diagnosis;
  //
  //   /// ------------------------------------------------
  //   /// STEMI
  //   /// ------------------------------------------------
  //   if (diagnosis == 1) {
  //     final t = model.stemiTreatment;
  //     final o = model.stemiOutcome;
  //
  //     if (t?.stemiConfirmedAt == null) {
  //       showValidationError("STEMI Confirmed Date is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.infarctionLocationId == null) {
  //       showValidationError("Location of Infarction (ECG) is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.loadingDoseLocationId == null) {
  //       showValidationError("Loading Dose Given At is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.thrombolysisLocationId == null) {
  //       showValidationError("Thrombolysis Done At is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.thrombolyticAgentId == null) {
  //       showValidationError("Thrombolytic Agent is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.treatmentStrategyId == null) {
  //       showValidationError("Treatment Strategy is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.killipRiskScoreId == null) {
  //       showValidationError("Killip Risk Score is mandatory");
  //       return false;
  //     }
  //
  //     if (o?.outcomeTypeId == null) {
  //       showValidationError("STEMI Outcome is mandatory");
  //       return false;
  //     }
  //   }
  //   if (diagnosis == 2) {
  //     final t = model.nstemiTreatment;
  //     final o = model.nstemiOutcome;
  //
  //     if (t?.nstemiConfirmedAt == null) {
  //       showValidationError("NSTEMI Confirmed Date is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.loadingDoseLocationId == null) {
  //       showValidationError("Loading Dose Given At is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.timiRiskScoreId == null) {
  //       showValidationError("TIMI Risk Score is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.treatmentStrategyId == null) {
  //       showValidationError("Treatment Strategy is mandatory");
  //       return false;
  //     }
  //
  //     if (o?.outcomeTypeId == null) {
  //       showValidationError("NSTEMI Outcome is mandatory");
  //       return false;
  //     }
  //
  //     if (o?.outcomeTypeId == 4 && o?.otherDeathTiming == null) {
  //       showValidationError("Timing of Death is mandatory");
  //       return false;
  //     }
  //   }
  //
  //   /// ------------------------------------------------
  //   /// UNSTABLE ANGINA
  //   /// ------------------------------------------------
  //   if (diagnosis == 3) {
  //     final t = model.unstableanginaTreatment;
  //     final o = model.unstableanginaOutcome;
  //
  //     if (t?.nstemiConfirmedAt == null) {
  //       showValidationError("Unstable Angina Confirmed Date is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.loadingDoseLocationId == null) {
  //       showValidationError("Loading Dose Given At is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.timiRiskScoreId == null) {
  //       showValidationError("TIMI Risk Score is mandatory");
  //       return false;
  //     }
  //
  //     if (t?.treatmentStrategyId == null) {
  //       showValidationError("Treatment Strategy is mandatory");
  //       return false;
  //     }
  //
  //     if (o?.outcomeTypeId == null) {
  //       showValidationError("Outcome is a mandatory field");
  //       return false;
  //     }
  //
  //     if (o?.outcomeTypeId == 4 && o?.otherDeathTiming == null) {
  //       showValidationError("Timing of Death is mandatory");
  //       return false;
  //     }
  //   }
  //
  //   return true;
  // }

  bool validatePremForm(bool isSubmit) {
    final model = stemiController.stemiModel.value;

    // ------------------- OP Patient (only when creating new OP form) -------------------
    if (widget.create == true) {
      final op = model.opPatient;

      if (op?.gender == null) {
        showValidationError("Gender is a mandatory field");
        return false;
      }

      if (op?.maritalStatus == null) {
        showValidationError("Marital Status is a mandatory field");
        return false;
      }
    }

    if (model.stemiAdmission?.dateTimeEntry == null) {
      showValidationError("dateTimeEntry is a mandatory field");
      return false;
    }

    // ------------------- Common Clinical Assessment -------------------
    final assessment = model.stemiClinicalAssessment;

    if (assessment?.signsSymtoms == null || assessment!.signsSymtoms!.isEmpty) {
      showValidationError("Signs & Symptoms is a mandatory field");
      return false;
    }

    if (assessment?.riskFactors == null || assessment.riskFactors!.isEmpty) {
      showValidationError(
          "Known cardiovascular risk factors is a mandatory field");
      return false;
    }

    if (assessment?.fmcType == null) {
      showValidationError("Type of first medical contact is a mandatory field");
      return false;
    }

    if (assessment?.diagnosis == null) {
      showValidationError("Diagnosis is a mandatory field");
      return false;
    }

    final diagnosis = assessment.diagnosis;

    // ------------------- STEMI (diagnosis == 3) -------------------
    if (diagnosis == 3) {
      final t = model.stemiTreatment;
      final o = model.stemiOutcome;

      if (t?.stemiConfirmedAt == null) {
        showValidationError("STEMI Confirmed (Date & Time) is mandatory");
        return false;
      }

      if (t?.infarctionLocationId == null) {
        showValidationError("Location of Infarction based on ECG is mandatory");
        return false;
      }

      if (t?.loadingDoseLocationId == null) {
        showValidationError("Loading Dose given at is mandatory");
        return false;
      }

      if (t?.thrombolysisLocationId == null) {
        showValidationError("Thrombolysis done at is mandatory");
        return false;
      }

      // Conditional: only if thrombolysis done at this hospital or pre-hospital
      if (t?.thrombolysisLocationId == 1 || t?.thrombolysisLocationId == 2) {
        if (t?.thrombolyticAgentId == null) {
          showValidationError(
              "Thrombolytic Agent is mandatory when thrombolysis is done");
          return false;
        }

        if (t?.thrombolysisDate == null) {
          showValidationError("Date & Time of thrombolysis is mandatory");
          return false;
        }

        // if (t?.thrombolysisOutcomeId == null) {
        //   showValidationError("Thrombolysis outcome is mandatory");
        //   return false;
        // }
      }

      // Conditional: only if patient planned for CAG
      if (t?.plannedCag == true) {
        // if (t?.coronoryAngiographyId == null) {
        //   showValidationError(
        //       "Coronary angiography selection is mandatory when planned for CAG");
        //   return false;
        // }

        if (t?.cathLabArrival == null) {
          showValidationError(
              "Cath Lab Arrival Date & Time is mandatory when planned for CAG");
          return false;
        }

        if (t?.balloonInflation == null) {
          showValidationError(
              "Date and Time of Balloon inflation is mandatory when planned for CAG");
          return false;
        }

        if (t?.stentTypeId == null) {
          showValidationError(
              "Type of Stent used is mandatory when balloon inflation done");
          return false;
        }
      }

      // Killip risk score required for certain treatment strategies (as per your existing logic)
      if (t?.treatmentStrategyId == 3 ||
          t?.treatmentStrategyId == 4 ||
          t?.treatmentStrategyId == 5 ||
          t?.treatmentStrategyId == 6) {
        if (t?.killipRiskScoreId == null) {
          showValidationError(
              "Killip risk score is mandatory for selected treatment strategy");
          return false;
        }
      }
      if (isSubmit == false) {
        if (o?.outcomeTypeId == null) {
          showValidationError("Outcome is mandatory");
          return false;
        }
      }
    }

    // ------------------- NSTEMI (diagnosis == 2) -------------------
    if (diagnosis == 2) {
      final t = model.nstemiTreatment;
      final o = model.nstemiOutcome;

      if (t?.nstemiConfirmedAt == null) {
        showValidationError("NSTEMI Confirmed (Date & Time) is mandatory");
        return false;
      }

      if (t?.loadingDoseLocationId == null) {
        showValidationError("Loading Dose given at is mandatory");
        return false;
      }

      if (t?.timiRiskScoreId == null) {
        showValidationError("TIMI risk score is mandatory");
        return false;
      }

      if (t?.treatmentStrategyId == null) {
        showValidationError("Treatment Strategy is mandatory");
        return false;
      }

      if (t?.plannedCag == true) {
        if (t?.coronoryAngiographyId == null) {
          showValidationError(
              "Coronary angiography is mandatory when CAG planned");
          return false;
        }

        if (t?.cathLabArrival == null) {
          showValidationError("Cath Lab Arrival is mandatory when CAG planned");
          return false;
        }

        if (t?.balloonInflation == null) {
          showValidationError(
              "Balloon inflation time is mandatory when CAG planned");
          return false;
        }

        if (t?.stentTypeId == null) {
          showValidationError(
              "Stent type is mandatory when balloon inflation done");
          return false;
        }
      }
      if (isSubmit == false) {
        if (o?.outcomeTypeId == null) {
          showValidationError("Outcome is mandatory");
          return false;
        }
      }
    }

    // ------------------- Unstable Angina (diagnosis == 1) -------------------
    if (diagnosis == 1) {
      final t = model.unstableanginaTreatment;
      final o = model.unstableanginaOutcome;

      if (t?.nstemiConfirmedAt == null) {
        showValidationError("Unstable Angina Confirmed Date is mandatory");
        return false;
      }

      if (t?.loadingDoseLocationId == null) {
        showValidationError("Loading Dose given at is mandatory");
        return false;
      }

      if (t?.timiRiskScoreId == null) {
        showValidationError("TIMI risk score is mandatory");
        return false;
      }

      if (t?.treatmentStrategyId == null) {
        showValidationError("Treatment Strategy is mandatory");
        return false;
      }

      if (t?.plannedCag == true) {
        if (t?.coronoryAngiographyId == null) {
          showValidationError(
              "Coronary angiography is mandatory when CAG planned");
          return false;
        }

        if (t?.cathLabArrival == null) {
          showValidationError("Cath Lab Arrival is mandatory when CAG planned");
          return false;
        }

        if (t?.balloonInflation == null) {
          showValidationError(
              "Balloon inflation time is mandatory when CAG planned");
          return false;
        }

        if (t?.stentTypeId == null) {
          showValidationError(
              "Stent type is mandatory when balloon inflation done");
          return false;
        }
      }
      if (isSubmit == false) {
        if (o?.outcomeTypeId == null) {
          showValidationError("Outcome is mandatory");
          return false;
        }
      }
    }
    // ------------------- Others (diagnosis == 4) -------------------
    if (diagnosis == 4) {
      final t = model.othersTreatment;

      if (t?.isProcedureDone == null) {
        showValidationError("Procedure Done is mandatory");
        return false;
      }

      if (t?.isProcedureDone == true && t?.procedureId == null) {
        showValidationError("Procedure Done in Cath Lab is mandatory");
        return false;
      }

      if (isSubmit == false) {
        if (t?.outcomeTypeId == null) {
          showValidationError("Outcome is mandatory");
          return false;
        }
      }
    }
    return true;
  }

  Widget buildOutcomeFields21(OthersTreatment? others) {
    switch (others?.outcomeTypeId) {
      case 1:
      case 2:
      case 3:
        return CommonDateTimeWidget(
          title: "Date & Time of Discharge",
          dateTime: others?.dischargeDatetime?.toString() ?? "",
          onChanged: (picked) {
            others?.dischargeDatetime = picked.toString();
            stemiController.stemiModel.refresh();
            updateHospitalStayDuration(others?.dischargeDatetime.toString());
          },
        );

      case 4: // Absconded
        return CommonDateTimeWidget(
          title: "Date & Time Absconded",
          dateTime: others?.abscondedDatetime?.toString() ?? "",
          onChanged: (picked) {
            others?.abscondedDatetime = picked.toString();
          },
        );

      case 5: // Death
        return Column(
          spacing: 10,
          children: [
            // Obx(() {
            //   final list = stemiController.stemiLookup.value.deathTiming ?? [];
            //   if (list.isEmpty) return const Text("No options available");
            //   return NewTitleDropdown(
            //     title: "Time of Death",
            //     hint: "Select Date & Time",
            //     items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
            //     selectedId: others?.deathTimingId,
            //     onChanged: (val) {
            //       others?.deathTimingId = val;
            //     },
            //   );
            // }),
            TitleTextFormField(
              title: "Cause of Death",
              hintText: "Enter Cause",
              initialValue: others?.causeOfDeath ?? "",
              onChanged: (val) {
                others?.causeOfDeath = val;
              },
            ),
            Obx(() {
              final list =
                  stemiController.stemiLookup.value.nstemiDeathTiming ?? [];
              if (list.isEmpty) {
                return const Text("No Type of Sting available");
              }
              return NewTitleDropdown(
                title: 'Timing of Death Relative to Treatment Strategy',
                hint: 'Select Type',
                items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
                selectedId:
                    int.tryParse(others?.procedureId.toString() ?? '') ?? 1,
                onChanged: (val) {
                  others?.procedureId = val;
                  stemiController.stemiModel.refresh();
                },
              );
            }),

            if (int.tryParse(others!.procedureId.toString()) == 6)
              TitleTextFormField(
                title: "Others",
                hintText: "Others",
                initialValue: others?.otherProcedure ?? "",
                onChanged: (val) {
                  others?.otherProcedure = val;
                },
              ),
          ],
        );

      case 6: // Transferred
        return Column(
          spacing: 10,
          children: [
            NewTitleDropdown(
              title: "Hospital Type",
              hint: "Select Type",
              items: stemiController.stemiLookup.value.hospitalType
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: others?.hospitalTypeId,
              onChanged: (val) {
                others?.hospitalTypeId = val;
                stemiController.stemiModel.refresh();
              },
            ),
            if (others?.hospitalTypeId == 1)
              NewTitleDropdown(
                title: 'Destination hospital',
                items: hospitalController.hospitalList
                        ?.map((e) => {
                              "hospitalid": e.hospitalid ?? "",
                              "hospitalname": e.hospitalname ?? "",
                            })
                        .toList() ??
                    [],
                selectedId: others?.destinationTaeiHospital,
                hint: 'Select status',
                onChanged: (value) async {
                  others?.destinationTaeiHospital = value;
                },
              ),
            if (others?.hospitalTypeId == 2)
              TitleTextFormField(
                title: "Destination Non TAEI Hospital",
                hintText: "Enter Non TAEI Hospital Name",
                initialValue: others?.destinationHospital ?? "",
                onChanged: (val) {
                  others?.destinationHospital = val;
                },
              ),
            NewTitleDropdown(
              title: "Reason for Referral",
              hint: "Select Reason",
              items: stemiController.stemiLookup.value.referralReason
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId:
                  int.tryParse(others?.referralReasonId?.toString() ?? '') ?? 1,
              onChanged: (val) {
                others?.referralReasonId = val;
              },
            ),
            NewTitleDropdown(
              title: "Condition of Patient",
              hint: "Select Condition",
              items: stemiController.stemiLookup.value.patientCondition
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: others?.patientConditionId,
              onChanged: (val) {
                others?.patientConditionId = val;
              },
            ),
            TitleTextFormField(
              title: "Referring Doctor",
              hintText: "Enter Doctor's Name",
              initialValue: others?.referringDoctor ?? "",
              onChanged: (val) {
                others?.referringDoctor = val;
              },
            ),
            NewTitleYesRadio(
              title: "Whether details documented in TAEI Case sheet",
              initialValue: others?.documentedInTaeiCaseSheet,
              onChanged: (val) {
                others?.documentedInTaeiCaseSheet = val;
              },
            ),
          ],
        );

      case 7:
        return CommonDateTimeWidget(
          title: "Date & Time of Patient Exit",
          dateTime: others?.patientConditionId?.toString() ?? "",
          onChanged: (picked) {
            others?.patientConditionId = int.parse(picked.toString());
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildOutcomeFields2(UnstableAnginaOutcome? unstableanginaOutcome) {
    switch (unstableanginaOutcome?.outcomeTypeId) {
      case 1: // Discharge
      case 2: // Discharge variation
      case 3: // Discharge variation
        return CommonDateTimeWidget(
          title: "Date & Time of Discharge",
          dateTime: unstableanginaOutcome?.dischargeDatetime?.toString() ?? "",
          onChanged: (picked) {
            unstableanginaOutcome?.dischargeDatetime = picked.toString();
            stemiController.stemiModel.refresh();
            updateHospitalStayDuration(
                unstableanginaOutcome?.dischargeDatetime.toString());
          },
        );

      case 4: // Absconded
        return CommonDateTimeWidget(
          title: "Date & Time Absconded",
          dateTime: unstableanginaOutcome?.abscondedDatetime?.toString() ?? "",
          onChanged: (picked) {
            unstableanginaOutcome?.abscondedDatetime = picked.toString();
          },
        );

      case 5: // Death
        return Column(
          spacing: 10,
          children: [
            TitleTextFormField(
              title: "Cause of Death",
              hintText: "Enter Cause",
              initialValue: unstableanginaOutcome?.causeOfDeath ?? "",
              onChanged: (val) {
                unstableanginaOutcome?.causeOfDeath = val;
              },
            ),
            Obx(() {
              final list = stemiController.stemiLookup.value.deathTiming ?? [];

              if (list.isEmpty) {
                return const Text("No options available");
              }

              final selected = unstableanginaOutcome?.deathTimingId;

              return NewTitleDropdown(
                title: 'Timing of Death Relative to Treatment Strategy',
                hint: 'Select Type',
                items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
                selectedId: selected,
                onChanged: (val) {
                  unstableanginaOutcome?.deathTimingId = val;
                  stemiController.stemiModel.refresh();
                },
              );
            }),
            if (unstableanginaOutcome?.deathTimingId == 6) ...[
              TitleTextFormField(
                title: "Others",
                hintText: "Specify other timing",
                initialValue: unstableanginaOutcome?.otherDeathTiming ?? "",
                onChanged: (val) {
                  unstableanginaOutcome?.otherDeathTiming = val;
                  stemiController.stemiModel.refresh();
                },
              ),
            ],
          ],
        );

      case 6: // Transferred
        return Column(
          spacing: 10,
          children: [
            NewTitleDropdown(
              title: "Hospital Type",
              hint: "Select Type",
              items: stemiController.stemiLookup.value.hospitalType
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: unstableanginaOutcome?.hospitalTypeId,
              onChanged: (val) {
                unstableanginaOutcome?.hospitalTypeId = val;
              },
            ),
            TitleTextFormField(
              title: "Destination Hospital",
              hintText: "Enter Hospital Name",
              initialValue: unstableanginaOutcome?.destinationHospital ?? "",
              onChanged: (val) {
                unstableanginaOutcome?.destinationHospital = val;
              },
            ),
            NewTitleDropdown(
              title: "Reason for Referral",
              hint: "Select Reason",
              items: stemiController.stemiLookup.value.referralReason
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: int.tryParse(
                      unstableanginaOutcome?.referralReasonId?.toString() ??
                          '') ??
                  1,
              onChanged: (val) {
                unstableanginaOutcome?.referralReasonId = val;
              },
            ),
            NewTitleDropdown(
              title: "Condition of Patient",
              hint: "Select Condition",
              items: stemiController.stemiLookup.value.patientCondition
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: unstableanginaOutcome?.patientConditionId,
              onChanged: (val) {
                unstableanginaOutcome?.patientConditionId = val;
              },
            ),
            TitleTextFormField(
              title: "Referring Doctor",
              hintText: "Enter Doctor's Name",
              initialValue: unstableanginaOutcome?.referringDoctor ?? "",
              onChanged: (val) {
                unstableanginaOutcome?.referringDoctor = val;
              },
            ),
            NewTitleYesRadio(
              title: "Whether details documented in TAEI Case sheet",
              initialValue: unstableanginaOutcome?.documentedInTaeiCaseSheet,
              onChanged: (val) {
                unstableanginaOutcome?.documentedInTaeiCaseSheet = val;
              },
            ),
          ],
        );

      case 7: // Patient Exit
        return CommonDateTimeWidget(
          title: "Date & Time of Patient Exit",
          dateTime: unstableanginaOutcome?.patientConditionId?.toString() ?? "",
          onChanged: (picked) {
            unstableanginaOutcome?.patientConditionId =
                int.parse(picked.toString());
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildOutcomeFields1(NstemiOutcome? nstemiOutcome) {
    switch (nstemiOutcome?.outcomeTypeId) {
      case 1:
      case 2:
      case 3:
        return CommonDateTimeWidget(
          title: "Date & Time of Discharge",
          dateTime: nstemiOutcome?.dischargeDatetime?.toString() ?? "",
          onChanged: (picked) {
            nstemiOutcome?.dischargeDatetime = picked.toString();
            stemiController.stemiModel.refresh();
            updateHospitalStayDuration(
                nstemiOutcome?.dischargeDatetime.toString());
          },
        );
      case 4: // Absconded
        return CommonDateTimeWidget(
          title: "Date & Time Absconded",
          dateTime: nstemiOutcome?.abscondedDatetime?.toString() ?? "",
          onChanged: (picked) {
            nstemiOutcome?.abscondedDatetime = picked.toString();
          },
        );
      case 5: // Death
        return Column(
          spacing: 10,
          children: [
            // Obx(() {
            //   final list =
            //       stemiController.stemiLookup.value.nstemiDeathTiming ?? [];
            //   if (list.isEmpty) return const Text("No options available");
            //   return NewTitleDropdown(
            //     title: "Time of Death",
            //     hint: "Select Date & Time",
            //     items: list.map((e) => {"id": e.id, "name": e.name}).toList(),
            //     selectedId: nstemiOutcome?.deathTimingId,
            //     onChanged: (val) {
            //       nstemiOutcome?.deathTimingId = val;
            //     },
            //   );
            // }),
            Obx(() {
              final list = stemiController.stemiLookup.value.deathTiming ?? [];

              if (list.isEmpty) {
                return const Text("No options available");
              }

              return NewTitleDropdown(
                title: 'Timing of Death Relative to Treatment Strategy',
                hint: 'Select Type',
                items: list.map((e) => {"id": e.id, "name": e.name}).toList(),

                // Safe: deathTimingId is int? → dropdown usually handles null fine
                selectedId: nstemiOutcome?.deathTimingId,

                onChanged: (val) {
                  // val is usually int from your dropdown → safe cast
                  nstemiOutcome?.deathTimingId = val;

                  // Refresh model → UI updates immediately
                  stemiController.stemiModel.refresh();
                },
              );
            }),

            if (nstemiOutcome?.deathTimingId == 7) ...[
              TitleTextFormField(
                title: "Others (specify)",
                hintText: "",
                initialValue: nstemiOutcome?.otherDeathTiming ?? "",
                onChanged: (val) {
                  nstemiOutcome?.otherDeathTiming = val;

                  // Important: refresh after text change too
                  stemiController.stemiModel.refresh();
                },
              ),
            ],

            TitleTextFormField(
              title: "Cause of Death",
              hintText: "Enter Cause",
              initialValue: nstemiOutcome?.causeOfDeath ?? "",
              onChanged: (val) {
                nstemiOutcome?.causeOfDeath = val;
              },
            ),
          ],
        );
      case 6:
        return Column(
          spacing: 10,
          children: [
            NewTitleDropdown(
              title: "Hospital Type",
              hint: "Select Type",
              items: stemiController.stemiLookup.value.hospitalType
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: nstemiOutcome?.hospitalTypeId,
              onChanged: (val) {
                nstemiOutcome?.hospitalTypeId = val;
              },
            ),
            TitleTextFormField(
              title: "Destination Hospital",
              hintText: "Enter Hospital Name",
              initialValue: nstemiOutcome?.destinationHospital ?? "",
              onChanged: (val) {
                nstemiOutcome?.destinationHospital = val;
              },
            ),
            NewTitleDropdown(
              title: "Reason for Referral",
              hint: "Select Reason",
              items: stemiController.stemiLookup.value.referralReason
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: (int.tryParse(
                      nstemiOutcome?.referringDoctor?.toString() ?? '') ??
                  1),

              // selectedId: int.parse(nstemiOutcome!.referringDoctor.toString()),
              onChanged: (val) {
                nstemiOutcome?.referringDoctor = val.toString();
              },
            ),
            NewTitleDropdown(
              title: "Condition of Patient",
              hint: "Select Condition",
              items: stemiController.stemiLookup.value.patientCondition
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: nstemiOutcome?.patientConditionId,
              onChanged: (val) {
                nstemiOutcome?.patientConditionId = val;
              },
            ),
            TitleTextFormField(
              title: "Referring Doctor",
              hintText: "Enter Doctor's Name",
              initialValue: nstemiOutcome?.referringDoctor ?? "",
              onChanged: (val) {
                nstemiOutcome?.referringDoctor = val;
              },
            ),
            NewTitleYesRadio(
              title: "Whether details documented in TAEI Case sheet",
              initialValue: nstemiOutcome?.documentedInTaeiCaseSheet,
              onChanged: (val) {
                nstemiOutcome?.documentedInTaeiCaseSheet = val;
              },
            ),
          ],
        );

      case 7: // Patient Exit
        return CommonDateTimeWidget(
          title: "Date & Time of Patient Exit",
          dateTime: nstemiOutcome?.patientConditionId?.toString() ?? "",
          onChanged: (picked) {
            nstemiOutcome?.patientConditionId = int.parse(picked.toString());
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget buildOutcomeFields(StemiOutcome? stemiOutcome) {
    switch (stemiOutcome?.outcomeTypeId) {
      case 1:
      case 2:
      case 3:
        return CommonDateTimeWidget(
          title: "Date & Time of Discharge",
          dateTime: stemiOutcome?.dischargeDatetime?.toString() ?? "",
          onChanged: (picked) {
            stemiOutcome?.dischargeDatetime = picked.toString();
            stemiController.stemiModel.refresh();
            updateHospitalStayDuration(
                stemiOutcome?.dischargeDatetime.toString());
          },
        );
      case 4:
        return CommonDateTimeWidget(
          title: "Date & Time Absconded",
          dateTime: stemiOutcome?.abscondedDatetime?.toString() ?? "",
          onChanged: (picked) {
            stemiOutcome?.abscondedDatetime = picked.toString();
          },
        );

      case 5: // Death
        return Column(
          spacing: 10,
          children: [
            Obx(() {
              final list = stemiController.stemiLookup.value.deathTiming ?? [];

              if (list.isEmpty) {
                return const Text("No options available");
              }

              return NewTitleDropdown(
                title: 'Timing of Death Relative to Treatment Strategy',
                hint: 'Select Type',
                items: list.map((e) => {"id": e.id, "name": e.name}).toList(),

                // Safe: if deathTimingId is null → shows hint (recommended)
                selectedId: stemiOutcome?.deathTimingId,
                onChanged: (val) {
                  stemiOutcome?.deathTimingId = val;
                  stemiController.stemiModel.refresh(); // ← important
                },
              );
            }),
            if (stemiOutcome?.deathTimingId == 7) ...[
              TitleTextFormField(
                title: "Others (specify)",
                hintText: "Enter details here",
                initialValue: stemiOutcome?.otherDeathTiming ?? "",
                onChanged: (val) {
                  stemiOutcome?.otherDeathTiming = val;
                  stemiController.stemiModel
                      .refresh(); // ← ensures text updates are reflected
                },
              ),
            ],
            TitleTextFormField(
              title: "Cause of Death",
              hintText: "Enter Cause",
              initialValue: stemiOutcome?.causeOfDeath ?? "",
              onChanged: (val) {
                stemiOutcome?.causeOfDeath = val;
              },
            ),
          ],
        );
      case 6: // Transferred
        return Column(
          spacing: 10,
          children: [
            NewTitleDropdown(
              title: "Hospital Type",
              hint: "Select Type",
              items: stemiController.stemiLookup.value.hospitalType
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: stemiOutcome?.hospitalTypeId,
              onChanged: (val) {
                stemiOutcome?.hospitalTypeId = val;
              },
            ),
            TitleTextFormField(
              title: "Destination Hospital",
              hintText: "Enter Hospital Name",
              initialValue: stemiOutcome?.destinationHospital ?? "",
              onChanged: (val) {
                stemiOutcome?.destinationHospital = val;
              },
            ),
            NewTitleDropdown(
              title: "Reason for Referral",
              hint: "Select Reason",
              items: stemiController.stemiLookup.value.referralReason
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: stemiOutcome!.referralReasonId ?? 1,
              // int.parse(stemiOutcome!.referralReasonId.toString()??"1"),
              onChanged: (val) {
                stemiOutcome.referralReasonId = val;
              },
            ),
            NewTitleDropdown(
              title: "Condition of Patient",
              hint: "Select Condition",
              items: stemiController.stemiLookup.value.patientCondition
                      ?.map((e) => {"id": e.id, "name": e.name})
                      .toList() ??
                  [],
              selectedId: stemiOutcome?.patientConditionId,
              onChanged: (val) {
                stemiOutcome?.patientConditionId = val;
              },
            ),
            TitleTextFormField(
              title: "Referring Doctor",
              hintText: "Enter Doctor's Name",
              initialValue: stemiOutcome?.referringDoctor ?? "",
              onChanged: (val) {
                stemiOutcome?.referringDoctor = val;
              },
            ),
            NewTitleYesRadio(
              title: "Whether details documented in TAEI Case sheet",
              initialValue: stemiOutcome?.documentedInTaeiCaseSheet,
              onChanged: (val) {
                stemiOutcome?.documentedInTaeiCaseSheet = val;
              },
            ),
          ],
        );

      case 7: // Patient Exit
        return CommonDateTimeWidget(
          title: "Date & Time of Patient Exit",
          dateTime: stemiOutcome?.patientConditionId?.toString() ?? "",
          onChanged: (picked) {
            stemiOutcome?.patientConditionId = int.parse(picked.toString());
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
