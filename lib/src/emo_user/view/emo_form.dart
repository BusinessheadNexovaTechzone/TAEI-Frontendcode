import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taei_gov/src/emo_user/controller/emo_controller.dart';
import 'package:taei_gov/src/emo_user/view/emo_details_page.dart';
import 'package:taei_gov/src/hospital/controller/hospital_controller.dart';
import 'package:taei_gov/src/nurse_triage/views/add_accident.dart';
import 'package:taei_gov/src/nurse_triage/views/triage_details_page.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/src/stemi/form_page.dart';
import 'package:taei_gov/utils/common/common_button.dart';
import 'package:taei_gov/utils/common/common_check_box_list.dart';
import 'package:taei_gov/utils/common/common_drop_down.dart';
import 'package:taei_gov/utils/common/commonpainslider.dart';
import 'package:taei_gov/utils/common/destination_hospital_dropdown.dart';
import 'package:taei_gov/utils/common/new_common_date_time_picker.dart';
import 'package:taei_gov/utils/common/new_step_indicatot.dart';
import 'package:taei_gov/utils/common/space.dart';
import 'package:taei_gov/utils/common/step_indicator.dart';
import 'package:taei_gov/utils/common/title_textfield.dart';
import 'package:taei_gov/utils/common/validation_snackbar.dart';
import 'package:taei_gov/utils/common/yes_or_no_radio_button.dart';
import '../../../utils/common/appbar.dart';

class EmoForm extends StatefulWidget {
  String? id;
  String? emoId;
  bool? isUpdate;
  bool? isAdult;

  EmoForm(
      {super.key,
      this.id,
      this.isUpdate = false,
      this.emoId,
      this.isAdult = true});

  @override
  State<EmoForm> createState() => _EmoFormState();
}

