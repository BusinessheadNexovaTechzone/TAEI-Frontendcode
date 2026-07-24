import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taei_gov/src/drowning/models/drowning_model.dart';
import 'package:taei_gov/src/drowning/views/create_drowning.dart';
import 'package:taei_gov/src/drowning/views/drowning_list.dart';
import 'package:taei_gov/src/poison/view/poison_form.dart';
import 'package:taei_gov/src/prem/model/prem_model.dart';
import 'package:taei_gov/src/prem/view/prem_list_page.dart';
import 'package:taei_gov/src/responsive.dart';

import 'package:taei_gov/utils/common/common_button.dart';

import 'package:taei_gov/utils/common/new_common_date_time_picker.dart';
import 'package:taei_gov/utils/common/save_submit_dialog.dart';
import 'package:taei_gov/utils/common/title_textfield.dart';
import 'package:taei_gov/utils/common/yes_or_no_radio_button.dart';
import '../../../utils/common/appbar.dart';
import '../../../utils/common/common_check_box_list.dart';
import '../../../utils/common/common_drop_down.dart';
import '../../../utils/common/date_time_common.dart';
import '../../../utils/common/injuries_parts_ui.dart';
import '../../../utils/common/list_data_radio_button.dart';
import '../../../utils/common/newchecklistbox.dart';
import '../../../utils/common/space.dart';
import '../../../utils/common/step_indicator.dart';
import '../../../utils/helpers/loading_helper.dart';
import '../../bite/controller/bites_controller.dart';
import '../../bite/model/look_up_bites.dart';
import '../../bite/model/request_model.dart' as bites;
import '../../bite/views/add_bites.dart';
import '../../burn/controller/burn_controller.dart';
import '../../burn/models/create_burn_model.dart';
import '../../emo_user/model/emo_lookup_model.dart';
import '../../hospital/controller/hospital_controller.dart';
import '../controller/prem_controller.dart';
import '../model/prem_lookup_model.dart';
import '../model/requestMode.dart' as prem;
import '../model/requestMode.dart' as premModel1;
import '../model/requestMode.dart' as premModel1;

class PremFormPage extends StatefulWidget {
  String? id;
  String? triageId;
  final String? burnId;
  final bool? isUpdate;

  PremFormPage({super.key, this.id, this.triageId, this.isUpdate, this.burnId});

  @override
  State<PremFormPage> createState() => _PremFormPageState();
}