class _EmoFormState extends State<EmoForm> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  HospitalController hospitalController = Get.put(HospitalController());
  EmoController emoController = Get.put(EmoController());

  String? painScale = 'severe';

  String? dateAndTime = '2025-11-12 04:09 PM';

  // final othersIndex = widget.options.indexOf("Others");

  TextEditingController painScore = TextEditingController();

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  fetchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      emoController.isLoading(true);
      await emoController.getEmoLookup();
      await hospitalController.getHospitalListData();
      if (widget.isUpdate == true) {
        await emoController.getEmoById(id: widget.emoId.toString());
      }
      emoController.isLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> getFilteredEmergencyCategories() {
      final list = emoController.emoLookup.value.emergencyCategory ?? [];

      if (widget.isAdult == false) {
        // CHILD Categories
        List<int> childIds = [5, 6, 7, 8, 9, 2, 4];

        return list
            .where((e) => childIds.contains(e.id))
            .map((e) => {"id": e.id, "name": e.name})
            .toList();
      } else {
        // ADULT Categories
        List<int> adultIds = [1, 3, 10, 11, 5, 6, 7, 8, 12];

        return list
            .where((e) => adultIds.contains(e.id))
            .map((e) => {"id": e.id, "name": e.name})
            .toList();
      }
    }

    return Scaffold(
      backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
      //backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'EMO',
        id: widget.id,
        emo: false,
      ),
      body: Obx(() => emoController.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: context.isDesktop
                  ? EdgeInsets.only(left: 300, right: 300, top: 25, bottom: 20)
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
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: Padding(
                  padding: context.isDesktop
                      ? EdgeInsets.only(left: 30, right: 30, top: 8, bottom: 8)
                      : EdgeInsets.all(10),
                  child: ListView(
                    children: [
                      // FancyStepIndicator(
                      //     currentIndex: emoController.currentIndex,
                      //     stepCount: 2),
                      NewFancyStepIndicator(
                          currentIndex: emoController.currentIndex,
                          stepCount: 2,
                          canMoveToStep: (currentStep, tappedStep) {
                            // ❗ ONLY validate current step
                            final step = currentStep;
                            // ------------ STEP 0 VALIDATION ------------
                            if (step == 0) {
                              if (emoController
                                      .emoModel.value.emo?.emergencyCategory ==
                                  null) {
                                ValidationSnackbar.show(
                                    'Emergency Category is required');
                                ;
                              } else if (emoController.emoModel.value.emo
                                      ?.isAlcoholConsumption ==
                                  null) {
                                ValidationSnackbar.show(
                                    'Alcohol Consumption is required');
                              } else if (emoController
                                      .emoModel.value.emo?.isMlc ==
                                  null) {
                                ValidationSnackbar.show(
                                    'MLC Status is required');
                              } else if ((emoController.emoModel.value.emo
                                              ?.emergencyCategory ==
                                          1 ||
                                      emoController.emoModel.value.emo
                                              ?.emergencyCategory ==
                                          2) &&
                                  emoController.emoModel.value.emo
                                          ?.emoTraumaTreatment ==
                                      null) {
                                ValidationSnackbar.show(
                                    'Trauma Treatment is required');
                              } else {
                                return true;
                              }
                              return false;
                            }

                            // ------------ STEP 1 VALIDATION (SUBMIT) ------------
                            if (step == 1) {
                              if (emoController
                                      .emoModel.value.emoOutcome?.outcome ==
                                  null) {
                                ValidationSnackbar.show('Outcome is required');
                              } else {
                                return true;
                              }
                              return false;
                            }
                            return true;
                          }),
                      Space(
                        height: 20,
                      ),
                      emoController.currentIndex == 0
                          ? Column(
                              children: [
                                NewCheckboxList(
                                  title: 'Past History',
                                  initialSelectedIndexes: emoController.emoModel
                                              .value.emo?.pastHistory ==
                                          null
                                      ? []
                                      : emoController.emoModel.value.emo
                                              ?.pastHistory ??
                                          [],
                                  options: emoController
                                          .emoLookup.value.pastHistory ??
                                      [],
                                  onChanged: (value) {
                                    emoController.emoModel.value.emo
                                        ?.pastHistory = value;
                                    emoController.emoModel.refresh();

                                    // debugPrint(
                                    //     emoController.emoModel.value.emo?.pastHistory.toString());
                                  },
                                ),
                                emoController.emoModel.value.emo?.pastHistory
                                            ?.contains(14) ??
                                        false
                                    ? Column(
                                        children: [
                                          Space(
                                            height: 20,
                                          ),
                                          TitleTextFormField(
                                            controller:
                                                TextEditingController(text: ''),
                                            title: 'Specify Other Past History',
                                            hintText:
                                                'Enter Specify Other Past History',
                                            onChanged: (value) {},
                                          ),
                                        ],
                                      )
                                    : Container(),
                                Space(
                                  height: 20,
                                ),
                                // NewTitleDropdown(
                                //   title: 'Emergency Category',
                                //   hint: 'Select Emergency Category',
                                //   items: emoController
                                //           .emoLookup.value.emergencyCategory
                                //           ?.map((e) =>
                                //               {"id": e.id, "name": e.name})
                                //           .toList() ??
                                //       [],
                                //   selectedId: emoController
                                //       .emoModel.value.emo?.emergencyCategory,
                                //   onChanged: (value) {
                                //     emoController.emoModel.value.emo
                                //         ?.emergencyCategory = value;
                                //     print(
                                //         'Emergency Category: ${emoController.emoModel.value.emo?.emergencyCategory}');
                                //     emoController.emoModel.refresh();
                                //     print("Selected ID: $value");
                                //   },
                                // ),
                                NewTitleDropdown(
                                  title: 'Emergency Category ',
                                  isRequired: true,
                                  hint: 'Select Emergency Category',
                                  items: getFilteredEmergencyCategories(),
                                  selectedId: emoController
                                      .emoModel.value.emo?.emergencyCategory,
                                  onChanged: (value) {
                                    emoController.emoModel.value.emo
                                        ?.emergencyCategory = value;
                                    emoController.emoModel.refresh();
                                  },
                                ),

                                Space(
                                  height: 20,
                                ),
                                emoController.emoModel.value.emo
                                            ?.emergencyCategory ==
                                        12
                                    ? Column(
                                        children: [
                                          TitleTextFormField(
                                            controller: TextEditingController(
                                                text: emoController
                                                    .emoModel
                                                    .value
                                                    .emo
                                                    ?.othEmergencyCategory),
                                            title:
                                                'Specify Other Emergency Category',
                                            hintText:
                                                'Enter Specify Other Emergency Category',
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                      ?.othEmergencyCategory =
                                                  value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                TitleTextFormField(
                                  controller: TextEditingController(
                                      text: emoController
                                          .emoModel.value.emo?.diagnosis),
                                  title: 'Diagnosis',
                                  hintText: 'Enter Diagnosis',
                                  onChanged: (value) {
                                    emoController.emoModel.value.emo
                                      ?..diagnosis = value;
                                  },
                                ),
                                Space(
                                  height: 20,
                                ),
                                NewTitleYesRadio(
                                  initialValue: emoController
                                      .emoModel.value.emo?.isAlcoholConsumption,
                                  title: 'Alcohol consumption ',
                                  isRequired: true,
                                  onChanged: (value) {
                                    emoController.emoModel.value.emo
                                        ?.isAlcoholConsumption = value;
                                    emoController.emoModel.refresh();
                                    debugPrint(emoController.emoModel.value.emo
                                        ?.isAlcoholConsumption
                                        .toString());
                                  },
                                ),
                                Space(
                                  height: 20,
                                ),
                                emoController.emoModel.value.emo
                                            ?.isAlcoholConsumption ==
                                        true
                                    ? Column(
                                        children: [
                                          NewTitleYesRadio(
                                            initialValue: emoController
                                                .emoModel
                                                .value
                                                .emo
                                                ?.isPatientSmellsAlcohol,
                                            title:
                                                'Whether Patient Smells of alcohol',
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                      ?.isPatientSmellsAlcohol =
                                                  value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          NewTitleYesRadio(
                                            initialValue: emoController
                                                .emoModel
                                                .value
                                                .emo
                                                ?.isDrunkenDriveHistory,
                                            title: 'Drunken Drive History',
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                      ?.isDrunkenDriveHistory =
                                                  value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          CommonDateTimeWidget(
                                            title: 'Time Of Examination',
                                            dateTime: emoController.emoModel
                                                .value.emo?.timeOfExamination
                                                .toString(),
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                  ?.timeOfExamination = value;
                                              debugPrint(value.toString());
                                            },
                                          ),
                                          // CommonTimePicker(
                                          //   label: 'Time',
                                          //   selectedTime: emoController.emoModel.value.emo?.time,
                                          //   onTimeSelected: (value) {
                                          //     emoController.emoModel.value.emo?.time = value;
                                          //   },
                                          // ),
                                          Space(
                                            height: 20,
                                          ),
                                          // TitleTextFormField(
                                          //   controller: TextEditingController(
                                          //     text: emoController.emoModel.value.emo?.memory,
                                          //   ),
                                          //   title: 'Memory',
                                          //   hintText: 'Enter Memory',
                                          //   onChanged: (value) {
                                          //     emoController.emoModel.value.emo?.memory = value;
                                          //   },
                                          // ),
                                          // IndexTitleDropdown(
                                          //     hint: 'Select Memory',
                                          //     title: 'Memory',
                                          //     items: [
                                          //       'Select',
                                          //       'Normal',
                                          //       'Impaired',
                                          //     ],
                                          //     selectedValue: emoController
                                          //                 .emoModel
                                          //                 .value
                                          //                 .emo
                                          //                 ?.memory ==
                                          //             0
                                          //         ? 0
                                          //         : emoController.emoModel.value
                                          //             .emo?.memory,
                                          //     onChanged: (value) {
                                          //       emoController.emoModel.value.emo
                                          //           ?.memory = value;
                                          //       emoController.emoModel
                                          //           .refresh();
                                          //     }),
                                          NewTitleDropdown(
                                            title: 'Memory',
                                            hint: 'Select Memory',
                                            items: [
                                              {"id": 1, "name": "Normal"},
                                              {"id": 2, "name": "Impaired"},
                                            ],
                                            selectedId: emoController
                                                .emoModel.value.emo?.memory,
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                  ?.memory = value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          // TitleTextFormField(
                                          //   controller: TextEditingController(
                                          //     text: emoController.emoModel.value.emo?.selfControl,
                                          //   ),
                                          //   title: 'Self Control',
                                          //   hintText: 'Enter Self Control',
                                          //   onChanged: (value) {
                                          //     emoController.emoModel.value.emo?.selfControl = value;
                                          //   },
                                          // ),
                                          /* IndexTitleDropdown(
                                              hint: 'Select Self Control',
                                              title: 'Self Control',
                                              items: [
                                                'Select',
                                                'Normal',
                                                'Impaired',
                                              ],
                                              selectedValue: emoController
                                                          .emoModel
                                                          .value
                                                          .emo
                                                          ?.selfControl ==
                                                      0
                                                  ? 0
                                                  : emoController.emoModel.value
                                                      .emo?.selfControl,
                                              onChanged: (value) {
                                                emoController.emoModel.value.emo
                                                    ?.selfControl = value;
                                                print(value);
                                              })*/
                                          NewTitleDropdown(
                                            title: 'Self Control',
                                            hint: 'Select Self Control',
                                            items: [
                                              {"id": 1, "name": "Normal"},
                                              {"id": 2, "name": "Impaired"},
                                            ],
                                            selectedId: emoController.emoModel
                                                .value.emo?.selfControl,
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                  ?.selfControl = value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          NewTitleYesRadio(
                                            initialValue: emoController.emoModel
                                                .value.emo?.isSmellInBreath,
                                            title: 'Smell In Breath',
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                  ?.isSmellInBreath = value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          NewTitleYesRadio(
                                            title:
                                                'Urine Alcohol Concentration',
                                            initialValue: emoController
                                                .emoModel
                                                .value
                                                .emo
                                                ?.isUrineAlcholConcentration,
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                      ?.isUrineAlcholConcentration =
                                                  value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          // TitleTextFormField(
                                          //   controller: TextEditingController(
                                          //     text: emoController.emoModel.value.emo?.speech,
                                          //   ),
                                          //   title: 'Speech',
                                          //   hintText: 'Enter Speech ',
                                          //   onChanged: (value) {
                                          //     emoController.emoModel.value.emo?.speech = value;
                                          //   },
                                          // ),
                                          NewTitleDropdown(
                                            hint: 'Select Speech',
                                            title: 'Speech',
                                            items: emoController
                                                    .emoLookup.value.speech
                                                    ?.map((e) => {
                                                          "id": e.id,
                                                          "name": e.name
                                                        })
                                                    .toList() ??
                                                [],
                                            selectedId: emoController
                                                .emoModel.value.emo?.speech,
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                  ?.speech = value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          // TitleTextFormField(
                                          //   controller: TextEditingController(
                                          //     text: emoController
                                          //         .emoModel.value.emo?.generalDisposition,
                                          //   ),
                                          //   title: 'General Disposition',
                                          //   hintText: 'Enter General Disposition',
                                          //   onChanged: (value) {
                                          //     emoController.emoModel.value.emo?.generalDisposition =
                                          //         value;
                                          //   },
                                          // ),
                                          NewTitleDropdown(
                                              hint:
                                                  'Select General Disposition',
                                              title: 'General Disposition',
                                              items: emoController.emoLookup
                                                      .value.genDisposition
                                                      ?.map((e) => {
                                                            "id": e.id,
                                                            "name": e.name
                                                          })
                                                      .toList() ??
                                                  [],
                                              selectedId: emoController
                                                  .emoModel
                                                  .value
                                                  .emo
                                                  ?.generalDisposition,
                                              onChanged: (value) {
                                                emoController.emoModel.value.emo
                                                        ?.generalDisposition =
                                                    value;
                                              }),
                                          Space(
                                            height: 20,
                                          ),
                                          // TitleTextFormField(
                                          //   controller: TextEditingController(
                                          //     text: emoController.emoModel.value.emo?.clothing,
                                          //   ),
                                          //   title: 'Clothing',
                                          //   hintText: 'Enter Clothing ',
                                          //   onChanged: (value) {
                                          //     emoController.emoModel.value.emo?.clothing = value;
                                          //   },
                                          // ),
                                          NewTitleDropdown(
                                              hint: 'Select Clothing',
                                              title: 'Clothing',
                                              items: emoController
                                                      .emoLookup.value.clothing
                                                      ?.map((e) => {
                                                            "id": e.id,
                                                            "name": e.name
                                                          })
                                                      .toList() ??
                                                  [],
                                              selectedId: emoController
                                                  .emoModel.value.emo?.clothing,
                                              onChanged: (value) {
                                                emoController.emoModel.value.emo
                                                    ?.clothing = value;
                                              }),
                                          Space(
                                            height: 20,
                                          ),
                                          // TitleTextFormField(
                                          //   controller: TextEditingController(
                                          //     text: emoController.emoModel.value.emo?.reactionTime,
                                          //   ),
                                          //   title: 'Reaction Time',
                                          //   hintText: 'Enter Reaction Time',
                                          //   onChanged: (value) {
                                          //     emoController.emoModel.value.emo?.reactionTime = value;
                                          //   },
                                          // ),
                                          // IndexTitleDropdown(
                                          //     hint: 'Select Reaction Time',
                                          //     title: 'Reaction Time',
                                          //     items: [
                                          //       "Select",
                                          //       "Normal",
                                          //       "Delayed",
                                          //     ],
                                          //     selectedValue: emoController
                                          //                 .emoModel
                                          //                 .value
                                          //                 .emo
                                          //                 ?.reactionTime ==
                                          //             0
                                          //         ? 0
                                          //         : emoController.emoModel.value
                                          //             .emo?.reactionTime,
                                          //     onChanged: (value) {
                                          //       emoController.emoModel.value.emo
                                          //           ?.reactionTime = value;
                                          //     }),
                                          NewTitleDropdown(
                                            title: 'Reaction Time',
                                            hint: 'Select Reaction Time',
                                            items: [
                                              {"id": 1, "name": "Normal"},
                                              {"id": 2, "name": "Delayed"},
                                            ],
                                            selectedId: emoController.emoModel
                                                .value.emo?.reactionTime,
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                  ?.reactionTime = value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          // TitleTextFormField(
                                          //   controller: TextEditingController(
                                          //     text:
                                          //         emoController.emoModel.value.emo?.orientationTime,
                                          //   ),
                                          //   title: 'Orientation Time',
                                          //   hintText: 'Enter Orientation Time',
                                          //   onChanged: (value) {
                                          //     emoController.emoModel.value.emo?.orientationTime =
                                          //         value;
                                          //   },
                                          // ),
                                          NewTitleDropdown(
                                              hint: 'Select Orientation Time',
                                              title: 'Orientation Time',
                                              items: emoController.emoLookup
                                                      .value.orientationTime
                                                      ?.map((e) => {
                                                            "id": e.id,
                                                            "name": e.name
                                                          })
                                                      .toList() ??
                                                  [],
                                              selectedId: emoController.emoModel
                                                  .value.emo?.orientationTime,
                                              onChanged: (value) {
                                                emoController.emoModel.value.emo
                                                    ?.orientationTime = value;
                                              }),
                                          Space(
                                            height: 20,
                                          ),
                                          NewTitleYesRadio(
                                              initialValue: emoController
                                                  .emoModel
                                                  .value
                                                  .emo
                                                  ?.isDrugAbuse,
                                              title: 'Drug Abuse',
                                              onChanged: (value) {
                                                emoController.emoModel.value.emo
                                                    ?.isDrugAbuse = value;
                                              }),
                                          Space(
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                NewTitleYesRadio(
                                    initialValue:
                                        emoController.emoModel.value.emo?.isMlc,
                                    title: 'MLC ',
                                    isRequired: true,
                                    onChanged: (value) {
                                      emoController.emoModel.update((val) {
                                        val?.emo?.isMlc = value;
                                      });
                                    }),
                                Space(
                                  height: 20,
                                ),
                                emoController.emoModel.value.emo?.isMlc == true
                                    ? Column(
                                        children: [
                                          TitleTextFormField(
                                            controller: TextEditingController(
                                              text: emoController
                                                  .emoModel.value.emo?.arNumber,
                                            ),
                                            title: 'AR Number',
                                            hintText: 'Enter AR Number',
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                  ?.arNumber = value;
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          EmoCommonDateWidget(
                                            title: 'Date',
                                            date: emoController
                                                .emoModel.value.emo?.mlcDate
                                                .toString(),
                                            onChanged: (value) {
                                              emoController.emoModel.value.emo
                                                  ?.mlcDate = value;
                                              print(value);
                                              print(value.toString());
                                              print(emoController
                                                  .emoModel.value.emo?.mlcDate);
                                            },
                                          ),
                                          Space(
                                            height: 20,
                                          ),
                                          CommonTimeWidget(
                                              title: 'Time',
                                              time: emoController
                                                  .emoModel.value.emo?.mlcTime,
                                              onChanged: (value) {
                                                emoController.emoModel.value.emo
                                                        ?.mlcTime =
                                                    value.toString();
                                                debugPrint(value.toString());
                                              }),
                                          Space(
                                            height: 20,
                                          ),
                                        ],
                                      )
                                    : Container(),
                                CommonPainSlider(
                                  initialValue: emoController
                                              .emoModel.value.emo?.painScore !=
                                          null
                                      ? double.parse(emoController
                                          .emoModel.value.emo!.painScore
                                          .toString())
                                      : 0.0,
                                  onChanged: (value) {
                                    emoController.emoModel.value.emo
                                        ?.painScore = value.toString();
                                    emoController
                                        .emoModel.value.emo?.painScale = value <
                                            1.0
                                        ? 'No Pain'
                                        : value < 3.0
                                            ? 'Mild'
                                            : value < 5.0
                                                ? 'Moderate'
                                                : value < 7.0
                                                    ? 'Severe'
                                                    : value < 9.0
                                                        ? 'Very Severe'
                                                        : value <= 10.0
                                                            ? 'Extreme'
                                                            : value.toString();
                                    ;
                                    emoController.emoModel.refresh();
                                    painScore.text = value.toString();
                                  },
                                ),
                                Space(
                                  height: 20,
                                ),
                                TitleTextFormField(
                                  title: 'Pain Scale',
                                  hintText: 'Enter Pain Scale',
                                  controller: TextEditingController(
                                      text: emoController
                                          .emoModel.value.emo?.painScale),
                                  onChanged: (value) {
                                    emoController
                                        .emoModel.value.emo?.painScale = value;
                                  },
                                ),
                                Space(
                                  height: 20,
                                ),
                                TitleTextFormField(
                                  controller: TextEditingController(
                                      text: emoController
                                          .emoModel.value.emo?.treatmentGiven),
                                  title: 'Treatment Given',
                                  hintText: 'Enter Treatment Given',
                                  onChanged: (value) {
                                    emoController.emoModel.value.emo
                                        ?.treatmentGiven = value;
                                  },
                                ),
                                Space(
                                  height: 20,
                                ),
                                if (emoController
                                            .emoModel.value.emo?.emergencyCategory ==
                                        1 ||
                                    emoController.emoModel.value.emo
                                            ?.emergencyCategory ==
                                        2)
                                  NewTitleDropdown(
                                      isRequired: true,
                                      title:
                                          'Further Treatment Handed over to ',
                                      hint:
                                          'Select Further Treatment Handed over to',
                                      items: emoController
                                              .emoLookup.value.traumaTreatment
                                              ?.map((e) =>
                                                  {"id": e.id, "name": e.name})
                                              .toList() ??
                                          [],
                                      selectedId: emoController.emoModel.value
                                          .emo?.emoTraumaTreatment,
                                      onChanged: (value) {
                                        emoController.emoModel.value.emo
                                            ?.emoTraumaTreatment = value;
                                      }),
                                Space(
                                  height: 20,
                                ),
                                TitleTextFormField(
                                  controller: TextEditingController(
                                    text: emoController
                                        .emoModel.value.emo?.nameOfTheEmo,
                                  ),
                                  title: 'Name Of The EMO',
                                  hintText: 'Enter Name Of The EMO',
                                  onChanged: (value) {
                                    emoController.emoModel.value.emo
                                        ?.nameOfTheEmo = value;
                                  },
                                ),
                                Space(
                                  height: 20,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                NewTitleDropdown(
                                    title: 'ED OutCome ',
                                    isRequired: true,
                                    hint: 'Select ED OutCome',
                                    selectedId: emoController
                                        .emoModel.value.emoOutcome?.outcome,
                                    items: emoController
                                            .emoLookup.value.emoOutcome
                                            ?.map((e) =>
                                                {"id": e.id, "name": e.name})
                                            .toList() ??
                                        [],
                                    onChanged: (value) {
                                      emoController.emoModel.value.emoOutcome
                                          ?.outcome = value;

                                      log(value.toString());
                                      print(
                                          'Outcome : ${emoController.emoModel.value.emoOutcome?.outcome}');
                                      emoController.emoModel.refresh();
                                      print(
                                          'Outcome Memory: ${emoController.emoModel.value.emo?.memory}');
                                    }),
                                Space(
                                  height: 20,
                                ),
                                if (emoController.emoModel.value.emoOutcome?.outcome == 1 ||
                                    emoController.emoModel.value.emoOutcome
                                            ?.outcome ==
                                        2 ||
                                    emoController.emoModel.value.emoOutcome
                                            ?.outcome ==
                                        3 ||
                                    emoController.emoModel.value.emoOutcome
                                            ?.outcome ==
                                        4 ||
                                    emoController.emoModel.value.emoOutcome
                                            ?.outcome ==
                                        5 ||
                                    emoController.emoModel.value.emoOutcome
                                            ?.outcome ==
                                        6 ||
                                    emoController.emoModel.value.emoOutcome
                                            ?.outcome ==
                                        7 ||
                                    emoController.emoModel.value.emoOutcome
                                            ?.outcome ==
                                        8)
                                  CommonDateTimeWidget(
                                    title: 'Date & Time',
                                    dateTime: emoController.emoModel.value
                                        .emoOutcome?.outcomeDatetime
                                        .toString(),
                                    onChanged: (value) {
                                      emoController.emoModel.value.emoOutcome
                                          ?.outcomeDatetime = value;
                                      print(value);
                                    },
                                  ),
                                Space(
                                  height: 20,
                                ),
                                // if (emoController
                                //         .emoModel.value.emoOutcome?.outcome ==
                                //     9)
                                //   TitleTextFormField(
                                //     title: 'Send To',
                                //     hintText: 'Enter Hospital Name',
                                //     initialValue: emoController
                                //         .emoModel.value.emoOutcome?.sentTo,
                                //     onChanged: (value) {
                                //       emoController.emoModel.value.emoOutcome
                                //           ?.sentTo = value;
                                //     },
                                //   ),
                                if (emoController
                                        .emoModel.value.emoOutcome?.outcome ==
                                    10)
                                  Column(
                                    children: [
                                      NewTitleDropdown(
                                          title: 'Hospital Type',
                                          hint: 'Select Hospital Type',
                                          items: emoController
                                                  .emoLookup.value.hospitalType
                                                  ?.map((e) => {
                                                        "id": e.id ?? "",
                                                        "name": e.name ?? "",
                                                      })
                                                  .toList() ??
                                              [],
                                          selectedId: emoController.emoModel
                                              .value.emoOutcome?.hospitalType,
                                          onChanged: (value) {
                                            emoController
                                                .emoModel
                                                .value
                                                .emoOutcome
                                                ?.hospitalType = value;
                                            emoController.emoModel.refresh();
                                            log(emoController.emoModel.value
                                                .emoOutcome!.hospitalType
                                                .toString());
                                          }),
                                      Space(
                                        height: 20,
                                      ),
                                      if (emoController.emoModel.value
                                              .emoOutcome?.hospitalType ==
                                          1)
                                        // NewTitleDropdown(
                                        //     title: 'Destination hospital',
                                        //     hint: 'Select Destination hospital',
                                        //     items:
                                        //         hospitalController.hospitalList
                                        //                 .map((e) => {
                                        //                       "hospitalid":
                                        //                           e.hospitalid ??
                                        //                               "",
                                        //                       "hospitalname":
                                        //                           e.hospitalname ??
                                        //                               "",
                                        //                     })
                                        //                 .toList() ??
                                        //             [],
                                        //     selectedId: emoController
                                        //         .emoModel
                                        //         .value
                                        //         .emoOutcome
                                        //         ?.destinationTaeiHospital,
                                        //     onChanged: (value) {
                                        //       emoController
                                        //               .emoModel
                                        //               .value
                                        //               .emoOutcome
                                        //               ?.destinationTaeiHospital =
                                        //           value;
                                        //       emoController.emoModel.refresh();
                                        //     }),
                                        HospitalSearchDropdown(
                                          title: 'Destination Hospital',
                                          hint: 'Select Destination Hospital',
                                          hospitals: hospitalController
                                              .hospitalList
                                              .toList(),
                                          selectedHospitalId: emoController
                                              .emoModel
                                              .value
                                              .emoOutcome
                                              ?.destinationTaeiHospital,
                                          onSelected: (hospital) {
                                            emoController
                                                    .emoModel
                                                    .value
                                                    .emoOutcome
                                                    ?.destinationTaeiHospital =
                                                hospital.hospitalid;
                                            emoController.emoModel.refresh();
                                          },
                                        ),
                                      if (emoController.emoModel.value
                                              .emoOutcome?.hospitalType ==
                                          2)
                                        TitleTextFormField(
                                          controller: TextEditingController(
                                            text: emoController
                                                .emoModel
                                                .value
                                                .emoOutcome
                                                ?.destinationHospital,
                                          ),
                                          title: 'Name Of Non TAEI Hospital',
                                          hintText:
                                              'Enter Name Of Non TAEI Hospital',
                                          onChanged: (value) {
                                            emoController
                                                .emoModel
                                                .value
                                                .emoOutcome
                                                ?.destinationHospital = value;
                                          },
                                        ),
                                      NewTitleDropdown(
                                          title: 'Reason for referral',
                                          hint: 'Select Reason',
                                          items: emoController.emoLookup.value
                                                  .reasonForReferral
                                                  ?.map((e) => {
                                                        "id": e.id ?? "",
                                                        "name": e.name ?? "",
                                                      })
                                                  .toList() ??
                                              [],
                                          selectedId: emoController
                                              .emoModel
                                              .value
                                              .emoOutcome
                                              ?.reasonForReferral,
                                          onChanged: (value) {
                                            emoController
                                                .emoModel
                                                .value
                                                .emoOutcome
                                                ?.reasonForReferral = value;
                                            emoController.emoModel.refresh();
                                          }),
                                      NewTitleDropdown(
                                          title: 'Condition of patient',
                                          hint: 'Select Condition',
                                          items: emoController.emoLookup.value
                                                  .conditionOfPatient
                                                  ?.map((e) => {
                                                        "id": e.id ?? "",
                                                        "name": e.name ?? "",
                                                      })
                                                  .toList() ??
                                              [],
                                          selectedId: emoController
                                              .emoModel
                                              .value
                                              .emoOutcome
                                              ?.conditionOfPatient,
                                          onChanged: (value) {
                                            emoController
                                                .emoModel
                                                .value
                                                .emoOutcome
                                                ?.conditionOfPatient = value;
                                            emoController.emoModel.refresh();
                                          }),
                                      TitleTextFormField(
                                        title: 'Referring Doctor Name',
                                        controller: TextEditingController(
                                            text: emoController
                                                .emoModel
                                                .value
                                                .emoOutcome
                                                ?.referringDoctorName),
                                        keyboardType: TextInputType.name,
                                        hintText: 'Enter Doctor Name',
                                        onChanged: (v) {
                                          emoController
                                              .emoModel
                                              .value
                                              .emoOutcome
                                              ?.referringDoctorName = v;
                                        },
                                      ),
                                    ],
                                  )
                              ],
                            ),
                      Row(
                        children: [
                          if (emoController.currentIndex.value > 0)
                            CommonElevatedButtonM(
                                text: 'Back',
                                onPressed: () {
                                  emoController.currentIndex.value =
                                      emoController.currentIndex.value - 1;
                                }),
                          Spacer(),
                          /*CommonElevatedButtonM(
                              text: emoController.currentIndex.value == 1
                                  ? 'Submit'
                                  : 'Next',
                              onPressed: () async {
                                if (emoController.currentIndex.value == 1) {
                                  log(jsonEncode(emoController
                                      .emoModel.value.emo
                                      ?.toString()));
                                  if (widget.isUpdate == false) {
                                    emoController.emoModel.value.emo?.triageId =
                                        int.parse(widget.id!);
                                    // log(jsonEncode(emoController
                                    //     .emoModel.value.emo
                                    //     ?.toString()));
                                    await emoController.createEmo(
                                        data: emoController.emoModel.value);
                                  } else {
                                    await emoController.updateEmo(
                                        data: emoController.emoModel.value,
                                        id: widget.emoId!);
                                  }
                                } else {
                                  emoController.currentIndex.value =
                                      emoController.currentIndex.value + 1;
                                }
                              })*/

                          CommonElevatedButtonM(
                            text: emoController.currentIndex.value == 1
                                ? 'Submit'
                                : 'Next',
                            onPressed: () async {
                              final step = emoController.currentIndex.value;

                              // ------------ STEP 0 VALIDATION ------------
                              if (step == 0) {
                                if (emoController.emoModel.value.emo
                                        ?.emergencyCategory ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Emergency Category is required');
                                  return;
                                }

                                if (emoController.emoModel.value.emo
                                        ?.isAlcoholConsumption ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Alcohol Consumption is required');
                                  return;
                                }
                                if (emoController.emoModel.value.emo?.isMlc ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'MLC Status is required');
                                  return;
                                }
                                if ((emoController.emoModel.value.emo
                                                ?.emergencyCategory ==
                                            1 ||
                                        emoController.emoModel.value.emo
                                                ?.emergencyCategory ==
                                            2) &&
                                    emoController.emoModel.value.emo
                                            ?.emoTraumaTreatment ==
                                        null) {
                                  ValidationSnackbar.show(
                                      'Trauma Treatment is required');
                                  return;
                                }
                              }

                              // ------------ STEP 1 VALIDATION (SUBMIT) ------------
                              if (step == 1) {
                                if (emoController
                                        .emoModel.value.emoOutcome?.outcome ==
                                    null) {
                                  ValidationSnackbar.show(
                                      'Outcome is required');
                                  return;
                                }
                              }

                              // ------------ SUBMIT / NEXT LOGIC ------------
                              if (step == 1) {
                                log(jsonEncode(emoController.emoModel.value.emo
                                    ?.toString()));

                                if (widget.isUpdate == false) {
                                  emoController.emoModel.value.emo?.triageId =
                                      int.parse(widget.id!);

                                  await emoController.createEmo(
                                    data: emoController.emoModel.value,
                                  );
                                } else {
                                  await emoController.updateEmo(
                                    data: emoController.emoModel.value,
                                    id: widget.emoId!,
                                  );
                                }
                              } else {
                                emoController.currentIndex.value = step + 1;
                              }
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )),
    );
  }
}