class _PremFormPageState extends State<PremFormPage>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  HospitalController hospitalController = Get.put(HospitalController());
  bool insuranceCard = false;

  var formKey2 = GlobalKey<FormState>();

  var formKey3 = GlobalKey<FormState>();

  var formKey4 = GlobalKey<FormState>();
  String? surgical;

  var transferTo = [
    {"id": 1, "name": "WARD"},
    {"id": 2, "name": "ICU"},
    //{"id": 2, "name": "OTHER HOSPITAL"},
    {"id": 3, "name": "No"}
  ];

  // TextEditingController dateController = TextEditingController();
  // TextEditingController timeController = TextEditingController();
  PremController premController = Get.put(PremController());

  // final BitesController bitesController = Get.put(BitesController());

  String? painScale = 'severe';

  var selectedDigonsname = ''.obs;

  // final othersIndex = widget.options.indexOf("Others");

  TextEditingController painScore = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      hospitalController.getHospitalListData();
      // ----------------------------
      // Step 1: Initialize Bites model
      // ----------------------------
      // if (bitesController.bitesModelRequest.value.bitesStings == null) {
      //   bitesController.bitesModelRequest.value = bites.BitesStingsRequestModel(
      //     bitesStings: bites.BitesStings(),
      //     outcome: bites.OutcomeModel(),
      //   );
      // }

      // ----------------------------
      // Step 2: Fetch lookup data
      // ----------------------------
      await premController.getPremLookup();
      // await bitesController.getBitesLookup();
      // await hospitalController.getHospitalListData();

      // ----------------------------
      // Step 3: Determine if edit or new entry
      // ----------------------------
      if ((widget.id != null)) {
        // Editing existing data
        // if (widget.id != null) {
        // await bitesController.getBitesByTriageId(id: widget.id!);
        premController.premModel1.update((val) {
          val ??= prem.PremModel1();
          val.prem ??= prem.Prem();
          val.vitals ??= prem.Vitals();
          val.outcome ??= prem.Outcome();

          // Preserve existing dates
          val.prem?.dateTimeOfEntry =
              premController.premModel1.value.prem?.dateTimeOfEntry;
          val.prem?.dateOfAdmit =
              premController.premModel1.value.prem?.dateOfAdmit;
        });
        await premController.getPremById(id: widget.id!);
        // } else {
        //   await bitesController.getBitesByTriageId(id: widget.id!);
        // }

        // Update Prem model safely
      } else {
        // New entry: initialize default dates
        // bitesController.bitesModelRequest.update((val) {
        //   val ??= bitesController.bitesModelRequest.value;
        //   val.bitesStings ??= bites.BitesStings();
        //   val.bitesStings?.dateTimeOfEntry = DateTime.now().toIso8601String();
        //   val.bitesStings?.dateOfAdmit = DateTime.now().toIso8601String();
        // });

        premController.premModel1.update((val) {
          val ??= prem.PremModel1();
          val.prem ??= prem.Prem();
          val.vitals ??= prem.Vitals();
          val.outcome ??= prem.Outcome();
          val.prem?.dateTimeOfEntry = DateTime.now().toIso8601String();
          val.prem?.dateOfAdmit = DateTime.now().toIso8601String();
        });
      }

      debugPrint("All APIs called and models initialized successfully.");
    } catch (e) {
      debugPrint("Error initializing data: $e");
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 2, vsync: this);
  //   Future.delayed(Duration.zero, () {
  //
  //     print("APIs called after initState");
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final model = premController.premModel1.value;
    final prem = model.prem;
    final vital = model.vitals;
    final outcome = model.outcome;
    if (premController.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    // final modelBites = bitesController.bitesModelRequest.value.bitesStings;
    // final modelBitesOutcome = bitesController.bitesModelRequest.value.outcome;
    // bitesController.bitesModelRequest.value.bitesStings?.refFormId = 9;
    // bitesController.bitesModelRequest.value.bitesStings?.refId = null;
    // bitesController.bitesModelRequest.value.bitesStings?.triageId =
    //     int.parse(widget.triageId.toString());
    premController.premModel1.value.prem?.triageId =
        int.parse(widget.triageId.toString());

    // Auto calculate hospital stay duration

    return Scaffold(
      backgroundColor: context.isDesktop ? Color(0xFFF1E9E9) : Colors.white,
      appBar: CommonAppBar(
        title: 'Prem Form',
      ),
      body: Obx(
        () => premController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Container(
                  // padding: context.isDesktop
                  //     ? EdgeInsets.only(left: 30, right: 30, top: 8, bottom: 8)
                  //     : EdgeInsets.all(10),
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
                    behavior: ScrollConfiguration.of(context)
                        .copyWith(overscroll: false),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: context.isDesktop
                            ? EdgeInsets.only(
                                left: 30, right: 30, top: 8, bottom: 8)
                            : EdgeInsets.all(10),
                        child: Column(
                          spacing: 18,
                          children: [
                            // Align(
                            //     alignment: Alignment.topLeft,
                            //     child: CommonElevatedButtonM(
                            //       text: 'Download PDF',
                            //       onPressed: () async {
                            //         await premController.exportPremToPdf(premController.premModel1.value);
                            //       },
                            //     ),
                            //
                            // ),
                            // FancyStepIndicator(
                            //   currentIndex: premController.currentIndex,
                            //   stepCount: 2,
                            // ),
                            // if (premController.currentIndex.value == 1) ...[
                            //   Text("text")
                            // ],
                            SizedBox(
                              height: 8,
                            ),
                            // premController.currentIndex.value == 0
                            //     ? Container(
                            //         child: Text("TEXT"),
                            //       )
                            //     :
                            // TitleTextFormField(
                            //   title: "Triage Id",
                            //   hintText: "ID",
                            //   initialValue: premController
                            //           .premModel1.value.prem?.triageId
                            //           .toString() ??
                            //       "",
                            //   onChanged: (value) {
                            //     premController.premModel1.value.prem?.triageId =
                            //         int.parse(value.toString());
                            //   },
                            // ),

                            NewTitleYesRadio(
                              isRequired: true,
                              initialValue: premController
                                  .premModel1.value.prem?.patientAdmitted,
                              title: "Admission Details",
                              onChanged: (value) {
                                premController.premModel1.update((val) {
                                  val?.prem?.dateOfAdmit = value.toString();
                                });
                                premController.premModel1.value.prem
                                    ?.patientAdmitted = value;
                              },
                            ),
                            if (premController
                                    .premModel1.value.prem?.patientAdmitted ==
                                true) ...[
                              TitleTextFormField(
                                title: "Name of Department",
                                hintText: "Enter Department",
                                initialValue: premController
                                        .premModel1.value.prem?.nameOfDept ??
                                    "",
                                onChanged: (value) {
                                  premController.premModel1.value.prem
                                      ?.nameOfDept = value;
                                },
                              ),
                              CommonDateTimeWidget(
                                title: "Date of Admission",
                                dateTime: premController
                                        .premModel1.value.prem?.dateOfAdmit
                                        ?.toString() ??
                                    "",
                                onChanged: (picked) {
                                  premController.premModel1.value.prem
                                      ?.dateOfAdmit = picked.toString();
                                },
                              ),
                              NewTitleYesRadio(
                                title: "Is PREM Case Sheet Used?",
                                initialValue: premController
                                    .premModel1.value.prem?.isPremCasesheetUsed,
                                onChanged: (value) {
                                  premController.premModel1.value.prem
                                      ?.isPremCasesheetUsed = value;
                                },
                              ),
                            ],
                            Obx(() {
                              final counsellingList = premController
                                      .premLookup.value.presentingComplaints ??
                                  [];

                              if (counsellingList.isEmpty) {
                                return const Text("Presenting Complaints PREM");
                              }

                              final options = counsellingList
                                  .map((e) =>
                                      LooksUpItem(id: e.id, name: e.name))
                                  .toList();

                              // Directly use the list from the model
                              final selectedIds = premController.premModel1
                                      .value.prem?.presentingComplaintsPrem ??
                                  [];

                              return NewCheckboxList(
                                title: "Presenting Complaints PREM",
                                options: options,
                                isRequired: true,
                                initialSelectedIndexes: selectedIds,
                                onChanged: (selectedValues) {
                                  premController.premModel1.value.prem
                                          ?.presentingComplaintsPrem =
                                      selectedValues;
                                  premController.premModel1.refresh();
                                },
                              );
                            }),
                            if (premController.premModel1.value.prem
                                    ?.presentingComplaintsPrem
                                    ?.contains(25) ??
                                false)
                              TitleTextFormField(
                                title: 'Others specify',
                                hintText: 'Enter Others',
                                initialValue: premController.premModel1.value
                                        .prem?.othPresentingComplaintsPrem ??
                                    "",
                                onChanged: (value) {
                                  premController.premModel1.value.prem
                                      ?.othPresentingComplaintsPrem = value;
                                },
                              ),
                            CommonDateTimeWidget(
                              title: 'Date & Time of Entry',
                              dateTime: premController
                                      .premModel1.value.prem?.dateTimeOfEntry
                                      ?.toString() ??
                                  "",
                              onChanged: (value) {
                                premController.premModel1.value.prem
                                    ?.dateTimeOfEntry = value.toString();
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TitleTextFormField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    maxLength: 5,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*$'),
                                      ),
                                    ],
                                    isRequired: true,
                                    title: "Temperature",
                                    hintText: "Enter Temperature",
                                    initialValue: premController
                                            .premModel1.value.prem?.temperature
                                            ?.toString() ??
                                        "",
                                    onChanged: (value) {
                                      premController.premModel1.value.prem
                                          ?.temperature = value;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '°F',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            // TextFormField(
                            //   decoration: const InputDecoration(
                            //     labelText: 'Enter Value',
                            //     hintText: '20.30,11.33',
                            //     suffixText: 'KKK',
                            //     suffixStyle: TextStyle(
                            //       color: Colors.blue,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //     border: OutlineInputBorder(),
                            //     contentPadding: EdgeInsets.symmetric(
                            //         horizontal: 12, vertical: 16),
                            //   ),
                            // ),
                            Row(
                              children: [
                                Expanded(
                                  child: TitleTextFormField(
                                    title: "Approx Weight",
                                    hintText: "Enter Weight",
                                    isRequired: true,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*$'),
                                      ),
                                    ],
                                    initialValue: premController
                                            .premModel1.value.prem?.approxWeight
                                            ?.toString() ??
                                        "",
                                    onChanged: (value) {
                                      premController.premModel1.value.prem
                                          ?.approxWeight = value;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'kg',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            TitleTextFormField(
                              title: "Capillary Blood Glucose",
                              hintText: "Enter CBG",
                              isRequired: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              initialValue: premController
                                      .premModel1.value.prem?.cbg
                                      ?.toString() ??
                                  '',
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  premController.premModel1.value.prem?.cbg =
                                      null;
                                } else {
                                  premController.premModel1.value.prem?.cbg =
                                      value;
                                }
                              },
                            ),

                            Obx(() {
                              final devList =
                                  premController.premLookup.value.development ??
                                      [];
                              if (devList.isEmpty) {
                                return const Text(
                                    "No development values available");
                              }
                              return NewTitleDropdown(
                                isRequired: true,
                                title: 'Development',
                                hint: 'Select Development',
                                items: devList
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId: premController
                                    .premModel1.value.prem?.development,
                                onChanged: (value) {
                                  premController.premModel1.value.prem
                                      ?.development = value;
                                  premController.premModel1.refresh();
                                  print("Selected ID: $value");
                                },
                              );
                            }),

                            const SizedBox(height: 16),

                            NewTitleYesRadio(
                              title: "Co-Morbid Conditions?",
                              isRequired: true,
                              initialValue: premController
                                  .premModel1.value.prem?.coMorbidConditions,
                              onChanged: (value) {
                                premController.premModel1.value.prem
                                    ?.coMorbidConditions = value;
                              },
                            ),
                            Obx(() {
                              final devList =
                                  premController.premLookup.value.triageFlag ??
                                      [];
                              if (devList.isEmpty) {
                                return const Text(
                                    "No development values available");
                              }
                              return NewTitleDropdown(
                                title: 'Triage Flag',
                                hint: 'Triage flag',
                                isRequired: true,
                                items: devList
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId: premController
                                    .premModel1.value.prem?.development,
                                onChanged: (value) {
                                  premController.premModel1.update((val) {
                                    val?.prem?.triageFlag = value;
                                  });
                                  premController.premModel1.refresh();
                                },
                              );
                            }),
                            // NewTitleYesRadio(
                            //   initialValue: premController
                            //       .premModel1.value.prem?.patientAdmitted,
                            //   title: "Triage Flag",
                            //   onChanged: (bool value) {
                            //     premController.premModel1.update((val) {
                            //       val?.prem?.triageFlag =
                            //           value ? 2 : 1; // true = 2, false = 1
                            //     });
                            //     premController.premModel1.value.prem?.triageFlag =
                            //         value ? 2 : 1;
                            //     premController.premModel1.refresh();
                            //   },
                            // ),
                            if (premController
                                        .premModel1.value.prem?.triageFlag ==
                                    2 ||
                                premController
                                        .premModel1.value.prem?.triageFlag ==
                                    1) ...[
                              // Airway
                              Obx(() {
                                final devList =
                                    premController.premLookup.value.airway ??
                                        [];
                                if (devList.isEmpty) {
                                  return const Text(
                                      "No airway values available");
                                }
                                return NewTitleDropdown(
                                  title: 'Airway',
                                  hint: 'Select Airway',
                                  items: devList
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.airway,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.airway = value;
                                    });
                                    debugPrint("Selected Airway ID: $value");
                                  },
                                );
                              }),
                              Obx(() {
                                final list =
                                    premController.premLookup.value.breathing ??
                                        [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No breathing values available");
                                }
                                return NewTitleDropdown(
                                  title: "Breathing",
                                  hint: "Select Breathing",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.breathing,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.breathing = value;
                                    });
                                  },
                                );
                              }),
                              Obx(() {
                                final list = premController
                                        .premLookup.value.circulationHr ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No circulation HR values available");
                                }
                                return NewTitleDropdown(
                                  title: "Circulation HR",
                                  hint: "Select Circulation HR",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.circulationHr,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.circulationHr = value;
                                    });
                                  },
                                );
                              }),
                              Obx(() {
                                final list =
                                    premController.premLookup.value.perfusion ??
                                        [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No perfusion values available");
                                }
                                return NewTitleDropdown(
                                  title: "Perfusion",
                                  hint: "Select Perfusion",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.perfusion,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.perfusion = value;
                                    });
                                  },
                                );
                              }),
                              // Liver Span
                              Obx(() {
                                final list =
                                    premController.premLookup.value.liverSpan ??
                                        [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No liver span values available");
                                }
                                return NewTitleDropdown(
                                  title: "Liver Span",
                                  hint: "Select Liver Span",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.liverSpan,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.liverSpan = value;
                                    });
                                  },
                                );
                              }),
                              Obx(() {
                                final list = premController
                                        .premLookup.value.systolicBp ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No systolic BP values available");
                                }
                                return NewTitleDropdown(
                                  title: "Systolic BP",
                                  hint: "Select Systolic BP",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.systolicBp,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.systolicBp = value;
                                    });
                                  },
                                );
                              }),
                              Obx(() {
                                final list =
                                    premController.premLookup.value.map ?? [];
                                if (list.isEmpty) {
                                  return const Text("No MAP values available");
                                }
                                return NewTitleDropdown(
                                  title: "MAP",
                                  hint: "Select MAP",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.map,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.map = value;
                                    });
                                  },
                                );
                              }),
                              Obx(() {
                                final list = premController
                                        .premLookup.value.disability ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No disability values available");
                                }
                                return NewTitleDropdown(
                                  title: "Disability",
                                  hint: "Select Disability",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.disability,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.disability = value;
                                    });
                                  },
                                );
                              }),
                              Obx(() {
                                final list = premController
                                        .premLookup.value.tonePosture ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No tone & posture values available");
                                }
                                return NewTitleDropdown(
                                  title: "Tone & Posture",
                                  hint: "Select Tone & Posture",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.tonePosture,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.tonePosture = value;
                                    });
                                  },
                                );
                              }),
                              Obx(() {
                                final list = premController.premLookup.value
                                        .eyePositionMovements ??
                                    [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No eye position values available");
                                }
                                return NewTitleDropdown(
                                  title: "Eye Position & Movements",
                                  hint: "Select Eye Position",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController.premModel1.value
                                      .vitals?.eyePositionMovements,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.eyePositionMovements = value;
                                    });
                                  },
                                );
                              }),
                              Obx(() {
                                final list =
                                    premController.premLookup.value.pupils ??
                                        [];
                                if (list.isEmpty) {
                                  return const Text(
                                      "No pupils values available");
                                }
                                return NewTitleDropdown(
                                  title: "Pupils",
                                  hint: "Select Pupils",
                                  items: list
                                      .map((e) => {"id": e.id, "name": e.name})
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.vitals?.pupils,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.vitals ??= premModel1.Vitals();
                                      val.vitals!.pupils = value;
                                    });
                                  },
                                );
                              }),
                            ],

                            // Diagnosis Dropdown
                            Obx(() {
                              final diagnosisList =
                                  premController.premLookup.value.diagnosis ??
                                      [];

                              if (diagnosisList.isEmpty) {
                                return const Text(
                                    "No diagnosis values available");
                              }

                              // Selected Diagnosis ID
                              final selectedDiagnosisId = premController
                                  .premModel1.value.vitals?.diagnosis;

                              // Selected Diagnosis Name from lookup
                              final selectedDiagnosisName = diagnosisList
                                  .firstWhere(
                                    (d) => d.id == selectedDiagnosisId,
                                    orElse: () => LookupItem(
                                        id: 0,
                                        name: 'Select Diagnosis'), // dummy
                                  )
                                  .name;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  NewTitleDropdown(
                                    title: "Diagnosis",
                                    hint: 'Select Diagnosis',
                                    items: diagnosisList
                                        .map(
                                            (e) => {"id": e.id, "name": e.name})
                                        .toList(),
                                    selectedId: selectedDiagnosisId,
                                    onChanged: (value) {
                                      premController.premModel1.update((val) {
                                        val ??= premModel1.PremModel1();
                                        val.vitals ??= premModel1.Vitals();
                                        val.vitals!.diagnosis = value;
                                        val.vitals!.diagnosisRefvalue =
                                            null; // reset ref
                                      });
                                      debugPrint(premController.premModel1.value
                                              .vitals!.diagnosis
                                              .toString() +
                                          "000");
                                      premController.filteredDiagnosisRefs
                                          .value = (premController.premLookup
                                                  .value.diagnosisRef ??
                                              [])
                                          .where(
                                              (ref) => ref.diagnosisId == value)
                                          .toList();
                                      debugPrint(
                                          "Selected Diagnosis ID: $value");
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  Obx(() {
                                    final filteredRefs = premController
                                        .filteredDiagnosisRefs.value;

                                    if (filteredRefs.isEmpty) {
                                      return const Text(
                                          "No diagnosis ref values available");
                                    }

                                    final selectedDiagnosisRefId =
                                        premController.premModel1.value.vitals
                                            ?.diagnosisRefvalue;

                                    // Selected Diagnosis Ref Name from lookup
                                    final selectedRefName = filteredRefs
                                        .firstWhere(
                                          (r) => r.id == selectedDiagnosisRefId,
                                          orElse: () => DiagnosisRefItem(
                                              id: 0,
                                              diagnosisId: 0,
                                              name: 'Select Diagnosis Ref'),
                                        )
                                        .name;

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        NewTitleDropdown(
                                          title: "$selectedDiagnosisName",
                                          hint: "Select Diagnosis Ref",
                                          items: filteredRefs
                                              .map((e) =>
                                                  {"id": e.id, "name": e.name})
                                              .toList(),
                                          selectedId: selectedDiagnosisRefId,
                                          onChanged: (value) {
                                            premController.premModel1
                                                .update((val) {
                                              val ??= premModel1.PremModel1();
                                              val.vitals ??=
                                                  premModel1.Vitals();
                                              val.vitals!.diagnosisRefvalue =
                                                  value;
                                            });
                                            debugPrint(
                                                "Selected DiagnosisRef ID: $value");
                                          },
                                        ),
                                      ],
                                    );
                                  }),
                                ],
                              );
                            }),
                            Obx(() {
                              final diagnosisId = premController
                                  .premModel1.value.vitals?.diagnosis;
                              final isSpecialDiagnosis = diagnosisId == 14 ||
                                  diagnosisId == 15 ||
                                  diagnosisId == 16;
                              final mainAxisAlignment = isSpecialDiagnosis
                                  ? MainAxisAlignment.start
                                  : MainAxisAlignment.start;

                              return Row(
                                mainAxisAlignment: mainAxisAlignment,
                                children: [
                                  if (premController
                                          .premModel1.value.vitals?.diagnosis ==
                                      14) ...[
                                    // const SizedBox(width: 16),
                                    CommonElevatedButtonM(
                                      text: "Click to open the Poison form",
                                      onPressed: () async {
                                        final result = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          // user can't close by tapping outside
                                          builder: (context) => Dialog(
                                            insetPadding: context.isDesktop
                                                ? EdgeInsets.only(
                                                    left: 120,
                                                    right: 120,
                                                    bottom: 20,
                                                    top: 20)
                                                : EdgeInsets.all(20),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: SizedBox(
                                              width: double.maxFinite,
                                              child: PoisonForm(
                                                prem: true,
                                                id: widget.id,
                                                triageId:
                                                    widget.triageId.toString(),
                                                refFormId: 9,
                                                refId: widget.id,
                                              ),
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          debugPrint(
                                              "Poison form submitted successfully");
                                        }
                                      },
                                    ),
                                  ] else if (premController
                                          .premModel1.value.vitals?.diagnosis ==
                                      15) ...[
                                    // const SizedBox(width: 16),
                                    CommonElevatedButtonM(
                                      text:
                                          "Click to open the Bites and Stings Form",
                                      onPressed: () async {
                                        final result = await Get.dialog(
                                          Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            insetPadding: context.isDesktop
                                                ? EdgeInsets.only(
                                                    left: 120,
                                                    right: 120,
                                                    bottom: 20,
                                                    top: 20)
                                                : EdgeInsets.all(20),
                                            child: SizedBox(
                                              width: double.maxFinite,
                                              child: BitesFormPage(
                                                prem: true,
                                                id: widget.id,
                                                triageId: widget.triageId,
                                                refFormId: 9,
                                                refId: widget.id,
                                              ),
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          debugPrint(
                                              "Bites & Stings popup completed successfully");
                                        }
                                      },
                                    ),
                                  ] else if (premController
                                          .premModel1.value.vitals?.diagnosis ==
                                      16) ...[
                                    // const SizedBox(width: 16),
                                    CommonElevatedButtonM(
                                      text: "Click to open the Drowning Form",
                                      onPressed: () async {
                                        final result = await showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          // Prevent closing by tapping outside
                                          builder: (context) => Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            insetPadding: context.isDesktop
                                                ? EdgeInsets.only(
                                                    left: 120,
                                                    right: 120,
                                                    bottom: 20,
                                                    top: 20)
                                                : EdgeInsets.all(20),
                                            child: SizedBox(
                                              width: double.maxFinite,
                                              child: CreateDrowning(
                                                // isUpdate: false,
                                                prem: true,
                                                id: widget.id,
                                                triageId: int.parse(
                                                    widget.triageId.toString()),
                                                refFormId: 9,
                                                refId: widget.id,
                                              ),
                                            ),
                                          ),
                                        );
                                        if (result == true) {
                                          debugPrint(
                                              "Drowning form submitted successfully");
                                          // Optionally refresh data or show snackbar
                                        }
                                      },
                                    ),
                                  ],
                                ],
                              );
                            }),

                            // Procedures Done
                            Obx(() {
                              final procedureList = premController
                                      .premLookup.value.proceduresDone ??
                                  [];
                              if (procedureList.isEmpty) {
                                return const Text(
                                    "No procedure values available");
                              }
                              return NewTitleDropdown(
                                title: "Procedures Done",
                                hint: "Select Procedure",
                                items: procedureList
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId: (premController
                                            .premModel1
                                            .value
                                            .vitals
                                            ?.proceduresDone
                                            ?.isNotEmpty ??
                                        false)
                                    ? premController.premModel1.value.vitals!
                                        .proceduresDone!.first
                                    : null,
                                onChanged: (value) {
                                  premController.premModel1.update((val) {
                                    val ??= premModel1.PremModel1();
                                    val.vitals ??= premModel1.Vitals();
                                    val.vitals!.proceduresDone = [
                                      int.parse(value.toString())
                                    ]; // Store as List<int>
                                  });
                                },
                              );
                            }),
                            TitleTextFormField(
                              title: "Treatment Given",
                              hintText: "Treatment",
                              initialValue: premController
                                      .premModel1.value.vitals?.treatmentGiven
                                      ?.toString() ??
                                  "",
                              onChanged: (value) {
                                premController.premModel1.update((val) {
                                  val ??= premModel1.PremModel1();
                                  val.vitals ??= premModel1.Vitals();
                                  val.vitals!.treatmentGiven = value;
                                });
                              },
                            ),
                            const SizedBox(height: 2),
                            NewTitleYesRadio(
                              title: "Patient Shifted To PICU",
                              initialValue: premController
                                  .premModel1.value.outcome!.shifted_to_picu,
                              onChanged: (value) {
                                premController.premModel1.value.outcome!
                                    .shifted_to_picu = value;
                              },
                            ),
                            Obx(() {
                              final outcomeList =
                                  premController.premLookup.value.outcome ?? [];
                              return NewTitleDropdown(
                                title: "Outcome",
                                hint: "Select Outcome",
                                items: outcomeList
                                    .map((e) => {"id": e.id, "name": e.name})
                                    .toList(),
                                selectedId: premController
                                    .premModel1.value.outcome?.outcome,
                                onChanged: (value) {
                                  premController.premModel1.update((val) {
                                    val ??= premModel1.PremModel1();
                                    val.outcome ??= premModel1.Outcome();
                                    val.outcome!.outcome =
                                        int.parse(value.toString());
                                  });
                                },
                              );
                            }),
                            if (premController
                                    .premModel1.value.outcome?.outcome ==
                                7) ...[
                              Obx(() {
                                final hospitalTypeList = premController
                                        .premLookup.value.hospitalType ??
                                    [];
                                return NewTitleDropdown(
                                  title: "Hospital Type",
                                  hint: "Select Hospital Type",
                                  items: hospitalTypeList
                                      .map((e) => e.toJson())
                                      .toList(),
                                  selectedId: premController
                                      .premModel1.value.outcome?.hospitalType,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.outcome ??= premModel1.Outcome();
                                      val.outcome!.hospitalType =
                                          int.parse(value.toString());
                                    });
                                  },
                                );
                              }),

                              Obx(() {
                                final hospitalTypeList =
                                    hospitalController.hospitalList.value;

                                return Column(
                                  children: [
                                    if (premController.premModel1.value.outcome
                                            ?.hospitalType ==
                                        1)
                                      NewTitleDropdown(
                                        title: "Destination Hospital",
                                        hint: "Select Hospital Type",
                                        items: hospitalTypeList
                                            .map((e) => e.toJson())
                                            .toList(),
                                        selectedId: premController
                                            .premModel1
                                            .value
                                            .outcome
                                            ?.destinationTaeiHospital,
                                        onChanged: (value) {
                                          premController.premModel1
                                              .update((val) {
                                            val ??= premModel1.PremModel1();
                                            val.outcome ??=
                                                premModel1.Outcome();
                                            val.outcome!
                                                    .destinationTaeiHospital =
                                                int.parse(val.toString());
                                          });
                                        },
                                      ),
                                    if (premController.premModel1.value.outcome
                                            ?.hospitalType ==
                                        2)
                                      TitleTextFormField(
                                        title: "Destination Non TAEI Hospital",
                                        hintText:
                                            "Enter Destination Non TAEI Hospital",
                                        initialValue: premController.premModel1
                                            .value.outcome?.destinationHospital,
                                        onChanged: (val) {
                                          premController
                                                  .premModel1
                                                  .value
                                                  .outcome
                                                  ?.destinationHospital =
                                              val.toString();
                                        },
                                      )
                                  ],
                                );
                              }),

                              // Obx(() {
                              //   return TitleTextFormField(
                              //     title: "Destination Hospital",
                              //     hintText: "Enter Destination Hospital",
                              //     initialValue: premController.premModel1.value
                              //             .outcome?.destinationHospital
                              //             ?.toString() ??
                              //         "",
                              //     onChanged: (String? value) {
                              //       premController.premModel1.update((val) {
                              //         val ??= premModel1.PremModel1();
                              //         val.outcome ??= premModel1.Outcome();
                              //         val.outcome!.destinationHospital = 1;
                              //       });
                              //     },
                              //   );
                              // }),

                              /// Reason for Referral Dropdown
                              Obx(() {
                                final reasonList = premController
                                        .premLookup.value.reasonForReferral ??
                                    [];

                                return NewTitleDropdown(
                                  title: "Reason for Referral",
                                  hint: "Select Reason",
                                  items: reasonList
                                      .map((x) => x.toJson())
                                      .toList(),
                                  selectedId: premController.premModel1.value
                                      .outcome?.reasonForReferral,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      val ??= premModel1.PremModel1();
                                      val.outcome ??= premModel1.Outcome();
                                      val.outcome!.reasonForReferral =
                                          int.tryParse(value.toString());
                                    });
                                  },
                                );
                              }),

                              /// Condition of Patient Dropdown
                              Obx(() {
                                final conditionList = premController
                                        .premLookup.value.conditionOfPatient ??
                                    [];
                                return NewTitleDropdown(
                                  title: "Condition of Patient",
                                  hint: "Select Condition",
                                  items: conditionList
                                      .map((x) => x.toJson())
                                      .toList(),
                                  selectedId: premController.premModel1.value
                                      .outcome?.conditionOfPatient,
                                  onChanged: (value) {
                                    premController.premModel1.update((val) {
                                      // val ??= premModel1.PremModel1();
                                      // val.outcome ??= premModel1.Outcome();
                                      val?.outcome!.conditionOfPatient =
                                          int.tryParse(value.toString());
                                    });
                                  },
                                );
                              }),
                            ],
                            if (premController.premModel1.value.outcome?.outcome == 5 ||
                                premController
                                        .premModel1.value.outcome?.outcome ==
                                    2 ||
                                premController
                                        .premModel1.value.outcome?.outcome ==
                                    3) ...[
                              CommonDateTimeWidget(
                                title: "Date & Time of Discharge",
                                dateTime: premController.premModel1.value
                                        .outcome?.dischargeDate ??
                                    DateTime.now().toString(),
                                onChanged: (picked) {
                                  premController.premModel1.update((val) {
                                    // val ??= premModel1.PremModel1();
                                    // val.outcome ??= premModel1.Outcome();
                                    val?.outcome!.dischargeDate =
                                        picked.toString();
                                  });
                                },
                              )
                            ],
                            if (premController
                                    .premModel1.value.outcome?.outcome ==
                                6) ...[
                              CommonDateTimeWidget(
                                title: "Date & Time Absconded",
                                dateTime: premController.premModel1.value
                                        .outcome?.abscondedDate ??
                                    DateTime.now().toString(),
                                onChanged: (picked) {
                                  premController.premModel1.update((val) {
                                    // val ??= premModel1.PremModel1();
                                    // val.outcome ??= premModel1.Outcome();
                                    val?.outcome!.abscondedDate =
                                        picked.toString();
                                  });
                                },
                              ),
                            ],
                            if (premController
                                    .premModel1.value.outcome?.outcome ==
                                4) ...[
                              Obx(() {
                                return CommonDateTimeWidget(
                                  title: "Date & Time of Death",
                                  dateTime: premController.premModel1.value
                                          .outcome?.deathDate ??
                                      DateTime.now().toString(),
                                  onChanged: (picked) {
                                    premController.premModel1.update((val) {
                                      // val ??= premModel1.PremModel1();
                                      // val.outcome ??= premModel1.Outcome();
                                      val?.outcome!.deathDate =
                                          picked.toString();
                                    });
                                  },
                                );
                              }),
                              Obx(() {
                                return TitleTextFormField(
                                  title: "Cause of Death",
                                  hintText: "Enter Cause",
                                  initialValue: premController
                                      .premModel1.value.outcome?.causeOfDeath,
                                  onChanged: (val) {
                                    premController.premModel1.value.outcome
                                        ?.causeOfDeath = val.toString();
                                  },
                                );
                              }),
                            ],
                            if (premController
                                    .premModel1.value.outcome?.outcome ==
                                1) ...[
                              Obx(() {
                                return CommonDateTimeWidget(
                                    title: "Date & Time of Patient Exit",
                                    dateTime: premController.premModel1.value
                                            .outcome?.patientExitDate ??
                                        DateTime.now().toString(),
                                    onChanged: (val) {
                                      premController.premModel1.update((val) {
                                        // val ??= premModel1.PremModel1();
                                        // val.outcome ??= premModel1.Outcome();
                                        val?.outcome!.patientExitDate =
                                            val.toString();
                                      });
                                    });
                              }),
                            ],
                            premController.premModel1.value.outcome
                                        ?.conditionOfPatient ==
                                    2
                                ? Obx(() {
                                    final stabilisedList = premController
                                            .premLookup
                                            .value
                                            .stabilisedReferral ??
                                        [];
                                    return NewTitleDropdown(
                                      title:
                                          " If whether patient stabilised on referral",
                                      hint: "Select Status",
                                      items: stabilisedList
                                          .map((e) =>
                                              {"id": e.id, "name": e.name})
                                          .toList(),
                                      selectedId: premController
                                          .premModel1
                                          .value
                                          .outcome
                                          ?.patientStabilisedReferral,
                                      onChanged: (value) {
                                        premController.premModel1.update((val) {
                                          val ??= premModel1.PremModel1();
                                          val.outcome ??= premModel1.Outcome();
                                          val.outcome!
                                                  .patientStabilisedReferral =
                                              value;
                                        });
                                        // premController.premModel1.value.outcome
                                        //     ?.patientStabilisedReferral = value;
                                        // premController.premModel1.refresh();
                                      },
                                    );
                                  })
                                : const SizedBox(),

                            TitleTextFormField(
                              title: "Referring Doctor",
                              hintText: "Enter Doctor Name",
                              initialValue: premController.premModel1.value
                                      .outcome?.referringDoctor ??
                                  "",
                              onChanged: (value) {
                                premController.premModel1.update((val) {
                                  val ??= premModel1.PremModel1();
                                  val.outcome ??= premModel1.Outcome();
                                  val.outcome!.referringDoctor = value;
                                });
                              },
                            ),
                            Obx(() {
                              final diagnosisId = premController
                                  .premModel1.value.vitals?.diagnosis;
                              final isSpecialDiagnosis = diagnosisId == 14 ||
                                  diagnosisId == 15 ||
                                  diagnosisId == 16;
                              final mainAxisAlignment = isSpecialDiagnosis
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.center;
                              return Row(
                                mainAxisAlignment: mainAxisAlignment,
                                children: [
                                  CommonElevatedButtonM(
                                    text: widget.id == null
                                        ? 'Proceed'
                                        : 'Update',
                                    onPressed: _showSaveOrSubmitDialog,
                                  ),
                                ],
                              );
                            }),
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

  RxInt durationOfHospitalStay = 1.obs;

  void autoCalculation(String? dateOfAdmit, String? dischargeDate) {
    try {
      if (dateOfAdmit != null && dischargeDate != null) {
        final admit = DateTime.tryParse(dateOfAdmit);
        final discharge = DateTime.tryParse(dischargeDate);
        if (admit != null && discharge != null) {
          durationOfHospitalStay.value = discharge.difference(admit).inDays;
        } else {
          durationOfHospitalStay.value = 0;
        }
      } else {
        durationOfHospitalStay.value = 0;
      }
      setState(() {});
    } catch (_) {
      durationOfHospitalStay.value = 0;
    }
  }

  void _showSaveOrSubmitDialog() {
    showDialog(
      context: context,
      builder: (context) => SaveOrSubmitDialog(
        title: 'Save or Submit',
        content: 'Do you want to save or submit?',
        onSave: () => _handlePremAction(isSubmit: true),
        onSubmit: () => _handlePremAction(isSubmit: false),
      ),
    );
  }

  Future<void> _handlePremAction({required bool isSubmit}) async {
    if (!validatePremForm(isSubmit)) return;

    final premData = premController.premModel1.value;

    final int triageId =
        int.tryParse(widget.triageId.toString()) ?? 0;

    premData.prem?.triageId = triageId;

    // If isSubmit = true → discharge true
    // If isSubmit = false → discharge false
    premData.outcome?.isDischarged = isSubmit;

    bool success;

    if (widget.id == null) {
      success = await premController.createPrem(data: premData);
    } else {
      success = await premController.updatePrem(
        data: premData,
        id: widget.id.toString(),
      );
    }

    Get.back(); // Close dialog

    if (success) {
      Navigator.pop(context, true);
    }
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

  bool validatePremForm(bool isSubmit) {
    final prem = premController.premModel1.value.prem;
    final vitals = premController.premModel1.value.vitals;
    final outcome = premController.premModel1.value.outcome;

    if (prem?.patientAdmitted == null) {
      showValidationError("Please select Admission Details");
      return false;
    }

    // final age = prem?.age; // adjust if stored elsewhere
    // if (age != null && age >= 1 && age <= 12) {
    if (prem?.presentingComplaintsPrem == null ||
        prem!.presentingComplaintsPrem!.isEmpty) {
      showValidationError(
          "Please fill Presenting Complaints PREM (Age 1–12 years)");
      return false;
    }

    // 3️⃣ Temperature
    if (prem?.temperature == null || prem!.temperature!.isEmpty) {
      showValidationError("Please fill Temperature field");
      return false;
    }

    // 4️⃣ Approx Weight
    if (prem?.approxWeight == null || prem!.approxWeight!.isEmpty) {
      showValidationError("Please fill Approximate Weight field");
      return false;
    }

    // 5️⃣ CBG
    if (prem?.cbg == null) {
      showValidationError("Please fill Capillary Blood Glucose");
      return false;
    }

    // 6️⃣ Development
    if (prem?.development == null) {
      showValidationError("Please select Development field");
      return false;
    }

    // 7️⃣ Co-morbid Conditions
    if (prem?.coMorbidConditions == null) {
      showValidationError("Please select Co-morbid Conditions field");
      return false;
    }

    // 8️⃣ Triage Flag
    if (prem?.triageFlag == null) {
      showValidationError("Please select Triage Flag field");
      return false;
    }

    /// 🔴 Red / 🟡 Yellow → Validate Primary Survey
    if (prem!.triageFlag == 1 || prem.triageFlag == 2) {
      if (vitals?.airway == null) {
        showValidationError("Airway is a mandatory field");
        return false;
      }

      if (vitals?.breathing == null) {
        showValidationError("Breathing is a mandatory field");
        return false;
      }

      if (vitals?.circulationHr == null) {
        showValidationError("Circulation HR is a mandatory field");
        return false;
      }
    }
    if(isSubmit != true) {
      if (outcome?.outcome == null) {
        showValidationError("Please select Outcome");
        return false;
      }

      // 🔟 Critical / Very Critical → Stabilised on referral mandatory
      if (outcome?.conditionOfPatient == 2) {
        if (outcome?.patientStabilisedReferral == null) {
          showValidationError(
              "Please select whether patient stabilised on referral");
          return false;
        }
      }
    }

    return true;
  }

  bool validatePremForm1() {
    final prem = premController.premModel1.value.prem;
    final vitals = premController.premModel1.value.vitals;
    final outcome = premController.premModel1.value.outcome;

    if (prem?.patientAdmitted == null) {
      showValidationError("Please select Admission Details");
      return false;
    }

    // final age = prem?.age; // adjust if stored elsewhere
    // if (age != null && age >= 1 && age <= 12) {
    if (prem?.presentingComplaintsPrem == null ||
        prem!.presentingComplaintsPrem!.isEmpty) {
      showValidationError(
          "Please fill Presenting Complaints PREM (Age 1–12 years)");
      return false;
    }

    // 3️⃣ Temperature
    if (prem?.temperature == null || prem!.temperature!.isEmpty) {
      showValidationError("Please fill Temperature field");
      return false;
    }

    // 4️⃣ Approx Weight
    if (prem?.approxWeight == null || prem!.approxWeight!.isEmpty) {
      showValidationError("Please fill Approximate Weight field");
      return false;
    }

    // 5️⃣ CBG
    if (prem?.cbg == null) {
      showValidationError("Please fill Capillary Blood Glucose");
      return false;
    }

    // 6️⃣ Development
    if (prem?.development == null) {
      showValidationError("Please select Development field");
      return false;
    }

    // 7️⃣ Co-morbid Conditions
    if (prem?.coMorbidConditions == null) {
      showValidationError("Please select Co-morbid Conditions field");
      return false;
    }

    // 8️⃣ Triage Flag
    if (prem?.triageFlag == null) {
      showValidationError("Please select Triage Flag field");
      return false;
    }

    /// 🔴 Red / 🟡 Yellow → Validate Primary Survey
    if (prem!.triageFlag == 1 || prem.triageFlag == 2) {
      if (vitals?.airway == null) {
        showValidationError("Airway is a mandatory field");
        return false;
      }

      if (vitals?.breathing == null) {
        showValidationError("Breathing is a mandatory field");
        return false;
      }

      if (vitals?.circulationHr == null) {
        showValidationError("Circulation HR is a mandatory field");
        return false;
      }
    }

    return true;
  }
}

// class Vitals1 {
//   int? diagnosis;
//   int? airway;
//   int? breathing;
//   List<int>? proceduresDone;
//   String? treatmentGiven;
//
//   Vitals1(); // Default constructor
// }
